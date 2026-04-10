# TypographyPrimitive

TypographyPrimitive provides reusable typography models and font resolution helpers for editor and document packages.

## Quick Start

```swift
import TypographyPrimitive

let descriptor = TypefaceDescriptor(
    family: "Helvetica Neue",
    weight: .semibold,
    width: .standard,
    isItalic: false
)

let manager = FontManager()
let resolved = manager.resolve(descriptor)
let metrics = manager.metricsForSize(descriptor, size: 16)
```

## Key Types
- `TypefaceDescriptor`: Serializable font request with family, weight, width, italic, and optical size.
- `FontWeight` and `FontWidth`: Normalized descriptor values.
- `OpenTypeFeatures`: Ligatures, number style/spacing, small caps, fractions, ordinals, and stylistic alternates.
- `CompositionRules`: Tracking, kerning, hyphenation, and line-break strategy.
- `FontManager`: Lists families, resolves descriptors, returns `ResolvedTypeface`, and computes `TypeMetrics`.

## Common Operations
- Use `OpenTypeFeatures.default` and `CompositionRules.default` as safe defaults.
- Call `FontManager.fontsInFamily(_:)` to inspect available variants.
- Call `FontManager.clearCache()` after test setup or environment changes that affect font availability.

## Testing

Run:

```bash
swift test
```
