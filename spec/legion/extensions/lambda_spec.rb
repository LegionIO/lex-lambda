# frozen_string_literal: true

RSpec.describe Legion::Extensions::Lambda do
  it 'has a version number' do
    expect(Legion::Extensions::Lambda::VERSION).not_to be_nil
  end

  it 'version is 0.1.0' do
    expect(Legion::Extensions::Lambda::VERSION).to eq('0.1.0')
  end
end
