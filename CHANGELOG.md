# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [v1.1.0] - 2026-02-07

### Added

- Configurable font via `font` and `font-url` action inputs
- Auto-download Inter font in CI environment

### Fixed

- Language card name overflow with long language names (e.g., "GCC Machine Description")

## [v1.0.0] - 2026-02-07

### Added

- Initial release with 5 card types: profile, timedist, heatmap, pinned, language
- 9 themes: github, github-dark, dracula, monokai, nord, solarized-light, solarized-dark, gruvbox-dark, tokyo-night
- GitHub Action for automated stats generation
- Configurable via `github-readme-stats.toml`
