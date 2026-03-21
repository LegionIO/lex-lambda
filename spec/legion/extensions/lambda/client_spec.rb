# frozen_string_literal: true

RSpec.describe Legion::Extensions::Lambda::Client do
  let(:mock_lambda) { instance_double(Aws::Lambda::Client) }

  before do
    allow(Aws::Lambda::Client).to receive(:new).and_return(mock_lambda)
  end

  describe '#initialize' do
    it 'stores default options' do
      client = described_class.new
      expect(client.opts).to include(region: 'us-east-1')
    end

    it 'accepts custom region' do
      client = described_class.new(region: 'us-west-2')
      expect(client.opts[:region]).to eq('us-west-2')
    end

    it 'stores access credentials when provided' do
      client = described_class.new(access_key_id: 'AKID', secret_access_key: 'secret')
      expect(client.opts[:access_key_id]).to eq('AKID')
      expect(client.opts[:secret_access_key]).to eq('secret')
    end

    it 'omits nil values from opts' do
      client = described_class.new
      expect(client.opts.keys).not_to include(:access_key_id)
    end
  end

  describe '#settings' do
    it 'returns a hash with options key' do
      client = described_class.new
      expect(client.settings).to eq({ options: client.opts })
    end
  end

  describe '#lambda_client' do
    it 'delegates to Helpers::Client with stored opts' do
      client = described_class.new(region: 'eu-west-1')
      expect(Aws::Lambda::Client).to receive(:new).with(hash_including(region: 'eu-west-1'))
      client.lambda_client
    end
  end
end
