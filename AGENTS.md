# FitHero — Agent Workflow

## Roles

| Agent | Codename | Responsibility | Source of Truth |
|-------|----------|---------------|-----------------|
| **Lead iOS Dev** | `@ios-lead` | Builds new features, UI/UX, interactions, animations. Defines the spec. | iOS codebase + DESIGN.md |
| **Android Follower** | `@android-dev` | Clones iOS screens 1:1 into Android (Jetpack Compose). | iOS codebase + this file |

## Golden Rule

**iOS leads. Android follows.**

- New screens are designed and built on iOS first.
- Android clones them after iOS declares them "done".
- If Android finds an iOS screen that is awkward on Android (system back button, different keyboard, etc.), Android agent proposes a deviation in `docs/SYNC_LOG.md` and waits for human approval.

## Before Every Session

### iOS Lead
1. Read `docs/SYNC_LOG.md` — check if Android has flagged any deviations.
2. Read `docs/SCREEN_STATUS.md` — know what is done/pending.
3. Pick the next screen from the roadmap.
4. Build it.
5. Update `SCREEN_STATUS.md` and append to `SYNC_LOG.md` what changed.

### Android Dev
1. Read `docs/SYNC_LOG.md` — find the latest iOS changes that are not yet cloned.
2. Read `docs/SCREEN_STATUS.md` — know which screens need Android parity.
3. Clone the iOS screen 1:1 (same data, same layout, same navigation flow).
4. Update `SCREEN_STATUS.md` and mark Android status.

## After Every Session (Both Agents)

Update these files in this order:
1. **`docs/SCREEN_STATUS.md`** — update status of any screen you touched.
2. **`docs/SYNC_LOG.md`** — append a dated entry with what changed.
3. **Build & verify** — iOS builds in Xcode, Android builds via Gradle.

## Commit Message Convention

Prefix every commit so the other agent knows what changed:

```
[ios] Home: add workout countdown timer
[ios] Schedule: fix date formatting
[android] Home: clone workout countdown from iOS
[android] Schedule: clone reschedule sheet from iOS
[sync] Update SCREEN_STATUS and SYNC_LOG
[design] Update DESIGN.md color tokens
```

## Deviation Process

Sometimes iOS patterns don't translate cleanly to Android. When that happens:

1. **Android agent** writes a deviation proposal in `docs/SYNC_LOG.md` under `## Pending Decisions`.
2. **Human reviews** and approves or rejects.
3. If approved, both agents update their code to match the decision.
4. Decision is moved to `## Resolved Decisions` with the rationale.

**Never unilaterally deviate.** Android without approval = broken sync.

## File Ownership

| File | Owner | Notes |
|------|-------|-------|
| `docs/DESIGN.md` | iOS Lead | Design system source of truth. Android follows it. |
| `docs/SCREEN_STATUS.md` | Both | Cross-platform matrix. Both update their column. |
| `docs/SYNC_LOG.md` | Both | Append-only changelog. Dated entries. |
| `ios/` | iOS Lead | Never touch without iOS lead approval. |
| `android/` | Android Dev | Never touch without android dev approval. |
| `PRODUCT_SPEC.md` | Human | Product owner document. Agents reference, don't edit. |

## Quick Reference: Android ↔ iOS Mapping

| iOS | Android |
|-----|---------|
| `.sheet` | `Box` overlay or `ModalBottomSheet` |
| `.fullScreenCover` | Full-screen `Box` overlay |
| `NavigationStack` | N/A (single-activity Compose) |
| `TabView` | `NavigationBar` + `Scaffold` |
| `@AppStorage` | `rememberSaveable` or DataStore |
| `SwiftUI Charts` | Custom `Canvas` chart (no external dep) |
| `SF Symbols` | Material `Icons` closest match |
