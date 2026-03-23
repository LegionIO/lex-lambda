# Changelog

## [0.1.2] - 2026-03-22

### Changed
- Add legion-cache, legion-crypt, legion-data, legion-json, legion-logging, legion-settings, legion-transport as runtime dependencies
- Update spec_helper with real sub-gem helper stubs

## [0.1.0] - 2026-03-21

### Added
- Initial release of lex-lambda AWS Lambda integration
- `Helpers::Client` — builds `Aws::Lambda::Client` with region and credential support
- `Runners::Functions` — `list_functions`, `get_function`, `invoke_function`, `invoke_async`
- `Runners::Management` — `create_function`, `update_function_code`, `update_function_configuration`, `delete_function`
- `Runners::Layers` — `list_layers`, `get_layer_version`, `publish_layer_version`
- Standalone `Client` class for use outside the Legion framework
