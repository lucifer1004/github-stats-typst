// Shared helpers for card templates
//
// This module provides common utilities used by all card templates:
// - Theme loading from sys.inputs
// - Stats JSON loading
// - Page configuration
// - Number formatting
// - Card frame styling

#import "themes.typ": themes

// --- Inputs from CLI ---
// Theme name passed via --input theme="github"
#let theme-name = sys.inputs.at("theme", default: "github")
// Path to stats JSON passed via --input stats="/stats.json"
#let stats-path = sys.inputs.at("stats", default: "/stats.json")

// --- Exposed values ---
/// The active theme dictionary (bg, fg, accent, dim, card-bg, bar, border, heatmap)
#let theme = themes.at(theme-name)
/// The parsed GitHub stats JSON data
#let stats = json(stats-path)

/// Page and text setup for card templates.
/// - body (content): The card content
/// - text-size (length): Base text size (default: 10pt)
/// -> content
#let conf(body, text-size: 10pt) = {
  set page(
    width: 495pt,
    height: auto,
    margin: 0pt,
    fill: none,
  )
  set text(
    font: ("Inter", "SF Pro", "Helvetica Neue", "Arial", "sans-serif"),
    size: text-size,
    fill: theme.fg,
  )
  body
}

/// Format number with thousand separators (e.g., 1234 -> "1,234").
/// - n (integer): The number to format
/// -> string
#let format-number(n) = {
  let s = str(n)
  if s.len() <= 3 { return s }
  let parts = ()
  let i = s.len()
  while i > 0 {
    let start = calc.max(i - 3, 0)
    parts.push(s.slice(start, i))
    i = start
  }
  parts.rev().join(",")
}

/// Standard card container with themed styling.
/// - body (content): The card content
/// - inset (length): Inner padding (default: 0pt)
/// - radius (length): Corner radius (default: 8pt)
/// - clip (boolean): Whether to clip overflow (default: false)
/// -> content
#let card-frame(body, inset: 0pt, radius: 8pt, clip: false) = {
  block(
    width: 100%,
    fill: theme.bg,
    stroke: 1pt + theme.border,
    radius: radius,
    clip: clip,
    inset: inset,
  )[#body]
}
