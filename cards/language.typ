// Language usage card — horizontal bar chart
//
// Shows top languages by commit changes:
// - Color-coded bars matching GitHub language colors
// - Percentage of total changes
// - Summary: language count, top language, total changes

#import "common.typ": theme, stats, conf, format-number, card-frame

// Page setup — matches profile.typ width
#show: conf.with()

// Language colors (GitHub-style)
#let lang-colors = (
  "Rust": rgb("#dea584"),
  "Python": rgb("#3572A5"),
  "JavaScript": rgb("#f1e05a"),
  "TypeScript": rgb("#3178c6"),
  "Go": rgb("#00ADD8"),
  "Java": rgb("#b07219"),
  "C": rgb("#555555"),
  "C++": rgb("#f34b7d"),
  "C#": rgb("#178600"),
  "Ruby": rgb("#701516"),
  "PHP": rgb("#4F5D95"),
  "Swift": rgb("#F05138"),
  "Kotlin": rgb("#A97BFF"),
  "Scala": rgb("#c22d40"),
  "Haskell": rgb("#5e5086"),
  "Elixir": rgb("#6e4a7e"),
  "Clojure": rgb("#db5855"),
  "Lua": rgb("#000080"),
  "Perl": rgb("#0298c3"),
  "R": rgb("#198CE7"),
  "Julia": rgb("#a270ba"),
  "Dart": rgb("#00B4AB"),
  "Shell": rgb("#89e051"),
  "Bash": rgb("#89e051"),
  "PowerShell": rgb("#012456"),
  "HTML": rgb("#e34c26"),
  "CSS": rgb("#563d7c"),
  "SCSS": rgb("#c6538c"),
  "Vue": rgb("#41b883"),
  "Svelte": rgb("#ff3e00"),
  "Markdown": rgb("#083fa1"),
  "JSON": rgb("#292929"),
  "YAML": rgb("#cb171e"),
  "TOML": rgb("#9c4221"),
  "SQL": rgb("#e38c00"),
  "GraphQL": rgb("#e10098"),
  "Dockerfile": rgb("#384d54"),
  "Makefile": rgb("#427819"),
  "Nix": rgb("#7e7eff"),
  "Zig": rgb("#ec915c"),
  "OCaml": rgb("#3be133"),
  "F#": rgb("#b845fc"),
  "Erlang": rgb("#B83998"),
  "Nim": rgb("#ffc200"),
  "Crystal": rgb("#000100"),
  "V": rgb("#4f87c4"),
  "Typst": rgb("#239dad"),
)

/// Get color for a language, falling back to theme bar colors.
/// - name (string): Language name
/// - idx (integer): Index for fallback color cycling
/// -> color
#let get-lang-color(name, idx) = {
  lang-colors.at(name, default: theme.bar.at(calc.rem(idx, theme.bar.len())))
}

// Extract language data
#let languages = stats.at("language_usage", default: none)

// Bar configuration
#let bar-max-width = 280pt
#let label-width = 90pt
#let percent-width = 50pt

/// Render a single language bar with color, name, bar, and percentage.
#let lang-bar(name, changes, percent, max-changes, idx) = {
  let ratio = if max-changes > 0 { calc.min(changes / max-changes, 1.0) } else { 0 }
  let bar-width = ratio * bar-max-width
  let color = get-lang-color(name, idx)

  grid(
    columns: (label-width, 1fr, percent-width),
    gutter: 12pt,
    align(left + horizon)[
      #box(
        width: 10pt,
        height: 10pt,
        radius: 2pt,
        fill: color,
        baseline: 2pt,
      )
      #h(8pt)
      #text(size: 10pt, weight: "medium", fill: theme.fg)[#name]
    ],
    align(left + horizon)[
      #box(
        width: 100%,
        height: 10pt,
        radius: 4pt,
        fill: theme.card-bg,
        clip: true,
        box(
          width: bar-width,
          height: 10pt,
          radius: 4pt,
          fill: color,
        ),
      )
    ],
    align(right + horizon)[
      #text(size: 10pt, weight: "semibold", fill: theme.fg)[
        #calc.round(percent, digits: 1)%
      ]
    ],
  )
}

// Build language list
#let build-languages() = {
  if languages == none or languages.len() == 0 {
    return text(fill: theme.dim)[No language data available]
  }

  let max-changes = languages.at(0).at("changes", default: 0)

  let items = for (idx, lang) in languages.enumerate() {
    let name = lang.at("name", default: "Unknown")
    let changes = lang.at("changes", default: 0)
    let percent = lang.at("percent", default: 0.0)
    (lang-bar(name, changes, percent, max-changes, idx),)
  }

  stack(
    dir: ttb,
    spacing: 10pt,
    ..items,
  )
}

// Stats summary
#let stats-summary() = {
  if languages == none { return none }

  let total-langs = languages.len()
  let top-lang = if languages.len() > 0 { languages.at(0).at("name", default: "N/A") } else { "N/A" }

  // Calculate total changes
  let total-changes = 0
  for lang in languages {
    total-changes = total-changes + lang.at("changes", default: 0)
  }

  grid(
    columns: (1fr, 1fr, 1fr),
    gutter: 8pt,
    [
      #text(size: 8pt, fill: theme.dim)[Languages]
      #linebreak()
      #text(weight: "bold", size: 14pt)[#total-langs]
    ],
    [
      #text(size: 8pt, fill: theme.dim)[Top Language]
      #linebreak()
      #text(weight: "bold", size: 14pt)[#top-lang]
    ],
    [
      #text(size: 8pt, fill: theme.dim)[Total Changes]
      #linebreak()
      #text(weight: "bold", size: 14pt)[#format-number(total-changes)]
    ],
  )
}

// Main card
#card-frame(
  inset: 16pt,
)[
  // Title
  #text(weight: "bold", size: 14pt)[Most Used Languages]
  #h(1fr)
  #text(size: 7pt, fill: theme.dim)[by commit changes]

  #v(12pt)

  // Stats summary
  #stats-summary()

  #v(16pt)

  // Language bars
  #build-languages()
]
