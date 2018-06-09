# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/)
and this project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [2.2.0]

## Added

- Added support for passing additional context to policies via `#policy_context`

## Fixed

- Allowed support for accessing operation params by either string or symbol

## [2.1.1]

### Fixed

- Fixed generated specs in namespaced engines

## [2.1.0]

### Added

- Implemented support for using the generators in mountable engines

### Changed

- Replaced `feature` with `include` in generators and tests

### Fixed

- Fixed edge cases in collection rendering for resources without a decorator

## [2.0.0]

First Pragma 2 release.

[Unreleased]: https://github.com/pragmarb/pragma-rails/compare/v2.2.0...HEAD
[2.2.0]: https://github.com/pragmarb/pragma-rails/compare/v2.1.1...v2.2.0
[2.1.1]: https://github.com/pragmarb/pragma-rails/compare/v2.1.0...v2.1.1
[2.1.0]: https://github.com/pragmarb/pragma-rails/compare/v2.0.0...v2.1.0
[2.0.0]: https://github.com/pragmarb/pragma-rails/compare/v1.2.4...v2.0.0
