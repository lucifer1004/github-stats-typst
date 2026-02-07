// Theme definitions for GitHub stats cards
//
// Each theme provides a consistent color palette:
// - bg: Card background color
// - fg: Primary text color
// - accent: Highlight/link color
// - dim: Secondary/muted text color
// - card-bg: Inner card/section background
// - bar: Array of 3 colors for activity bars (commits, PRs, issues)
// - border: Card border color
// - heatmap: Array of 5 colors for contribution intensity (0=empty, 4=max)

#let themes = (
  // GitHub Light — Clean, minimal, high contrast
  // Palette: Portfolio/Personal (#FAFAFA bg, #09090B fg, #2563EB accent)
  github: (
    bg: rgb("#ffffff"),
    fg: rgb("#1f2328"), // GitHub's actual fg color, better contrast
    accent: rgb("#0969da"), // GitHub blue
    dim: rgb("#656d76"), // GitHub secondary text
    card-bg: rgb("#f6f8fa"), // GitHub's card background
    bar: (
      rgb("#1a7f37"), // Green — commits (success)
      rgb("#0969da"), // Blue — PRs (info)
      rgb("#8250df"), // Purple — issues (feature)
    ),
    border: rgb("#d1d9e0"), // Subtle border
    // Heatmap colors (levels 0-4) — GitHub's actual contribution colors
    heatmap: (
      rgb("#ebedf0"), // Level 0: empty
      rgb("#9be9a8"), // Level 1: light green
      rgb("#40c463"), // Level 2: medium green
      rgb("#30a14e"), // Level 3: dark green
      rgb("#216e39"), // Level 4: darkest green
    ),
  ),
  // GitHub Dark — Developer-focused dark theme
  // Palette: Developer Tool/IDE (#0d1117 bg, #e6edf3 fg, #238636 accent)
  github-dark: (
    bg: rgb("#0d1117"), // GitHub dark bg
    fg: rgb("#e6edf3"), // GitHub dark fg
    accent: rgb("#58a6ff"), // GitHub dark blue
    dim: rgb("#7d8590"), // GitHub dark secondary
    card-bg: rgb("#161b22"), // GitHub dark card
    bar: (
      rgb("#3fb950"), // Green — commits
      rgb("#58a6ff"), // Blue — PRs
      rgb("#a371f7"), // Purple — issues
    ),
    border: rgb("#30363d"), // Dark border
    // Heatmap colors (levels 0-4) — GitHub dark theme
    heatmap: (
      rgb("#161b22"), // Level 0: empty (matches card bg)
      rgb("#0e4429"), // Level 1
      rgb("#006d32"), // Level 2
      rgb("#26a641"), // Level 3
      rgb("#39d353"), // Level 4
    ),
  ),
  // Dracula — Popular dark theme with vibrant accents
  dracula: (
    bg: rgb("#282a36"),
    fg: rgb("#f8f8f2"),
    accent: rgb("#bd93f9"), // Purple
    dim: rgb("#6272a4"), // Comment color
    card-bg: rgb("#44475a"), // Current line
    bar: (
      rgb("#50fa7b"), // Green
      rgb("#8be9fd"), // Cyan
      rgb("#ff79c6"), // Pink
    ),
    border: rgb("#44475a"),
    // Heatmap colors — Dracula purple gradient
    heatmap: (
      rgb("#44475a"), // Level 0: empty
      rgb("#6272a4"), // Level 1
      rgb("#8b7fc7"), // Level 2
      rgb("#bd93f9"), // Level 3
      rgb("#ff79c6"), // Level 4: pink highlight
    ),
  ),
  // Monokai — Warm dark theme
  monokai: (
    bg: rgb("#272822"),
    fg: rgb("#f8f8f2"),
    accent: rgb("#66d9ef"), // Cyan
    dim: rgb("#75715e"), // Comment
    card-bg: rgb("#3e3d32"), // Subtle highlight
    bar: (
      rgb("#a6e22e"), // Green
      rgb("#66d9ef"), // Cyan
      rgb("#f92672"), // Pink/Red
    ),
    border: rgb("#49483e"),
    // Heatmap colors — Monokai green gradient
    heatmap: (
      rgb("#3e3d32"), // Level 0: empty
      rgb("#5a6e3a"), // Level 1
      rgb("#7a8f4a"), // Level 2
      rgb("#98b85c"), // Level 3
      rgb("#a6e22e"), // Level 4: bright green
    ),
  ),
  // Nord — Cool, low-contrast dark theme
  nord: (
    bg: rgb("#2e3440"),
    fg: rgb("#eceff4"),
    accent: rgb("#88c0d0"),
    dim: rgb("#81a1c1"),
    card-bg: rgb("#3b4252"),
    bar: (
      rgb("#a3be8c"), // Green
      rgb("#88c0d0"), // Blue
      rgb("#b48ead"), // Purple
    ),
    border: rgb("#4c566a"),
    heatmap: (
      rgb("#3b4252"),
      rgb("#4c566a"),
      rgb("#5e81ac"),
      rgb("#81a1c1"),
      rgb("#88c0d0"),
    ),
  ),
  // Solarized Light — Soft light theme
  solarized-light: (
    bg: rgb("#fdf6e3"),
    fg: rgb("#586e75"),
    accent: rgb("#268bd2"),
    dim: rgb("#839496"),
    card-bg: rgb("#eee8d5"),
    bar: (
      rgb("#859900"),
      rgb("#268bd2"),
      rgb("#6c71c4"),
    ),
    border: rgb("#e0d7c3"),
    heatmap: (
      rgb("#eee8d5"),
      rgb("#b8c49b"),
      rgb("#93a49b"),
      rgb("#859900"),
      rgb("#268bd2"),
    ),
  ),
  // Solarized Dark — Balanced dark theme
  solarized-dark: (
    bg: rgb("#002b36"),
    fg: rgb("#eee8d5"),
    accent: rgb("#268bd2"),
    dim: rgb("#93a1a1"),
    card-bg: rgb("#073642"),
    bar: (
      rgb("#859900"),
      rgb("#268bd2"),
      rgb("#6c71c4"),
    ),
    border: rgb("#0f3a46"),
    heatmap: (
      rgb("#073642"),
      rgb("#0f3a46"),
      rgb("#2aa198"),
      rgb("#859900"),
      rgb("#268bd2"),
    ),
  ),
  // Gruvbox Dark — Warm contrast theme
  gruvbox-dark: (
    bg: rgb("#282828"),
    fg: rgb("#ebdbb2"),
    accent: rgb("#d79921"),
    dim: rgb("#a89984"),
    card-bg: rgb("#3c3836"),
    bar: (
      rgb("#b8bb26"),
      rgb("#83a598"),
      rgb("#d3869b"),
    ),
    border: rgb("#504945"),
    heatmap: (
      rgb("#3c3836"),
      rgb("#665c54"),
      rgb("#b8bb26"),
      rgb("#d79921"),
      rgb("#fb4934"),
    ),
  ),
  // Tokyo Night — Modern dark theme
  tokyo-night: (
    bg: rgb("#1a1b26"),
    fg: rgb("#c0caf5"),
    accent: rgb("#7aa2f7"),
    dim: rgb("#7aa2f7"),
    card-bg: rgb("#24283b"),
    bar: (
      rgb("#9ece6a"),
      rgb("#7aa2f7"),
      rgb("#bb9af7"),
    ),
    border: rgb("#414868"),
    heatmap: (
      rgb("#24283b"),
      rgb("#414868"),
      rgb("#7aa2f7"),
      rgb("#9ece6a"),
      rgb("#bb9af7"),
    ),
  ),
)
