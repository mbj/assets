require 'spec_helper'

describe Assets, 'and spiking around' do

  let(:root) do
    Pathname.new(__FILE__).parent.parent.parent.join('assets')
  end

  let(:repository) do
    Assets::Repository::Directory.new(root)
  end
  
  let(:fonts) do
    repository.file('fonts.css')
  end
  
  let(:application) do
    repository.compile('application.sass')
  end

  let(:stylesheet) do
    Assets::Rule::Concat.build('application.css', fonts, application)
  end

  let(:images) do
    repository.glob('*.jpg').map do |name|
      repository.file(name)
    end
  end

  let(:rules) do
    rules = []
    rules.concat(images)
    rules << repository.compile('application.coffee')
    rules << stylesheet
  end

  let(:environment) do
    Assets::Environment::Cache.build(rules)
  end

  let(:server) do
    Assets::Handler.new(environment, '/assets/')
  end

  let(:request) do
    Request::Rack.new({'PATH_INFO' => path_info}.merge(extra_hash))
  end

  subject do 
    server.call(application, request)
  end

  def strip_indentation(text)
    lines = text.split("\n")
    match = /\A[ ]*/.match(lines.first)
    length = match[0].length
    lines.map { |line| line[(length)..-1] }.join("\n") << "\n"
  end

  let(:expected_body) do
    strip_indentation(<<-CSS)
      // Example body of fonts.css
      body #hello {
        display: none; }
    CSS
  end

  context 'with development environment' do

    let(:asset)     { environment.get(name) }
    let(:path_info) { "/assets/#{name}"     }

    context 'accessing image' do
      let(:name)       { 'test.jpg' }
      let(:extra_hash) { {}         }
      let(:expected_body) { File.read('spec/assets/test.jpg') }

      its(:content_type)  { should eql('image/jpg')  }
      its(:last_modified) { should eql(Time.httpdate(asset.created_at.httpdate)) }
      its(:cache_control) { should eql('max-age=120, must-revalidate')           }
      its(:status)        { should be(Response::Status::OK)                      }
      its(:body)          { should eql(expected_body)                            }
    end

    context 'compiling coffescript' do
      let(:name)       { 'application.js' }
      let(:extra_hash) { {}               }
      let(:expected_body) do
        strip_indentation(<<-JAVASCRIPT)
          (function() {
            alert("Hello World");

          }).call(this);
        JAVASCRIPT
      end

      its(:content_type)  { should eql('application/javascript; charset=UTF-8')  }
      its(:last_modified) { should eql(Time.httpdate(asset.created_at.httpdate)) }
      its(:cache_control) { should eql('max-age=120, must-revalidate')           }
      its(:status)        { should be(Response::Status::OK)                      }
      its(:body)          { should eql(expected_body)                            }
    end

    context 'with unknown asset' do
      let(:name)          { 'not_found.txt'                            }
      let(:path_info)     { '/assets/not_found.txt'                    }
      let(:extra_hash)    { {}                                         }
      its(:body)          { should eql('Not Found')                    }
      its(:cache_control) { should eql('max-age=120, must-revalidate') }
      its(:status)        { should be(Response::Status::NOT_FOUND)     }
    end

    context 'with known conditional get' do


      let(:extra_hash)    { {'HTTP_IF_MODIFIED_SINCE' => lastmod_time.httpdate } }
      let(:name)          { 'application.css'                                     }

      context 'with modified_since < asset.created_at' do

        let(:lastmod_time)  { asset.created_at - 1000         }
        its(:status)        { should be(Response::Status::OK) }

        its(:body)          { should eql(expected_body)       }
        its(:content_type)  { should eql('text/css; charset=UTF-8')                }
        its(:last_modified) { should eql(Time.httpdate(asset.created_at.httpdate)) }
        its(:cache_control) { should eql('max-age=120, must-revalidate')           }

      end

      context 'with modified_since > asset.created_at' do

        let(:lastmod_time)  { asset.created_at + 1000         }
        its(:status)        { should be(Response::Status::NOT_MODIFIED) }

        its(:body)          { should be(nil)                                                  }
        its(:content_type)  { should be(nil)                                                  }
        its(:last_modified) { should eql(Time.httpdate(stylesheet.asset.created_at.httpdate)) }
        its(:cache_control) { should eql('max-age=120, must-revalidate')                      }

      end
    end

    context 'with known asset and unconditional get' do
      let(:path_info)     { '/assets/application.css'                                       }
      let(:extra_hash)    { {}                                                              }
      its(:content_type)  { should eql('text/css; charset=UTF-8')                           }
      its(:last_modified) { should eql(Time.httpdate(stylesheet.asset.created_at.httpdate)) }
      its(:cache_control) { should eql('max-age=120, must-revalidate')                      }
      its(:status)        { should be(Response::Status::OK)                                 }
      its(:body)          { should eql(expected_body)                                       }
    end

  end
end
