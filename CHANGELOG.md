# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added

- Rust CLI fetches GitHub stats and writes JSON (WI-2026-02-07-001)
- Typst templates render terminal-style SVG cards with theme support (WI-2026-02-07-001)
- GitHub Action downloads binary, fetches stats, renders cards (WI-2026-02-07-001)
- CI workflow runs check + clippy + fmt (WI-2026-02-07-001)
- Release workflow builds Linux binary on tag push (WI-2026-02-07-001)
- Add github-dark theme variant (WI-2026-02-07-002)
- GraphQL client module in `src/api/graphql.rs` (WI-2026-02-07-003)
- Single GraphQL query fetches profile, repos, contributions, pinned items (WI-2026-02-07-003)
- Extended `UserStats` with contribution calendar and streak data (WI-2026-02-07-003)
- `PinnedRepo` struct with recent activity stats (WI-2026-02-07-003)
- `cards/heatmap.typ` template with 52×7 grid layout (WI-2026-02-07-004)
- Heatmap color scale (5 levels) in themes.typ (WI-2026-02-07-004)
- Month labels along top edge (WI-2026-02-07-004)
- Weekday labels (M, W, F) on left (WI-2026-02-07-004)
- `cards/pinned.typ` template with vertical repo list (WI-2026-02-07-005)
- Display repo name, language badge, stars, forks (WI-2026-02-07-005)
- Show recent activity (commits, +lines, -lines) (WI-2026-02-07-005)
- Show last commit date (WI-2026-02-07-005)

### Changed

- Use developer-focused color palette with improved contrast ratios (WI-2026-02-07-002)
- Apply Inter font family for clean Swiss minimalism (WI-2026-02-07-002)
- Improve visual hierarchy with better spacing and alignment (WI-2026-02-07-002)
