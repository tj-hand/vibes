# Vibes Test Documentation

## Testing Strategy

Vibes is a pure CSS module with no runtime logic. Testing focuses on static analysis rather than unit tests.

## Running Validation

```bash
# CSS syntax validation (requires stylelint)
npx stylelint "vibes-fe/**/*.css"

# Brace balance check
for f in vibes-fe/**/*.css; do
  opens=$(grep -o '{' "$f" | wc -l)
  closes=$(grep -o '}' "$f" | wc -l)
  [ "$opens" -eq "$closes" ] || echo "FAIL: $f"
done

# Import resolution
cd vibes-fe && grep -oP "(?<=@import ')\..*(?=')" index.css | while read path; do
  [ -f "$path" ] || echo "MISSING: $path"
done

# Token naming convention (all tokens should use --vb- prefix)
grep -rE "^\s*--[a-z]" vibes-fe/vibes.css | grep -v "^\s*--vb-" && echo "FAIL: Non-prefixed tokens found"
```

## Validation Summary

| Check | Files | What It Validates |
|-------|-------|-------------------|
| Brace balance | 12 | CSS selectors properly closed |
| Import resolution | 1 | All @import paths exist |
| Token prefix | 1 | All tokens use `--vb-` convention |
| Stylelint | 12 | CSS syntax validity |

## Test-to-Responsibility Mapping

### CSS Reset (`vibes.css`)

| Responsibility | Validation |
|----------------|------------|
| Box-sizing reset | Static - present in file |
| Form element normalization | Static - present in file |
| Media element defaults | Static - present in file |
| List style reset | Static - present in file |

### Design Tokens (`vibes.css`)

| Responsibility | Validation |
|----------------|------------|
| Color tokens defined | Static - `--vb-color-*` present |
| Typography tokens defined | Static - `--vb-font-*` present |
| Spacing tokens defined | Static - `--vb-spacing-*` present |
| Shadow tokens defined | Static - `--vb-shadow-*` present |
| Border tokens defined | Static - `--vb-radius-*`, `--vb-border-*` present |
| Transition tokens defined | Static - `--vb-duration-*`, `--vb-ease-*` present |
| Z-index tokens defined | Static - `--vb-z-*` present |
| Component tokens defined | Static - `--vb-button-*`, `--vb-input-*`, etc. present |

### Utility Classes (`utilities/*.css`)

| File | Validation |
|------|------------|
| typography.css | Static - `.vb-text-*`, `.vb-font-*` classes present |
| spacing.css | Static - `.vb-m-*`, `.vb-p-*`, `.vb-gap-*` classes present |
| colors.css | Static - `.vb-bg-*`, `.vb-border-*` classes present |
| layout.css | Static - `.vb-flex`, `.vb-grid`, `.vb-w-*` classes present |
| display.css | Static - `.vb-visible`, `.vb-cursor-*` classes present |

### Theme System (`themes/**/*.css`)

| Theme | Validation |
|-------|------------|
| default.css | Static - `[data-theme="light"]` selector valid |
| dark.css | Static - `[data-theme="dark"]` selector valid |
| high-contrast.css | Static - `[data-contrast="high"]` selector valid |
| large-text.css | Static - `[data-text-size="large"]` selector valid |
| reduced-motion.css | Static - `[data-motion="reduce"]` selector valid |

## Known Gaps

| Gap | Severity | Reason |
|-----|----------|--------|
| Visual regression testing | Deferred | Stage components will validate visual correctness |
| Browser compatibility | Deferred | CSS uses standard properties; tested in Stage |
| Theme switching runtime | N/A | Stage owns theme manager |
| Accessibility compliance | Deferred | Stage components tested with axe-core |
| Token value correctness | N/A | Design decision, not testable |

## Why No Unit Tests

1. **CSS is declarative** - No logic to test, only declarations
2. **Static analysis suffices** - Syntax errors caught by stylelint
3. **Visual correctness** - Validated by Stage component screenshots
4. **Runtime behavior** - Theme switching tested in Stage

## Integration Testing

Vibes is tested indirectly through:

1. **Spark deployment** - `spark add vibes` validates file structure
2. **Infinity build** - Vite CSS processing validates syntax
3. **Stage components** - Visual regression tests validate appearance

## Adding New CSS

When adding new tokens or utilities:

1. Follow `--vb-` prefix for tokens
2. Follow `vb-` prefix for classes
3. Add to appropriate file (tokens → vibes.css, utilities → utilities/*.css)
4. Run validation commands above
5. Test visually in a Stage component
