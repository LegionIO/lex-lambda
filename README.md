# lex-lambda

Legion Extension for AWS Lambda integration. Provides function invocation, management, and layer operations.

## Installation

Add to your Gemfile:

```ruby
gem 'lex-lambda'
```

## Usage

### Standalone client

```ruby
require 'legion/extensions/lambda'

client = Legion::Extensions::Lambda::Client.new(
  region:            'us-east-1',
  access_key_id:     ENV['AWS_ACCESS_KEY_ID'],
  secret_access_key: ENV['AWS_SECRET_ACCESS_KEY']
)

client.list_functions
client.invoke_function(function_name: 'my-function', payload: { key: 'value' })
client.invoke_async(function_name: 'my-function')
```

## Runners

- `Functions`: `list_functions`, `get_function`, `invoke_function`, `invoke_async`
- `Management`: `create_function`, `update_function_code`, `update_function_configuration`, `delete_function`
- `Layers`: `list_layers`, `get_layer_version`, `publish_layer_version`

## License

MIT
