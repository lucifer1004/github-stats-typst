// Contribution heatmap card — GitHub-style 52×7 grid
//
// Displays a year of contribution data with:
// - Total contributions count and streak info
// - Year labels for multi-year spans
// - Weekday labels (S M T W T F S)
// - Color-coded cells (5 levels)
// - Legend showing intensity scale

#import "common.typ": theme, stats, conf, format-number

// Page setup — matches profile.typ width
#show: conf

// Cell dimensions (fit within card width)
#let cell-size = 7pt
#let cell-gap = 1pt
#let cell-radius = 2pt

/// Get heatmap color for a contribution level.
/// - level (integer): 0-4, where 0 is empty and 4 is max activity
/// -> color
#let heatmap-color(level) = {
  let idx = calc.min(calc.max(int(level), 0), 4)
  theme.heatmap.at(idx)
}

// Extract calendar data
#let calendar = stats.at("contribution_calendar", default: none)
#let streaks = stats.at("streaks", default: none)

// Build the heatmap grid
#let build-heatmap() = {
  if calendar == none {
    return text(fill: theme.dim)[No contribution data available]
  }

  let weeks = calendar.weeks

  // Weekday labels (0=Sun, 1=Mon, ..., 6=Sat)
  // GitHub shows Mon at row 1, so we reorder: Mon=0, Tue=1, ..., Sun=6
  let weekday-labels = ("S", "M", "T", "W", "T", "F", "S")

  // Build year labels from first day of each week
  let year-labels = ()
  let last-year = -1
  for week in weeks {
    if week.days.len() > 0 {
      let date-str = week.days.at(0).date
      let year = int(date-str.slice(0, 4))
      if year != last-year {
        year-labels.push((
          week-idx: year-labels.len(),
          year: year,
        ))
        last-year = year
      } else {
        year-labels.push(none)
      }
    } else {
      year-labels.push(none)
    }
  }

  // Main content
  block(
    fill: theme.card-bg,
    stroke: 1pt + theme.border,
    radius: 6pt,
    inset: 16pt,
    width: 100%,
  )[
    // Header with stats
    #grid(
      columns: (1fr, auto),
      align: (left, right),
      [
        #text(size: 14pt, weight: "bold", fill: theme.fg)[
          #format-number(calendar.total_contributions) contributions
        ]
        #text(size: 10pt, fill: theme.dim)[in the last year]
      ],
      if streaks != none [
        #text(size: 9pt, fill: theme.dim)[
          Current: #text(fill: theme.accent, weight: "semibold")[#streaks.current_streak days]
          #h(8pt)
          Longest: #text(fill: theme.accent, weight: "semibold")[#streaks.longest_streak days]
        ]
      ],
    )

    #v(12pt)

    // Fixed column widths for weeks
    #let week-columns = (..range(weeks.len()).map(_ => cell-size))

    // Year labels row (aligned to week columns)
    #box(inset: (left: 20pt))[
      #grid(
        columns: week-columns,
        column-gutter: cell-gap,
        ..weeks
          .enumerate()
          .map(((i, _)) => {
            let label-info = year-labels.at(i, default: none)
            if label-info != none {
              box(width: cell-size, height: 10pt)[
                #text(size: 8pt, fill: theme.dim)[#label-info.year]
              ]
            } else {
              box(width: cell-size, height: 10pt)
            }
          })
      )
    ]

    // Heatmap grid with weekday labels
    #grid(
      columns: (auto, 1fr),
      column-gutter: 4pt,
      align: (right + horizon, left),

      // Weekday labels column
      grid(
        rows: 7,
        row-gutter: cell-gap,
        ..weekday-labels.map(label => {
          box(
            height: cell-size,
            width: 16pt,
            align(center)[#text(size: 8pt, fill: theme.dim)[#label]],
          )
        })
      ),

      // Heatmap cells
      grid(
        columns: week-columns,
        rows: 7,
        column-gutter: cell-gap,
        row-gutter: cell-gap,
        ..{
          let cells = ()
          // For each row (day of week: 0=Sun mapped to bottom, Mon=top)
          // GitHub uses: row 0 = Mon, row 6 = Sun
          for day-idx in range(7) {
            for week in weeks {
              // Map: day-idx 0 = Monday (index 1 in ISO week)
              // GitHub data: index 0 = Sunday
              // So we need: our row 0 (Mon) = data index 1, row 6 (Sun) = data index 0
              let data-idx = if day-idx == 6 { 0 } else { day-idx + 1 }
              let day = week.days.at(data-idx, default: none)
              // Always render a cell; use level 0 color if no data
              let level = if day != none { day.level } else { 0 }
              let is-year-start = if day != none {
                day.date.slice(5, 10) == "01-01"
              } else { false }
              cells.push(
                box(
                  width: cell-size,
                  height: cell-size,
                  fill: heatmap-color(level),
                  radius: cell-radius,
                  stroke: if is-year-start { 1pt + theme.accent } else { none },
                ),
              )
            }
          }
          cells
        }
      ),
    )

    #v(8pt)

    // Legend
    #align(right)[
      #box(inset: (right: 0pt))[
        #text(size: 8pt, fill: theme.dim)[Less]
        #h(4pt)
        #for level in range(5) {
          box(
            width: cell-size,
            height: cell-size,
            fill: heatmap-color(level),
            radius: cell-radius,
          )
          h(2pt)
        }
        #h(2pt)
        #text(size: 8pt, fill: theme.dim)[More]
      ]
    ]
  ]
}

#build-heatmap()
