# FitHero — Cross-Platform Sync Log

> Append-only. Dated entries. iOS Lead writes what changed; Android Dev marks when cloned.

---

## Format

```markdown
### 2026-04-21 — [ios|android] What changed
- **Screen:** Which screen
- **iOS Change:** What was added/modified/deleted
- **Android Status:** ⬜ Not cloned | ✅ Cloned | 🟡 Partial | ❌ N/A
- **Files touched:** `ios/...` → `android/...`
- **Notes:** Anything the other agent needs to know
```

---

## Log

### 2026-04-28 — [ios] Polish: Chat full-screen, Calendar Settings link, DatePicker fix, Photos week folders
- **Screen:** Cross-cutting polish pass
- **iOS Change:**
  1. **Chat full-screen** — MessagesView now presents as `.fullScreenCover()` (WhatsApp-style) with a back chevron in the header instead of a bottom sheet. Works from TrainerMessages and ClientDetail.
  2. **Calendar Settings link** — When calendar access is denied, alert now shows "Open Settings" button that deep-links to iOS Settings → Privacy → Calendars. Updated `CalendarHelper.CalendarError` to include `.saveFailed` case.
  3. **DatePicker visibility** — Removed `.colorMultiply(FH.Colors.primary)` from `ScheduleSessionSheet` DatePicker. Calendar dates now render clearly in dark mode.
  4. **Photos week folders** — Removed confusing Start/Current placeholder row. Photos now grouped by week into card sections: week label + date range + photo count header, 3-column grid inside. "+ Add" button moved to top-right of section header (pill style). `groupedPhotos` computed property groups by `weekOfYear`.
- **Android Status:** ❌ N/A (iOS only session)
- **Files touched:** `ios/Client/Views/MessagesView.swift`, `ClientProgressView.swift`, `Trainer/Views/TrainerMessagesView.swift`, `ClientDetailView.swift`, `Shared/Helpers/CalendarHelper.swift`
- **Notes:** Full-screen chat tested on device — back chevron dismisses correctly.

### 2026-04-28 — [ios] Functional gaps: Messages, Calendar, ClientDetail, TrainerMessages, Photos, Haptics
- **Screens:** C-M-10 (Messages), C-M-09 (Schedule), T-M-04 (ClientDetail), T-M-05 (TrainerMessages), C-M-08 (Photos), Cross-cutting (Haptics)
- **iOS Change:**
  1. **Messages send/attach** — `MessagesView.swift` now has state-driven message array. Send appends client message with timestamp. Photo picker (`PhotosPicker`) appends image-attachment bubble. Video call shows alert. Auto-scrolls to bottom. Reusable with `partnerName`/`partnerInitial`/`isTrainerContext` params.
  2. **Add to Calendar** — `CalendarHelper.swift` wraps EventKit. Requests full calendar access (iOS 17+ API). Programmatically creates event with title, date, duration, location. Success/denial alerts in `ScheduleView` and `SessionDetailSheet`.
  3. **ClientDetailView actions** — Message button opens chat sheet with client's name/initials. Schedule button opens `ScheduleSessionSheet` (date picker + type chips + duration chips). Assign button opens `AssignProgramSheet` (workout library from `SampleData` with selection checkmark).
  4. **Trainer Messages** — Conversation rows are now tappable buttons with chevron. Tap clears unread badge and pushes to `MessagesView` sheet. `Conversation` model changed `unread` from `let` to `var`.
  5. **Photos tab** — `PhotoViewer` sheet with `TabView` page style, swipe between photos, index dots, large SF Symbol placeholder. `AddPhotoSheet` now has tappable photo picker area (`PhotosPicker`) and functional Save that appends to state-driven `photos` array.
  6. **Haptics** — New `FHHaptics.swift` helper (light/medium/heavy/success/error/selection). Applied: log set (medium), all sets complete (heavy+success), rest timer last 3s (light per tick), rest finish (medium), skip rest (medium), RPE pills (selection), Done workout (heavy+success), Start workout (medium), profile toggles (selection), sign out (medium), Today swipe complete (success), cancel (error), mark all (success), photo tap (medium), message send (medium).
- **Android Status:** ❌ N/A (iOS only session)
- **Files touched:** `ios/Client/Views/MessagesView.swift`, `ScheduleView.swift`, `SessionDetailSheet.swift`, `ClientProgressView.swift`, `ActiveWorkoutView.swift`, `WorkoutSummaryView.swift`, `ClientHomeView.swift`, `ProfileSheet.swift`, `Trainer/Views/TodayView.swift`, `ClientDetailView.swift`, `TrainerMessagesView.swift`, `Shared/Models/FHModels.swift`, `Shared/Helpers/CalendarHelper.swift`, `Shared/DesignSystem/FHHaptics.swift`
- **Notes:** EventKit requires calendar permission on real device. Simulator may silently succeed. Haptics only felt on physical device.

### 2026-04-28 — [ios] Trainer Today: swipe actions, empty state, mark-all-complete (T-M-02)
- **Screen:** Trainer Today (T-M-02)
- **iOS Change:** Rewrote `TodayView.swift` with state-driven `TodaySession` model. Added `.swipeActions`: leading = Complete (green), trailing = Reschedule (blue) + Cancel (red). Completed sessions collapse into a "COMPLETED" sub-section with undo swipe. Added empty state ("All caught up!" with calendar badge icon) when no pending sessions. Added "Mark all complete" header button with confirmation alert. "Remaining" stat tile updates dynamically as sessions are completed/cancelled. Added `RescheduleSessionSheet` with hour/minute wheel pickers.
- **Android Status:** 🟡 Partial (swipe actions, empty state, mark-all not yet cloned)
- **Files touched:** `ios/Trainer/Views/TodayView.swift`
- **Notes:** Uses `withAnimation` for smooth state transitions. Cancel shows destructive confirmation alert. Reschedule sheet uses 15-min increments for minutes.

### 2026-04-28 — [ios] Progress: add Check-Ins tab (C-M-08)
- **Screen:** Client Progress (C-M-08)
- **iOS Change:** Added 5th "Check-Ins" tab to `ClientProgressView`. Side-by-side layout: Previous Week vs Current Week. Sections: Weight (with delta arrow + trend text), Measurements (7 rows with prev→curr deltas, green=improvement/red=opposite), Photos (before/after placeholders), Submit Check-In CTA with confirmation alert.
- **Android Status:** ❌ N/A (iOS only session)
- **Files touched:** `ios/Client/Views/ClientProgressView.swift`
- **Notes:** Delta direction is trainer-defined per measurement site (lowerIsBetter flag). All data is sample/hardcoded for prototype.

### 2026-04-28 — [ios] Payments: C-M-03 + C-M-11
- **Screen:** Payments (C-M-11), Add Payment Method (C-M-03)
- **iOS Change:** Built `PaymentsView` with active plan card, payment method row, and payment history list. Built `AddPaymentMethodView` as a sheet with card preview, brand picker, card number/expiry/CVC fields, save and skip buttons. Added `PaymentMethod`, `PaymentHistoryItem`, `SubscriptionPlan` models with `@AppStorage` persistence. Added "Payments & Plans" row to `ProfileSheet`.
- **Android Status:** ❌ N/A (iOS only session)
- **Files touched:** `ios/Client/Views/PaymentsView.swift`, `ios/Client/Views/AddPaymentMethodView.swift`, `ios/Shared/Models/FHModels.swift`, `ios/Client/Views/ProfileSheet.swift`
- **Notes:** No Stripe SDK integration — mock UI only. Card data persists via `@AppStorage` JSON encoding.

### 2026-04-28 — [ios] Split auth into three-page flow
- **Screen:** App entry point (C-M-01, T-M-01)
- **iOS Change:** Replaced overloaded single-screen auth with a clean three-page flow: `AuthLandingView` ("Sign In" / "Get Started") → `AuthSignInView` (email/password + SSO) or `AuthSignUpOptionsView` ("I was invited" / "I'm a trainer"). Each screen has at most 2 primary actions. Added invite code field to `ClientAuthView`. Added sign-up mode to `TrainerAuthView`.
- **Android Status:** ❌ N/A (iOS only session)
- **Files touched:** `ios/Shared/App/AuthLandingView.swift`, `ios/Shared/App/AuthSignInView.swift`, `ios/Shared/App/AuthSignUpOptionsView.swift`, `ios/Shared/App/AppRootView.swift`, `ios/Client/Auth/ClientAuthView.swift`, `ios/Trainer/Auth/TrainerAuthView.swift`
- **Notes:** Deleted `AuthEntryView.swift` and `AuthGatewayView`. No screen has more than 2 CTAs. `AppRootView` routes by `selectedAppRole` + `hasCompletedOnboarding`.

### 2026-04-28 — [ios] Auth flow: Client Sign Up, Client Onboarding, Trainer Sign In
- **Screen:** C-M-01, C-M-02, T-M-01
- **iOS Change:** Built `ClientAuthView` (invite landing + email/password + SSO stubs + sign-in/up toggle). Integrated `ClientOnboardingView` into client app entry with `startAtWelcome` and `onComplete` callbacks. Built `TrainerAuthView` (trainer email/password sign-in). Updated `AppRootView` with auth state routing (`hasCompletedOnboarding`).
- **Android Status:** ❌ N/A (iOS only session)
- **Files touched:** `ios/Client/Auth/ClientAuthView.swift`, `ios/Trainer/Auth/TrainerAuthView.swift`, `ios/Shared/App/AppRootView.swift`, `ios/Client/Onboarding/ClientOnboardingView.swift`, `ios/Trainer/Views/ClientsView.swift`
- **Notes:** Auth is prototype-only using `@AppStorage`. No backend integration yet. Sign Out now returns to auth gateway instead of role picker.

### 2026-04-27 — [android] Trainer Client Mini-Profile (T-M-04)
- **Screen:** Trainer Clients → Client Detail (T-M-04)
- **iOS Change:** `ClientDetailView.swift` already existed with full 4-tab layout (Overview, Programs, Progress, Notes). Tapping a client row navigates to detail.
- **Android Status:** ✅ Cloned
- **Files touched:** `ios/.../ClientDetailView.swift` → `android/.../ClientDetailScreen.kt`, `TrainerClientsScreen.kt`
- **Notes:** Android uses a full-screen Box overlay (no Navigation component in project). Row tap shows detail; dismiss button returns to list. Matches iOS data and layout 1:1.

### 2026-04-21 — [ios] Role picker + floating badge + AppRootView structure
- **Screen:** App entry point (role selection)
- **iOS Change:** Built `AppRootView` with `AppRole` enum, `@AppStorage` role persistence, `RoleSelectionView` (FH logo + Trainer/Hero buttons), `AppSessionBadge` (top-right role switcher)
- **Android Status:** ✅ Cloned
- **Files touched:** `ios/fithero/Shared/App/AppRootView.swift` → `android/.../FitHeroApp.kt`
- **Notes:** Badge later removed on both platforms. Sign Out now lives in Profile/Settings.

### 2026-04-21 — [ios] Client Home screen
- **Screen:** Home (C-M-04)
- **iOS Change:** Dynamic greeting with name + time of day. Real `workout.exercises` data for pills. `weekActivity` array for dot grid. Message preview from actual `messages.last`. Tap avatar → `ProfileSheet`.
- **Android Status:** ✅ Cloned
- **Files touched:** `ios/.../ClientHomeView.swift` → `android/.../HomeScreen.kt`
- **Notes:** —

### 2026-04-21 — [ios] Client Workout Flow (Read → Active → Summary)
- **Screen:** Workout (C-M-05/06/07)
- **iOS Change:** Full 3-phase flow. `WorkoutReadView` (exercise list, progress, stats). `ActiveWorkoutView` (set table, weight/reps steppers, rest timer with circular countdown). `WorkoutSummaryView` (completion hero, RPE 1–10, session note, stats).
- **Android Status:** ✅ Cloned
- **Files touched:** `ios/.../WorkoutReadView.swift`, `ActiveWorkoutView.swift`, `WorkoutSummaryView.swift` → `android/.../WorkoutReadScreen.kt`, `ActiveWorkoutScreen.kt`, `WorkoutSummaryScreen.kt`
- **Notes:** Android uses Compose `Canvas` for rest timer circle. No video demo in Android (hardcoded to bench press on iOS anyway).

### 2026-04-21 — [ios] Client Progress (4 tabs)
- **Screen:** Progress (C-M-08)
- **iOS Change:** Segmented control: Weight / PRs / Body / Photos. Weight tab has SwiftUI Charts line chart + log. PRs tab has trophy list. Body tab has measurements with +/- diffs. Photos tab has timeline grid + Add Photo sheet.
- **Android Status:** ✅ Cloned
- **Files touched:** `ios/.../ClientProgressView.swift` → `android/.../ProgressScreen.kt`
- **Notes:** Android uses custom `Canvas` line chart instead of Charts library.

### 2026-04-21 — [ios] Client Schedule + Detail + Reschedule
- **Screen:** Schedule (C-M-09)
- **iOS Change:** Session cards with date column. Tap → `SessionDetailSheet` (info + Add to Calendar / Reschedule actions). Reschedule sheet has date picker + duration chips (15/30/45/60/90).
- **Android Status:** ✅ Cloned
- **Files touched:** `ios/.../ScheduleView.swift`, `SessionDetailSheet.swift`, `RescheduleSheet.swift` → `android/.../ScheduleScreen.kt`
- **Notes:** —

### 2026-04-21 — [ios] Client Messages
- **Screen:** Messages (C-M-10)
- **iOS Change:** Chat header with trainer avatar + online dot. Message bubbles (trainer left/gray, client right/lime). Input bar with attach + send.
- **Android Status:** ✅ Cloned
- **Files touched:** `ios/.../MessagesView.swift` → `android/.../MessagesScreen.kt`
- **Notes:** —

### 2026-04-21 — [ios] Client Profile Sheet
- **Screen:** Profile (C-M-12)
- **iOS Change:** Avatar header. Editable personal info fields (`@AppStorage`). Notification toggles. Support links. Sign Out button.
- **Android Status:** ✅ Cloned
- **Files touched:** `ios/.../ProfileSheet.swift` → `android/.../ProfileSheet.kt`
- **Notes:** —

### 2026-04-21 — [ios] Trainer Today view
- **Screen:** Trainer Today (T-M-02)
- **iOS Change:** Header with bell + unread badge. Sessions list with type icons. Quick stats (active clients / today / this week). Notifications sheet.
- **Android Status:** ✅ Cloned
- **Files touched:** `ios/.../TodayView.swift`, `NotificationsView.swift` → `android/.../TrainerTodayScreen.kt`
- **Notes:** —

### 2026-04-21 — [ios] Trainer Clients list
- **Screen:** Trainer Clients (T-M-03)
- **iOS Change:** Header with active count + add button. Search bar. Filter pills (All/Active/Pending/Paused). Client rows with avatar initials, plan, status pill, last active.
- **Android Status:** ✅ Cloned
- **Files touched:** `ios/.../ClientsView.swift` → `android/.../TrainerClientsScreen.kt`
- **Notes:** —

### 2026-04-21 — [ios] Trainer Library
- **Screen:** Trainer Library
- **iOS Change:** Segmented control: Exercises / Workouts. Lists with names and details.
- **Android Status:** ✅ Cloned
- **Files touched:** `ios/.../LibraryView.swift` → `android/.../TrainerLibraryScreen.kt`
- **Notes:** —

### 2026-04-21 — [ios] Trainer Messages (inbox)
- **Screen:** Trainer Messages (T-M-05)
- **iOS Change:** Conversation list with unread badges. Name, preview, time.
- **Android Status:** ✅ Cloned
- **Files touched:** `ios/.../TrainerMessagesView.swift` → `android/.../TrainerMessagesScreen.kt`
- **Notes:** —

### 2026-04-21 — [ios] Trainer Settings
- **Screen:** Trainer Settings (T-M-07)
- **iOS Change:** Profile section (Edit, Billing, Branding). Preferences toggles (Push, Email). Support links. Sign Out button.
- **Android Status:** ✅ Cloned
- **Files touched:** `ios/.../TrainerSettingsView.swift` → `android/.../TrainerSettingsScreen.kt`
- **Notes:** Sign Out on both platforms now returns to role picker. Floating badge removed.

---

## Pending Decisions

> Android agent proposes deviations here. Human approves/rejects.

*None currently.*

---

## Resolved Decisions

| Date | Decision | Rationale |
|------|----------|-----------|
| 2026-04-21 | Remove floating role badge | Too high, collided with back nav / Dynamic Island. Sign Out moved to Profile/Settings. |
| 2026-04-21 | Android charts use Canvas | No external chart dependency. Custom Canvas line chart matches iOS visual. |

---

*Append new entries at the top. Do not delete old entries.*
