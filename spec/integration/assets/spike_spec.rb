require 'spec_helper'

describe Assets, 'and spiking around' do
  include Assets

  let(:root) do
    Pathname.new(__FILE__).parent.parent.parent.join('assets')
  end

  let(:rules) do
    []
  end

  let(:environment) do
    Environment::Dynamic.new(root, rules)
  end

  let(:server) do
    Server.new(root, '/assets')
  end

  let(:request) do
    {
    }
  end

  let(:response) do
    server.call(request)
  end

  let(:status) do
    response[0]
  end

  context 'with unknown asset' do
    its(:status) { should be(404) }
  end
end
