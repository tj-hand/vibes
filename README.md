# Vibes

CSS design system with themes and accessibility for the Spark Stack frontend.

Part of L3 Foundation: `Vibes → Stage`. Deploys to Infinity.

## What It Does

| Responsibility | Description |
|----------------|-------------|
| **CSS Reset** | Modern normalize for consistent cross-browser rendering |
| **Design Tokens** | CSS custom properties (`--vb-*`) for colors, typography, spacing, shadows, etc. |
| **Utility Classes** | Tailwind-like atomic classes (`vb-*`) for rapid styling |
| **Base Themes** | Light and dark color schemes with system preference detection |
| **Accessibility Themes** | High contrast, large text, reduced motion overlays |

## Provides

| Export | Description |
|--------|-------------|
| `index.css` | Main entry point - imports reset, tokens, default theme, utilities |
| `vibes.css` | CSS reset + all design tokens |
| `themes/base/default.css` | Light theme (loaded by default) |
| `themes/base/dark.css` | Dark theme |
| `themes/accessibility/high-contrast.css` | WCAG AAA contrast overlay |
| `themes/accessibility/large-text.css` | 1.5x/2x text scaling overlay |
| `themes/accessibility/reduced-motion.css` | Animation reduction overlay |
| `utilities/*.css` | Typography, spacing, colors, layout, display utilities |

## Expects

| From | What |
|------|------|
| Infinity | Deployment slot at `src/vibes/` |
| Infinity | Path alias `@vibes` → `src/vibes/` in Vite config |
| Infinity | Inter + JetBrains Mono fonts loaded (graceful fallback to system fonts) |
| Stage | Theme switching via data attributes on `<html>` |

## Never Does

| Boundary | Owner |
|----------|-------|
| Theme switching logic | Stage |
| UI components | Stage |
| User preference storage | Stage |

## Structure

```
vibes/
├── deploy.sh                    # Deploy to Infinity
└── vibes-fe/
    ├── index.css                # Main entry (imports all)
    ├── vibes.css                # Reset + tokens (~670 lines)
    ├── utilities/
    │   ├── typography.css       # Font, size, weight, alignment
    │   ├── spacing.css          # Margin, padding, gap
    │   ├── colors.css           # Background, border, shadow, opacity
    │   ├── layout.css           # Flexbox, grid, position, sizing
    │   └── display.css          # Visibility, cursor, transitions
    └── themes/
        ├── base/
        │   ├── default.css      # Light theme
        │   └── dark.css         # Dark theme
        └── accessibility/
            ├── high-contrast.css
            ├── large-text.css
            └── reduced-motion.css
```

## Token Categories

| Category | Prefix | Examples |
|----------|--------|----------|
| Colors | `--vb-color-*` | `--vb-color-primary`, `--vb-color-text`, `--vb-color-border` |
| Typography | `--vb-font-*` | `--vb-font-size-lg`, `--vb-font-weight-bold` |
| Spacing | `--vb-spacing-*` | `--vb-spacing-4` (16px), `--vb-spacing-8` (32px) |
| Shadows | `--vb-shadow-*` | `--vb-shadow-md`, `--vb-shadow-focus` |
| Radius | `--vb-radius-*` | `--vb-radius-lg`, `--vb-radius-full` |
| Transitions | `--vb-duration-*`, `--vb-ease-*` | `--vb-duration-200`, `--vb-ease-in-out` |
| Z-index | `--vb-z-*` | `--vb-z-modal`, `--vb-z-tooltip` |
| Components | `--vb-button-*`, `--vb-input-*`, etc. | `--vb-button-padding-x`, `--vb-card-bg` |

## Usage

```bash
# Via Spark
spark add vibes

# Manual deployment
DEPLOY_TARGET=infinity DEPLOY_TARGET_PATH=/path/to/infinity ./deploy.sh
```

### Import in Infinity

```css
/* main.css or App.vue */
@import '@vibes/index.css';
```

### Use Tokens in Components

```vue
<style scoped>
.card {
  background: var(--vb-color-surface);
  border: 1px solid var(--vb-color-border);
  border-radius: var(--vb-radius-lg);
  padding: var(--vb-spacing-4);
  box-shadow: var(--vb-shadow-sm);
}
</style>
```

### Use Utility Classes

```html
<div class="vb-flex vb-items-center vb-gap-4 vb-p-4">
  <span class="vb-text-lg vb-font-semibold vb-text-primary">Title</span>
  <span class="vb-text-sm vb-text-muted">Subtitle</span>
</div>
```

## Theme Switching

Themes are activated via data attributes on `<html>`:

```javascript
// Base theme (light/dark)
document.documentElement.dataset.theme = 'dark'

// Accessibility overlays (stackable)
document.documentElement.dataset.contrast = 'high'
document.documentElement.dataset.textSize = 'large'  // or 'extra-large'
document.documentElement.dataset.motion = 'reduce'   // or 'subtle'
```

System preferences are auto-detected:
- `prefers-color-scheme: dark` → applies dark theme
- `prefers-reduced-motion: reduce` → applies reduced motion

## Reference

Full spec: [architecture.md](https://github.com/tj-hand/spark/blob/main/architecture.md)
