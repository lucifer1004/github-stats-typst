// Profile stats card — displays user info, repo counts, and activity bars
//
// Renders: name, username, account age, repos/stars/forks/followers,
// and horizontal bars for commits/PRs/issues.

#import "common.typ": theme, stats, conf, format-number, card-frame

#show: conf.with(text-size: 11pt)

// --- helpers ---

/// Centered stat box with large value and small label.
#let stat-box(value, label) = block(
  width: 100%,
  inset: (x: 0pt, y: 16pt),
  align(center)[
    #text(size: 24pt, weight: "bold", fill: theme.fg)[#value]
    #v(4pt)
    #text(size: 9pt, weight: "medium", fill: theme.dim)[#upper(label)]
  ],
)

#let bar-max-width = 220pt

/// Horizontal bar showing activity count with proportional fill.
#let activity-bar(label, value, max-val, color) = {
  let ratio = if max-val > 0 { calc.min(value / max-val, 1.0) } else { 0 }
  let bar-width = ratio * bar-max-width
  grid(
    columns: (70pt, 1fr, 60pt),
    gutter: 12pt,
    align(left + horizon, text(size: 10pt, weight: "medium", fill: theme.dim, label)),
    align(left + horizon)[
      #box(
        width: 100%,
        height: 8pt,
        radius: 4pt,
        fill: theme.card-bg,
        clip: true,
        box(
          width: bar-width,
          height: 8pt,
          radius: 4pt,
          fill: color,
        ),
      )
    ],
    align(right + horizon, text(size: 11pt, weight: "semibold", fill: theme.fg, format-number(value))),
  )
}

// --- card ---

#let max-activity = calc.max(stats.commits, stats.prs, stats.issues, 1)

#card-frame(
  radius: 12pt,
  clip: true,
)[
  // Header section
  #block(
    width: 100%,
    inset: (x: 24pt, top: 24pt, bottom: 20pt),
  )[
    #align(center)[
      #text(size: 20pt, weight: "bold", fill: theme.fg)[
        #if stats.name != none { stats.name } else { stats.username }
      ]
      #v(6pt)
      #grid(
        columns: 2,
        column-gutter: 8pt,
        align: (left + bottom, left + bottom),
        text(size: 12pt, fill: theme.dim)[\@#stats.username],
        box(
            inset: (x: 8pt, y: 3pt),
            radius: 10pt,
            fill: theme.card-bg,
        )[
          #text(size: 10pt, weight: "medium", fill: theme.dim)[
            #stats.account_age_years yrs
          ]
        ]
      )
    ]
  ]

  // Divider
  #line(length: 100%, stroke: 0.5pt + theme.border)

  // Stats grid section
  #block(
    width: 100%,
    fill: theme.card-bg,
    inset: (x: 16pt, y: 8pt),
  )[
    #grid(
      columns: (1fr, 1fr, 1fr, 1fr),
      stat-box(format-number(stats.repos), "Repos"),
      stat-box(format-number(stats.stars), "Stars"),
      stat-box(format-number(stats.forks), "Forks"),
      stat-box(format-number(stats.followers), "Followers"),
    )
  ]

  // Divider
  #line(length: 100%, stroke: 0.5pt + theme.border)

  // Activity section
  #block(
    width: 100%,
    inset: (x: 24pt, y: 20pt),
  )[
    #text(size: 10pt, weight: "semibold", fill: theme.dim)[ACTIVITY]
    #v(14pt)
    #activity-bar("Commits", stats.commits, max-activity, theme.bar.at(0))
    #v(10pt)
    #activity-bar("Pull Requests", stats.prs, max-activity, theme.bar.at(1))
    #v(10pt)
    #activity-bar("Issues", stats.issues, max-activity, theme.bar.at(2))
  ]
]
