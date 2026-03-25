# lex-lambda: AWS Lambda Integration for LegionIO

**Repository Level 3 Documentation**
- **Parent**: `/Users/miverso2/rubymine/legion/extensions-other/CLAUDE.md`
- **Grandparent**: `/Users/miverso2/rubymine/legion/CLAUDE.md`

## Purpose

Legion Extension that connects LegionIO to AWS Lambda. Provides runners for function invocation (synchronous and asynchronous), function management, and Lambda layer operations.

**GitHub**: https://github.com/LegionIO/lex-lambda
**License**: MIT
**Version**: 0.1.0

## Architecture

```
Legion::Extensions::Lambda
├── Runners/
│   ├── Functions   # list_functions, get_function, invoke_function, invoke_async
│   ├── Management  # create_function, update_function_code, update_function_configuration, delete_function
│   └── Layers      # list_layers, get_layer_version, publish_layer_version
├── Helpers/
│   └── Client      # Aws::Lambda::Client factory (region + credentials)
└── Client          # Standalone client class (includes all runners)
```

## Key Files

| Path | Purpose |
|------|---------|
| `lib/legion/extensions/lambda.rb` | Entry point, extension registration |
| `lib/legion/extensions/lambda/runners/functions.rb` | Function invocation and listing |
| `lib/legion/extensions/lambda/runners/management.rb` | Function CRUD |
| `lib/legion/extensions/lambda/runners/layers.rb` | Layer management |
| `lib/legion/extensions/lambda/helpers/client.rb` | Aws::Lambda::Client factory |
| `lib/legion/extensions/lambda/client.rb` | Standalone Client class |

## Authentication

AWS credentials via `access_key_id:`, `secret_access_key:`, and `region:` kwargs. Alternatively uses the standard AWS credential chain (env vars, instance profile, etc.) if not provided explicitly.

## Dependencies

| Gem | Purpose |
|-----|---------|
| `aws-sdk-lambda` (~> 1.0) | AWS Lambda Ruby SDK |

## Development

27 specs total.

```bash
bundle install
bundle exec rspec
bundle exec rubocop
```

---

**Maintained By**: Matthew Iverson (@Esity)
