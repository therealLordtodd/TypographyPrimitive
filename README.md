# TypographyPrimitive

`TypographyPrimitive` gives you a stable, serializable typography model for editors, document formats, and text-heavy apps.

Use it when your app needs to store things like:

- the requested typeface family, weight, width, and italic style
- OpenType feature choices like tabular numbers or small caps
- composition rules like tracking, kerning, hyphenation, and line-break strategy
- font metrics you can inspect before laying out text

This package is especially useful when you want your document model to say "use this typography" without embedding `NSFont`, `UIFont`, or platform-only rendering types in your data model.

## What This Package Is For

`TypographyPrimitive` is a modeling and resolution layer.

It gives you:

- `TypefaceDescriptor` as a portable font request
- `OpenTypeFeatures` and `CompositionRules` as portable typography settings
- `FontManager` for enumerating installed families and resolving descriptors into metrics
- `ResolvedTypeface` and `TypeMetrics` for layout-facing measurements

It does not give you:

- a text renderer
- a full font fallback system
- variable-font axis editing beyond `opticalSize`
- automatic application of OpenType features to attributed text

Your host app still owns the actual rendering pipeline.

## When To Use It

Use `TypographyPrimitive` when:

- you are building an editor, document app, or note app
- you need typography settings to be `Codable` and `Sendable`
- you want to inspect font metrics before layout
- you need one cross-platform model for both macOS and iOS

Do not use it when:

- you just need `Font.system(size:)` in a small SwiftUI app
- your app does not persist typography choices
- you need a full text engine with shaping, fallback, and rendering

## Package Product

| Product | Type | Notes |
|---|---|---|
| `TypographyPrimitive` | Library | Typeface descriptors, OpenType features, composition rules, and font resolution |

## Core Types

| Type | Purpose |
|---|---|
| `TypefaceDescriptor` | Portable request for a family, weight, width, italic state, and optional optical size |
| `FontWeight` | Nine-case weight enum from `.ultraLight` through `.black` |
| `FontWidth` | Width enum: `.compressed`, `.condensed`, `.standard`, `.expanded` |
| `OpenTypeFeatures` | Ligatures, number style, number spacing, small caps, fractions, ordinals, stylistic alternates |
| `CompositionRules` | Tracking, kerning mode, hyphenation settings, and line-break strategy |
| `FontManager` | `@MainActor` observable resolver and font-family browser |
| `ResolvedTypeface` | Resolved font metrics in font units |
| `TypeMetrics` | Metrics scaled to a concrete point size |

## Concrete Examples

### 1. Store a portable typography choice in a document model

```swift
import TypographyPrimitive

struct ParagraphStyle: Codable, Sendable {
    var typeface: TypefaceDescriptor
    var features: OpenTypeFeatures
    var composition: CompositionRules
}

let style = ParagraphStyle(
    typeface: TypefaceDescriptor(
        family: "Helvetica Neue",
        weight: .semibold
    ),
    features: .default,
    composition: .default
)
```

This is the core win of the package: your model stays portable and serializable.

### 2. Resolve a descriptor and inspect line metrics

```swift
import TypographyPrimitive

@MainActor
func inspectTypeface() {
    let manager = FontManager()
    let descriptor = TypefaceDescriptor(
        family: "SF Pro Text",
        weight: .regular
    )

    guard let resolved = manager.resolve(descriptor) else {
        print("Font not installed")
        return
    }

    print("Cap height: \(resolved.capHeight)")
    print("X height: \(resolved.xHeight)")
    print("Line height: \(resolved.lineHeight)")
}
```

### 3. Get metrics at a real point size for layout math

```swift
import TypographyPrimitive

@MainActor
func metricsForBodyText() {
    let manager = FontManager()
    let descriptor = TypefaceDescriptor(family: "Georgia")

    if let metrics = manager.metricsForSize(descriptor, size: 14) {
        print("Ascent: \(metrics.ascent)")
        print("Descent: \(metrics.descent)")
        print("Line height: \(metrics.lineHeight)")
    }
}
```

### 4. Store OpenType features alongside a text style

```swift
import TypographyPrimitive

var features = OpenTypeFeatures.default
features.numberStyle = .oldstyle
features.numberSpacing = .tabular
features.smallCaps = .fromLowercase
features.stylisticAlternates = [1, 3]

var rules = CompositionRules.default
rules.tracking = 0.4
rules.kerning = .custom(-0.2)
rules.hyphenation = true
rules.hyphenationFactor = 0.8
```

### 5. Build a font picker from installed families and variants

```swift
import TypographyPrimitive

@MainActor
func buildPickerData() {
    let manager = FontManager()
    let families = manager.availableFamilies
    let variants = manager.fontsInFamily("Helvetica Neue")

    print(families.count)
    print(variants)
}
```

`fontsInFamily(_:)` is a much better source for picker UI than hardcoding weight lists.

## How Resolution Actually Works

`FontManager` is the public entry point. Internally it uses platform font APIs to resolve a `TypefaceDescriptor`.

That means a few things matter:

- resolution is best effort, not exact-match guaranteed
- `resolve(_:)` can return `nil`
- cross-platform matches may differ for the same descriptor
- a family with limited variants may collapse `.medium` and `.semibold` onto the same installed font

This package is honest about that ambiguity. It gives you a stable request model, not a guarantee that every platform has the exact same font installed.

## How To Wire It Into Your App

The cleanest pattern is:

1. Store `TypefaceDescriptor`, `OpenTypeFeatures`, and `CompositionRules` in your document model.
2. Resolve them near the rendering boundary with `FontManager`.
3. Convert the result into your app's actual rendering types.

Example shape:

```swift
import TypographyPrimitive

struct TextRunStyle: Codable, Sendable {
    var descriptor: TypefaceDescriptor
    var features: OpenTypeFeatures
    var composition: CompositionRules
}

@MainActor
final class TextRendererBridge {
    private let fontManager = FontManager()

    func resolveStyle(_ style: TextRunStyle, pointSize: CGFloat) -> TypeMetrics? {
        fontManager.metricsForSize(style.descriptor, size: pointSize)
    }
}
```

In other words:

- this package owns the portable typography model
- your app owns attributed strings, text layout, rendering, and fallback behavior

## Practical Guidance

- Treat `FontManager` as a UI-bound service. It is `@MainActor`.
- Cache or reuse it instead of creating a new manager for every text run.
- Call `clearCache()` after environment changes that can affect resolution.
- Test cross-platform font resolution if your app ships on both macOS and iOS.
- If exact typography matters, validate installed families during onboarding or settings.

## Platform Support

- macOS 15+
- iOS 17+

## Build And Test

```bash
swift build
swift test
```
