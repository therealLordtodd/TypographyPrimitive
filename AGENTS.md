# TypographyPrimitive Working Guide

## Purpose
TypographyPrimitive centralizes typeface descriptions, OpenType feature settings, composition rules, and platform font resolution for higher-level editor packages.

## Key Directories
- `Sources/TypographyPrimitive`: Font descriptors, metrics, OpenType features, and `FontManager`.
- `Tests/TypographyPrimitiveTests`: Model round-trip and font manager tests.

## Architecture Rules
- Keep typography state Codable and Sendable where possible so it can travel through document models.
- Keep platform font probing isolated in `FontManager`; model types should not depend on AppKit/UIKit.
- Treat `TypefaceDescriptor` as the stable input and `ResolvedTypeface`/`TypeMetrics` as derived outputs.
- Do not make higher-level editor packages dependencies of this primitive.

## Testing
- Run `swift test` before committing.
- Update `ModelTests` for Codable or equality changes.
- Update `FontManagerTests` when platform resolution, metrics, cache behavior, or family listing changes.
