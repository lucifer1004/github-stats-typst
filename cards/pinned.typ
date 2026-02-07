// Pinned repositories card — vertical list of highlighted repos
//
// Displays each pinned repo with:
// - Name (linked style) and language badge
// - Description (if available)
// - Stars, forks, recent changes (+/-), last commit date

#import "common.typ": theme, stats, conf, format-number

// Page setup — matches profile.typ width
#show: conf.with()

/// Format date string to relative time (e.g., "2d ago", "1w ago").
/// - date-str (string): ISO date string (YYYY-MM-DD)
/// -> string
#let format-relative-date(date-str) = {
  if date-str == none { return "—" }

  // Parse date string (YYYY-MM-DD)
  let parts = date-str.split("-")
  if parts.len() != 3 { return date-str }

  let year = int(parts.at(0))
  let month = int(parts.at(1))
  let day = int(parts.at(2))

  // Get today's date from datetime
  let today = datetime.today()
  let today-days = today.year() * 365 + today.month() * 30 + today.day()
  let date-days = year * 365 + month * 30 + day
  let diff = today-days - date-days

  if diff < 0 { return "future" }
  if diff == 0 { return "today" }
  if diff == 1 { return "1d ago" }
  if diff < 7 { return str(diff) + "d ago" }
  if diff < 30 { return str(calc.floor(diff / 7)) + "w ago" }
  if diff < 365 { return str(calc.floor(diff / 30)) + "mo ago" }
  return str(calc.floor(diff / 365)) + "y ago"
}

// Star icon (simple text glyph)
#let star-icon = text(size: 9pt)[★]

// Fork icon (SVG for font independence)
#let fork-icon = image("fork.svg", width: 9pt, height: 9pt)

/// Render a single repository card.
/// - repo (dictionary): Repo data with name, language, stars, forks, etc.
/// -> content
#let repo-card(repo) = {
  let lang-color = if repo.language_color != none {
    rgb(repo.language_color)
  } else {
    theme.dim
  }

  block(
    fill: theme.card-bg,
    stroke: 1pt + theme.border,
    radius: 6pt,
    inset: 12pt,
    width: 100%,
  )[
    // Row 1: Name and language
    #grid(
      columns: (1fr, auto),
      align: (left, right),
      [
        #text(weight: "bold", fill: theme.accent, size: 12pt)[#repo.name]
      ],
      if repo.language != none [
        #box(
          inset: (x: 6pt, y: 2pt),
          radius: 10pt,
          fill: lang-color.transparentize(80%),
        )[
          #box(
            width: 8pt,
            height: 8pt,
            radius: 4pt,
            fill: lang-color,
          )
          #h(4pt)
          #text(size: 9pt, fill: theme.fg)[#repo.language]
        ]
      ],
    )

    // Row 2: Description (if any)
    #if repo.description != none [
      #v(4pt)
      #text(size: 9pt, fill: theme.dim)[
        #repo.description
      ]
    ]

    #v(8pt)

    // Row 3: Stats row
    #grid(
      columns: (auto, auto, 1fr, auto),
      column-gutter: 12pt,
      align: (left, left, left, right),

      // Stars
      box(baseline: 7pt)[
        #text(fill: theme.dim)[#star-icon]
        #h(2pt)
        #text(size: 9pt)[#format-number(repo.stars)]
      ],

      // Forks
      box(baseline: 7pt)[
        #box(width: 9pt, height: 9pt, baseline: 2.5pt)[
          #align(center)[#fork-icon]
        ]
        #h(2pt)
        #text(size: 9pt)[#format-number(repo.forks)]
      ],

      // Recent activity
      box(baseline: 7pt)[
        #text(size: 9pt, fill: theme.dim)[
          #text(fill: rgb("#1a7f37"))[+#format-number(repo.recent_additions)]
          #h(2pt)
          #text(fill: rgb("#cf222e"))[-#format-number(repo.recent_deletions)]
          #h(4pt)
          (#repo.recent_commits commits)
        ]
      ],

      // Last commit date
      [
        #text(size: 9pt, fill: theme.dim)[
          #format-relative-date(repo.last_commit_date)
        ]
      ],
    )
  ]
}

// Main content
#let pinned-repos = stats.at("pinned_repos", default: none)

#block(
  width: 100%,
)[
  #if pinned-repos == none or pinned-repos.len() == 0 [
    #block(
      fill: theme.card-bg,
      stroke: 1pt + theme.border,
      radius: 6pt,
      inset: 16pt,
      width: 100%,
    )[
      #align(center)[
        #text(fill: theme.dim)[No pinned repositories]
      ]
    ]
  ] else [
    #for (i, repo) in pinned-repos.enumerate() [
      #repo-card(repo)
      #if i < pinned-repos.len() - 1 [
        #v(8pt)
      ]
    ]
  ]
]
