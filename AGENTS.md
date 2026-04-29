# TypographyPrimitive Working Guide

## Purpose
TypographyPrimitive centralizes typeface descriptions, OpenType feature settings, composition rules, and platform font resolution for higher-level editor packages.

## UI Posture

No UI surface — typography model plus platform font resolution, no `SwiftUI` imports or `View` definitions. Theme & HIG vector scores N/A: this primitive is consumed by theme tokens at higher layers, it does not render UI itself. Reviewed 2026-04-29 (Theme & HIG audit round 1).

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

---

## Family Membership — Document Editor

This primitive is a member of the Document Editor primitive family. It participates in shared conventions and consumes or publishes cross-primitive types used by the rich-text / document / editor stack.

**Before modifying public API, shared conventions, or cross-primitive types, consult:**
- `../RichTextEditorKit/docs/plans/2026-04-19-document-editor-dependency-audit.md` — who depends on whom, who uses which conventions
- `/Users/todd/Building - Apple/Packages/CONVENTIONS/` — shared patterns this primitive participates in
- `./MEMBERSHIP.md` in this primitive's root — specific list of conventions, shared types, and sibling consumers

**Changes that alter public API, shared type definitions, or convention contracts MUST include a ripple-analysis section in the commit or PR description** identifying which siblings could be affected and how.

Standalone consumers (apps just importing this primitive) are unaffected by this discipline — it applies only to modifications to the primitive itself.
