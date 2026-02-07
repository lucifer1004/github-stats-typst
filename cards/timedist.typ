// Time distribution heatmap card — 7 days × 24h grid (horizontal layout)
//
// Shows when commits typically happen:
// - Rows = days of week (Mon-Sun)
// - Columns = hours of day (0-23)
// - Summary stats: total commits, peak time, peak day
// - Timezone indicator
// - Date range covered

#import "common.typ": theme, stats, conf, format-number, card-frame

// Page setup — matches profile.typ width
#show: conf.with()

// Cell dimensions (smaller to fit 24 columns)
#let cell-size = 14pt
#let cell-gap = 2pt
#let cell-radius = 2pt

// Day labels (rows)
#let day-labels = ("Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun")

// Hour labels (columns) - show every 3 hours
#let hour-labels-full = range(24).map(h => {
  if h == 0 { "12a" } else if h < 12 { str(h) + "a" } else if h == 12 { "12p" } else { str(h - 12) + "p" }
})

// Extract time distribution data
#let timedist = stats.at("time_distribution", default: none)

/// Calculate heatmap color based on count relative to max.
/// - count (integer): Number of commits in this cell
/// - max-count (integer): Maximum count across all cells
/// -> color
#let heatmap-color(count, max-count) = {
  if max-count == 0 {
    theme.heatmap.at(0)
  } else {
    let ratio = count / max-count
    let level = if ratio == 0 { 0 } else if ratio < 0.25 { 1 } else if ratio < 0.5 { 2 } else if ratio < 0.75 {
      3
    } else { 4 }
    theme.heatmap.at(level)
  }
}

// Build the time distribution grid (horizontal: rows=days, cols=hours)
#let build-grid() = {
  if timedist == none {
    return text(fill: theme.dim)[No time distribution data available]
  }

  // grid-data is [hour][day], we need to transpose to [day][hour]
  let grid-data = timedist.at("grid", default: ())
  let max-count = 0

  // Find max value
  for hour-row in grid-data {
    for count in hour-row {
      if count > max-count {
        max-count = count
      }
    }
  }

  let day-label-width = 28pt

  // Header row with hour labels (show every 3 hours)
  let header = {
    box(width: day-label-width) // Empty corner
    for h in range(24) {
      if calc.rem(h, 3) == 0 {
        box(width: cell-size + cell-gap, height: 14pt)[
          #align(center)[#text(size: 6pt, fill: theme.dim)[#hour-labels-full.at(h)]]
        ]
      } else {
        box(width: cell-size + cell-gap, height: 14pt)
      }
    }
  }

  // Data rows (one per day)
  let rows = for day-idx in range(7) {
    let row-content = {
      // Day label
      box(width: day-label-width, height: cell-size + cell-gap)[
        #align(right + horizon)[
          #text(size: 7pt, fill: theme.dim)[#day-labels.at(day-idx)]
          #h(4pt)
        ]
      ]

      // Cells for each hour (transpose: grid[hour][day])
      for hour-idx in range(24) {
        let count = if hour-idx < grid-data.len() and day-idx < grid-data.at(hour-idx).len() {
          grid-data.at(hour-idx).at(day-idx)
        } else { 0 }
        let color = heatmap-color(count, max-count)
        box(
          width: cell-size,
          height: cell-size,
          radius: cell-radius,
          fill: color,
        )
        h(cell-gap)
      }
    }
    (row-content,)
  }

  // Combine header and rows
  stack(
    dir: ttb,
    spacing: 0pt,
    header,
    ..rows,
  )
}

// Stats summary
#let stats-summary() = {
  if timedist == none { return none }

  let total = timedist.at("total_commits", default: 0)
  let peak-hour = timedist.at("peak_hour", default: 0)
  let peak-day = timedist.at("peak_weekday", default: 0)
  let timezone = timedist.at("timezone", default: "UTC")

  let peak-hour-str = if peak-hour == 0 { "12:00 AM" } else if peak-hour < 12 { str(peak-hour) + ":00 AM" } else if (
    peak-hour == 12
  ) { "12:00 PM" } else { str(peak-hour - 12) + ":00 PM" }

  let peak-day-str = day-labels.at(peak-day)

  grid(
    columns: (1fr, 1fr, 1fr),
    gutter: 8pt,
    [
      #text(size: 8pt, fill: theme.dim)[Total Commits]
      #linebreak()
      #text(weight: "bold", size: 12pt)[#format-number(total)]
    ],
    [
      #text(size: 8pt, fill: theme.dim)[Peak Time]
      #linebreak()
      #text(weight: "bold", size: 12pt)[#peak-hour-str]
    ],
    [
      #text(size: 8pt, fill: theme.dim)[Peak Day]
      #linebreak()
      #text(weight: "bold", size: 12pt)[#peak-day-str]
    ],
  )
}

// Legend
#let legend() = {
  h(1fr)
  text(size: 7pt, fill: theme.dim)[Less]
  h(4pt)
  for i in range(5) {
    box(
      width: cell-size * 0.8,
      height: cell-size * 0.8,
      radius: cell-radius,
      fill: theme.heatmap.at(i),
    )
    h(2pt)
  }
  text(size: 7pt, fill: theme.dim)[More]
}

// Timezone note
#let timezone-note() = {
  if timedist == none { return none }
  let tz = timedist.at("timezone", default: "UTC")
  text(size: 7pt, fill: theme.dim)[Timezone: UTC#tz]
}

// Date range note
#let date-range() = {
  if timedist == none { return none }
  let earliest = timedist.at("earliest_date", default: none)
  let latest = timedist.at("latest_date", default: none)
  if earliest != none and latest != none {
    text(size: 7pt, fill: theme.dim)[#earliest \~ #latest]
  }
}

// Main card
#card-frame(
  inset: 16pt,
)[
  // Title row
  #text(weight: "bold", size: 14pt)[Commit Activity]
  #h(1fr)
  #timezone-note()

  #v(12pt)

  // Stats summary
  #stats-summary()

  #v(16pt)

  // Heatmap grid
  #align(center)[
    #build-grid()
  ]

  #v(12pt)

  // Footer: date range + legend
  #date-range()
  #legend()
]
