# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.1.0] - 2026-02-05

### Added
- Initial release
- Flow and Step DSL for defining onboarding flows
- Registry for managing flows
- Onrampable concern for models
- Progress model for tracking onboarding state
- Conditional branching with `branches_to`
- Conditional visibility with `show_if`
- Step callbacks with `after_complete`
- Flow completion callbacks with `on_complete`
- Configurable progress class and association name
- `onramp:install` generator for migration and initializer
- `onramp:flow` generator for scaffolding new flows
