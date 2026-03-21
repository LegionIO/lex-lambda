# frozen_string_literal: true

RSpec.describe Legion::Extensions::Lambda::Runners::Management do # rubocop:disable Metrics/BlockLength
  let(:mock_lambda) { instance_double(Aws::Lambda::Client) }
  let(:client) { Legion::Extensions::Lambda::Client.new }

  before do
    allow(Aws::Lambda::Client).to receive(:new).and_return(mock_lambda)
  end

  describe '#create_function' do
    it 'creates a function and returns configuration hash' do
      code = { zip_file: 'binary_data' }
      resp = double(to_h: { function_name: 'new-func', runtime: 'ruby3.2' })
      expect(mock_lambda).to receive(:create_function).with(
        function_name: 'new-func',
        runtime:       'ruby3.2',
        handler:       'handler.main',
        role:          'arn:aws:iam::123:role/lambda-role',
        code:          code
      ).and_return(resp)
      result = client.create_function(
        function_name: 'new-func',
        runtime:       'ruby3.2',
        handler:       'handler.main',
        role:          'arn:aws:iam::123:role/lambda-role',
        code:          code
      )
      expect(result[:function_name]).to eq('new-func')
    end
  end

  describe '#update_function_code' do
    it 'updates function code with zip file' do
      resp = double(to_h: { function_name: 'my-func' })
      expect(mock_lambda).to receive(:update_function_code).with(
        function_name: 'my-func',
        zip_file:      'binary'
      ).and_return(resp)
      result = client.update_function_code(function_name: 'my-func', zip_file: 'binary')
      expect(result[:function_name]).to eq('my-func')
    end

    it 'updates function code with S3 source' do
      resp = double(to_h: { function_name: 'my-func' })
      expect(mock_lambda).to receive(:update_function_code).with(
        function_name: 'my-func',
        s3_bucket:     'my-bucket',
        s3_key:        'function.zip'
      ).and_return(resp)
      client.update_function_code(function_name: 'my-func', s3_bucket: 'my-bucket', s3_key: 'function.zip')
    end

    it 'does not pass nil source params' do
      resp = double(to_h: {})
      expect(mock_lambda).to receive(:update_function_code).with(
        function_name: 'my-func'
      ).and_return(resp)
      client.update_function_code(function_name: 'my-func')
    end
  end

  describe '#update_function_configuration' do
    it 'updates function configuration' do
      resp = double(to_h: { function_name: 'my-func', timeout: 30 })
      expect(mock_lambda).to receive(:update_function_configuration).with(
        function_name: 'my-func',
        timeout:       30
      ).and_return(resp)
      result = client.update_function_configuration(function_name: 'my-func', timeout: 30)
      expect(result[:timeout]).to eq(30)
    end
  end

  describe '#delete_function' do
    it 'deletes a function and returns confirmation' do
      expect(mock_lambda).to receive(:delete_function).with(function_name: 'old-func')
      result = client.delete_function(function_name: 'old-func')
      expect(result[:deleted]).to be true
      expect(result[:function_name]).to eq('old-func')
    end
  end
end
