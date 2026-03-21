# frozen_string_literal: true

RSpec.describe Legion::Extensions::Lambda::Runners::Functions do # rubocop:disable Metrics/BlockLength
  let(:mock_lambda) { instance_double(Aws::Lambda::Client) }
  let(:client) { Legion::Extensions::Lambda::Client.new }

  before do
    allow(Aws::Lambda::Client).to receive(:new).and_return(mock_lambda)
  end

  describe '#list_functions' do
    it 'returns a list of functions' do
      func = double(function_name: 'my-func', runtime: 'ruby3.2', function_arn: 'arn:aws:lambda:us-east-1:123:function:my-func')
      allow(mock_lambda).to receive(:list_functions).and_return(double(functions: [func]))
      result = client.list_functions
      expect(result[:functions].size).to eq(1)
      expect(result[:functions].first[:name]).to eq('my-func')
      expect(result[:functions].first[:runtime]).to eq('ruby3.2')
    end

    it 'returns empty list when no functions' do
      allow(mock_lambda).to receive(:list_functions).and_return(double(functions: []))
      result = client.list_functions
      expect(result[:functions]).to be_empty
    end
  end

  describe '#get_function' do
    it 'returns function configuration as hash' do
      config = double(to_h: { function_name: 'my-func', runtime: 'ruby3.2' })
      allow(mock_lambda).to receive(:get_function).with(function_name: 'my-func').and_return(double(configuration: config))
      result = client.get_function(function_name: 'my-func')
      expect(result[:function_name]).to eq('my-func')
    end
  end

  describe '#invoke_function' do
    it 'invokes with RequestResponse and returns parsed payload' do
      payload_io = StringIO.new('{"result":"ok"}')
      allow(payload_io).to receive(:string).and_return('{"result":"ok"}')
      allow(mock_lambda).to receive(:invoke).with(
        hash_including(function_name: 'my-func', invocation_type: 'RequestResponse')
      ).and_return(double(status_code: 200, payload: payload_io, function_error: nil))
      result = client.invoke_function(function_name: 'my-func')
      expect(result[:status_code]).to eq(200)
      expect(result[:payload]).to eq({ 'result' => 'ok' })
    end

    it 'serializes hash payload to JSON' do
      payload_io = StringIO.new('{}')
      allow(payload_io).to receive(:string).and_return('{}')
      expect(mock_lambda).to receive(:invoke).with(
        hash_including(payload: '{"key":"value"}')
      ).and_return(double(status_code: 200, payload: payload_io, function_error: nil))
      client.invoke_function(function_name: 'my-func', payload: { key: 'value' })
    end

    it 'passes string payload directly' do
      payload_io = StringIO.new('{}')
      allow(payload_io).to receive(:string).and_return('{}')
      expect(mock_lambda).to receive(:invoke).with(
        hash_including(payload: 'raw-string')
      ).and_return(double(status_code: 200, payload: payload_io, function_error: nil))
      client.invoke_function(function_name: 'my-func', payload: 'raw-string')
    end

    it 'handles non-JSON payload gracefully' do
      payload_io = double
      allow(payload_io).to receive(:string).and_return('not-json')
      allow(mock_lambda).to receive(:invoke).and_return(double(status_code: 200, payload: payload_io, function_error: nil))
      result = client.invoke_function(function_name: 'my-func')
      expect(result[:payload]).to eq('not-json')
    end
  end

  describe '#invoke_async' do
    it 'invokes with Event invocation type' do
      payload_io = double
      allow(payload_io).to receive(:string).and_return(nil)
      expect(mock_lambda).to receive(:invoke).with(
        hash_including(function_name: 'my-func', invocation_type: 'Event')
      ).and_return(double(status_code: 202, payload: payload_io, function_error: nil))
      result = client.invoke_async(function_name: 'my-func')
      expect(result[:status_code]).to eq(202)
      expect(result[:async]).to be true
    end
  end
end
