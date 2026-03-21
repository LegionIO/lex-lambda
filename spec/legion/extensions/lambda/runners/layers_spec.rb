# frozen_string_literal: true

RSpec.describe Legion::Extensions::Lambda::Runners::Layers do # rubocop:disable Metrics/BlockLength
  let(:mock_lambda) { instance_double(Aws::Lambda::Client) }
  let(:client) { Legion::Extensions::Lambda::Client.new }

  before do
    allow(Aws::Lambda::Client).to receive(:new).and_return(mock_lambda)
  end

  describe '#list_layers' do
    it 'returns a list of layers' do
      layer = double(layer_name: 'my-layer', layer_arn: 'arn:aws:lambda:us-east-1:123:layer:my-layer')
      allow(mock_lambda).to receive(:list_layers).and_return(double(layers: [layer]))
      result = client.list_layers
      expect(result[:layers].size).to eq(1)
      expect(result[:layers].first[:name]).to eq('my-layer')
      expect(result[:layers].first[:arn]).to eq('arn:aws:lambda:us-east-1:123:layer:my-layer')
    end

    it 'returns empty list when no layers' do
      allow(mock_lambda).to receive(:list_layers).and_return(double(layers: []))
      result = client.list_layers
      expect(result[:layers]).to be_empty
    end
  end

  describe '#get_layer_version' do
    it 'returns layer version details as hash' do
      resp = double(to_h: { layer_version_arn: 'arn:aws:lambda:us-east-1:123:layer:my-layer:1', version: 1 })
      expect(mock_lambda).to receive(:get_layer_version).with(
        layer_name:     'my-layer',
        version_number: 1
      ).and_return(resp)
      result = client.get_layer_version(layer_name: 'my-layer', version_number: 1)
      expect(result[:version]).to eq(1)
    end
  end

  describe '#publish_layer_version' do
    it 'publishes a new layer version' do
      content = { zip_file: 'binary_data' }
      resp = double(to_h: { layer_version_arn: 'arn:aws:lambda:us-east-1:123:layer:my-layer:2', version: 2 })
      expect(mock_lambda).to receive(:publish_layer_version).with(
        layer_name:          'my-layer',
        content:             content,
        compatible_runtimes: ['ruby3.2']
      ).and_return(resp)
      result = client.publish_layer_version(
        layer_name:          'my-layer',
        content:             content,
        compatible_runtimes: ['ruby3.2']
      )
      expect(result[:version]).to eq(2)
    end

    it 'publishes without compatible_runtimes when empty' do
      content = { zip_file: 'binary_data' }
      resp = double(to_h: { version: 1 })
      expect(mock_lambda).to receive(:publish_layer_version).with(
        layer_name: 'my-layer',
        content:    content
      ).and_return(resp)
      client.publish_layer_version(layer_name: 'my-layer', content: content)
    end
  end
end
