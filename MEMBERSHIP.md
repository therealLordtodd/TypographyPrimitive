# TypographyPrimitive — Document Editor Family Membership

This primitive is a member of the Document Editor primitive family. It is the **canonical owner of Typography types** consumed across the family.

## Conventions This Primitive Participates In

- [x] [shared-types](../CONVENTIONS/shared-types-convention.md) — **canonical owner** of Typography types
- [ ] [typed-static-constants](../CONVENTIONS/typed-static-constants-convention.md) — not directly (typeface descriptors are value types, not a typed-static-constants space)
- [x] [document-editor-family-membership](../CONVENTIONS/document-editor-family-membership.md)

## Shared Types This Primitive Defines

- **Typography types** — typeface descriptors, OpenType features, composition rules, font-metric resolution
- Consumed by: `RichTextPrimitive`, `DocumentPrimitive`, `PaginationPrimitive`, `RulerPrimitive`, `RichTextEditorKit`

## Shared Types This Primitive Imports

- (none from the family — Foundation only)

## Siblings That Hard-Depend on This Primitive

- `RichTextPrimitive` — consumes Typography descriptors for text rendering
- `RichTextEditorKit` — re-exports Typography surface
- Document layout primitives (`PaginationPrimitive`, `RulerPrimitive`) consume metrics indirectly via RichTextPrimitive's block model

## Ripple-Analysis Checklist Before Modifying Public API

1. **Typography type shape changes are HIGH-RIPPLE** — affects 4+ family primitives. Consult [dependency audit §5](../RichTextEditorKit/docs/plans/2026-04-19-document-editor-dependency-audit.md).
2. Changes to font-metric resolution: affects pagination layout + RichText composition. Test across DocumentPrimitive's composition path.
3. Adding new typography fields: usually additive. Still document in the commit.
4. Changes to OpenType feature model: affects any consumer that specifies glyph variants.
5. Document ripple impact in the commit/PR.

## Scope of Membership

Applies to modifications of TypographyPrimitive's own code. Consumers just importing for their own app are unaffected.
