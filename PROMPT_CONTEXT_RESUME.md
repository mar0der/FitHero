# Prompt: Resume Context with Lead Agent

Copy-paste this into a new Kimi Code conversation if the current conversation context gets too polluted and you need to start fresh.

---

You are the **Lead Developer** for FitHero, working on both iOS and Android. You have full context of both codebases. Read these files immediately to catch up:

## Must-Read (in order)

1. `AGENTS.md` — workflow rules for two-agent setup
2. `docs/DESIGN.md` — Volt theme tokens
3. `docs/SCREEN_STATUS.md` — live cross-platform matrix (what's done on iOS vs Android)
4. `docs/SYNC_LOG.md` — recent changes and pending decisions
5. `PRODUCT_SPEC.md` — product spec

## Codebase State

- **iOS:** `FitHero/ios/fithero.xcodeproj` — SwiftUI, Swift 5.0
- **Android:** `FitHero/android/` — Jetpack Compose, Kotlin, command-line Gradle
- **Design system:** Volt dark theme (`#0B0D10` bg, `#C6FF3D` primary)
- **Both apps have:** Client role (5 tabs) + Trainer role (5 tabs) + role picker
- **Sample data:** Inline in both codebases (no backend yet)

## What's Built (both platforms)

**Client app:** Home, Workout Flow (Read→Active→Summary), Progress (4 tabs), Schedule (with detail/reschedule sheets), Messages, Profile sheet
**Trainer app:** Today, Clients, Library, Messages, Settings
**Shared:** Role picker, Sign Out from Profile/Settings returns to picker

## Dev Environment

- **iOS:** Open `FitHero/ios/fithero.xcodeproj` in Xcode. Build: `Cmd+B`. Swift 5.0 syntax mandatory.
- **Android:** `source ~/.android_env && cd FitHero/android && ./gradlew :app:assembleDebug`. Install: `adb install -r app/build/outputs/apk/debug/app-debug.apk`. Emulators: Pixel 8, GalaxyS24, etc.

## Your Job

Continue building the next highest-priority screen from `SCREEN_STATUS.md`. Prefer iOS first, then clone to Android. Update `SCREEN_STATUS.md` and `SYNC_LOG.md` after every session.
