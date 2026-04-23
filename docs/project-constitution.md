# TypographyPrimitive — Project Constitution

**Created:** 2026-04-16
**Authors:** Todd Cowing + Claude (Opus 4.7)

This document records the *why* behind foundational decisions. It is written for future collaborators — human and AI — who weren't in the room when these choices were made. The development plan tells you what we're building. AGENTS.md tells you how to build it. This document tells you why we made the decisions we made, and where we believe this is going.

Fill in the project-specific sections as decisions are made. The **Founding Principles** apply to every project in the portfolio without exception — they are the intent behind the work. The **Portfolio-Wide Decisions** are pre-filled conventional choices that follow from those principles; they apply unless explicitly overridden here with a documented reason.

---

## What TypographyPrimitive Is Trying to Be

TypographyPrimitive gives the portfolio's editors and document formats a stable, serializable typography model. It owns `TypefaceDescriptor` as a portable font request, `OpenTypeFeatures` and `CompositionRules` for typography settings, a `FontManager` for enumerating installed families and resolving descriptors into metrics, and `ResolvedTypeface`/`TypeMetrics` for layout-facing measurements. It is for apps that need typography settings to be Codable and Sendable, to inspect font metrics before layout, and to share one cross-platform model between macOS and iOS — not for apps that just need `Font.system(size:)`. The central insight is that document models should describe typography portably (by descriptor, not by `NSFont`/`UIFont`), with resolution happening near the rendering boundary.

---

## Foundational Decisions

### Shared Portfolio Doctrine

The shared founding principles and portfolio-wide defaults now live in the Foundation Libraries wiki:

- `/Users/todd/Library/CloudStorage/GoogleDrive-todd@cowingfamily.com/My Drive/The Commons/Libraries/Foundation Libraries/operations/portfolio-doctrine.md`

Use this local constitution for project-specific decisions, not copied portfolio boilerplate.

---

### Project-Specific Decisions

*Add an entry here for every significant architectural, tooling, or directional decision made for this project. Write it at decision time, not retroactively. Future collaborators need to understand the reasoning, not just the outcome.*

*Initial decisions summarized from CLAUDE.md:*

#### Typography State Is Codable and Sendable

**Decision:** Typography model types (`TypefaceDescriptor`, `OpenTypeFeatures`, `CompositionRules`) are Codable and Sendable so they can travel through document models and across isolation boundaries.

**Why:** The whole point of the primitive is that host document models carry typography descriptively. That only works if the types serialize cleanly and can be passed between actors safely.

**Trade-offs accepted:** Contributors must keep the model types free of platform-bound dependencies and must maintain Codable/Sendable conformance as the model evolves.

---

#### Platform Font Probing Is Isolated in `FontManager`

**Decision:** Platform font resolution (AppKit/UIKit APIs) lives inside `FontManager`. Model types do not depend on AppKit or UIKit.

**Why:** Keeping platform APIs contained means the model types can be used anywhere — in pure Swift, in server-side contexts, in tests — while resolution only happens at the UI-bound seam where a platform is actually present. It also lets `FontManager` be `@MainActor` without forcing main-actor isolation onto the model types.

**Trade-offs accepted:** Contributors must resist the temptation to "just import UIKit here" when a model type would be easier to write with direct platform access. The split costs some ergonomic friction for a bigger architectural gain.

---

#### Descriptor → Resolution Is a One-Way Derivation

**Decision:** `TypefaceDescriptor` is the stable input. `ResolvedTypeface` and `TypeMetrics` are derived outputs. Higher-level editor packages do not become dependencies of this primitive.

**Why:** Consumers of this primitive should serialize and reason about the descriptor, not the resolved result. Reversing that flow would make document models depend on runtime-resolved state. Making editor packages into dependencies here would invert the layer stack.

**Trade-offs accepted:** Consumers must re-resolve on platform, cache as they see fit, and handle best-effort matches. The primitive will not guarantee identical cross-platform resolution.

---

*Add more entries as decisions are made.*

---

## Tech Stack and Platform Choices

**Platform:** macOS 15+ and iOS 17+ (cross-platform Swift package)
**Primary language:** Swift 6.0
**UI framework:** None directly — `FontManager` is `@MainActor` and uses platform font APIs (`NSFont`, `UIFont`) internally
**Data layer:** Codable/Sendable value types embedded in host document models

**Why this stack:** A typography primitive needs to be usable from anywhere a document model lives (pure Swift, tests, server-side) and resolvable only at the UI boundary. Swift 6 with Codable/Sendable gives us that cleanly, while the `FontManager` seam contains the unavoidable platform dependency.

---

## Who This Is Built For

*Who are the primary users or operators of this software? Humans, AI agents, or both? This shapes everything from UI density to conductorship defaults.*

[ ] Primarily humans
[ ] Primarily AI agents
[ ] Both, roughly equally
[ ] Both — humans build it, AIs operate it
[X] Both — AIs build it, humans operate it

**Notes:** Foundation primitive. Humans choose typography through host editor UI; AIs build and maintain the primitive itself and can describe/adjust typography programmatically through the same descriptor types.

---

## Where This Is Going

[To be filled in as project direction crystallizes.]

---

## Open Questions

*None recorded yet.*

---

## Amendment Process

Use this process whenever a foundational decision changes or a new decision is added.

1. Update the relevant section in this constitution in the same change as the code/docs that motivated the update.
2. For each new or changed decision entry, include:
   - **Decision**
   - **Why**
   - **Trade-offs accepted**
   - **Revisit trigger** (what condition should cause reconsideration)
3. Add a matching row in the **Decision Log** with date and a concise summary.
4. If the amendment changes implementation rules, update `AGENTS.md` and any affected style guide files in the same change.
5. Record who approved the amendment (human + AI collaborator when applicable).

Minor wording clarifications that do not change meaning do not require a new decision entry, but should still be noted in the Decision Log.

---

## Decision Log

*Brief chronological record of significant decisions. Add an entry whenever a non-trivial decision is made that isn't already captured in the sections above.*

| Date | Decision | Decided by |
|------|----------|------------|
| 2026-04-16 | Constitution created and Founding Principles established | Both |
