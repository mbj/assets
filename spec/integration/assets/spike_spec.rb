require 'spec_helper'

describe Assets, 'and spiking around' do

  class DummyResponse
    def initialize(tuple)
      @tuple = tuple
    end

    def content_type
      headers['Content-Type']
    end

    def body
      @tuple[2]
    end

    def headers
      @tuple[1]
    end

    def status
      @tuple[0]
    end
  end

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

  let(:rules) do
    rules = []
    rules << Assets::Rule::Concat.build('application.css', fonts, application)
  end

  let(:environment) do
    Assets::Environment::Dynamic.new(rules)
  end

  let(:server) do
    Assets::Server.new(environment, '/assets/')
  end

  let(:request) do
    { 'PATH_INFO' => path_info }
  end

  subject do 
    DummyResponse.new(server.call(request))
  end

  context 'with unknown asset' do
    let(:path_info) { '/assets/not_found.txt' }

    its(:status) { should be(404) }
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

  context 'with known asset' do
    let(:path_info)    { '/assets/application.css'             }
    its(:content_type) { should eql('text/css; charset=UTF-8') }
    its(:status)       { should be(200)                        }
    its(:body)         { should eql(expected_body)             }
  end
end
