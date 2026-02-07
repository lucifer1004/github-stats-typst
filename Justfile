set dotenv-load

username := "lucifer1004"
theme := "github"

# =============================================================================
# Development
# =============================================================================

[unix]
pre-commit:
    @if command -v prek > /dev/null 2>&1; then prek run --all-files; else pre-commit run --all-files; fi

[windows]
pre-commit:
    if (Get-Command prek -ErrorAction SilentlyContinue) { prek run --all-files } else { pre-commit run --all-files }

# Fetch GitHub stats using CLI (must be installed separately)
fetch:
    github-readme-stats {{username}} --output stats.json

# =============================================================================
# Render Cards
# =============================================================================

# Render profile card to SVG
render-profile theme=theme:
    typst compile cards/profile.typ profile-{{theme}}.svg \
        --root . \
        --input theme="{{theme}}" \
        --input stats="/stats.json"

# Render heatmap card to SVG
render-heatmap theme=theme:
    typst compile cards/heatmap.typ heatmap-{{theme}}.svg \
        --root . \
        --input theme="{{theme}}" \
        --input stats="/stats.json"

# Render pinned repos card to SVG
render-pinned theme=theme:
    typst compile cards/pinned.typ pinned-{{theme}}.svg \
        --root . \
        --input theme="{{theme}}" \
        --input stats="/stats.json"

# Render time distribution card to SVG
render-timedist theme=theme:
    typst compile cards/timedist.typ timedist-{{theme}}.svg \
        --root . \
        --input theme="{{theme}}" \
        --input stats="/stats.json"

# Render language usage card to SVG
render-language theme=theme:
    typst compile cards/language.typ language-{{theme}}.svg \
        --root . \
        --input theme="{{theme}}" \
        --input stats="/stats.json"

# Render all cards
render theme=theme: (render-profile theme) (render-heatmap theme) (render-pinned theme) (render-timedist theme) (render-language theme)

# Full pipeline: fetch stats + render cards + open
run: fetch render
    open profile-{{theme}}.svg
    open timedist-{{theme}}.svg
    open language-{{theme}}.svg

# Render all themes
themes: fetch
    just render github
    just render github-dark
    just render dracula
    just render monokai

# =============================================================================
# Cleanup
# =============================================================================

# Clean output files
clean:
    rm -f stats.json *.svg
