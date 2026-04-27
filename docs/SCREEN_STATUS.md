# FitHero — Screen Status Matrix

> Living document tracking implementation status across **both platforms**.
> Last updated: 2026-04-27

**Legend**
- `✅` Done — built and functional
- `🟡` Partial — exists but missing features
- `❌` Not built
- `🚫` Out of scope (Phase 2)

---

## CLIENT MOBILE

| ID | Screen | iOS Status | Android Status | iOS File | Android File | Notes |
|----|--------|-----------|----------------|----------|--------------|-------|
| C-M-01 | **Invite Landing / Sign Up** | ✅ | ❌ | `ClientAuthView.swift` | — | Trainer invite landing, invite code field, email/password, Apple/Google SSO stubs, sign-in/sign-up toggle. Reached via `AuthEntryView`. |
| C-M-02 | **Onboarding Intake** | ✅ | ❌ | `ClientOnboardingView.swift` | — | 5-step form (basics, goals, injuries, experience, measurements). Integrated into client auth flow. |
| C-M-03 | **Add Payment Method** | ❌ | ❌ | — | — | Stripe. Not started. |
| C-M-04 | **Home** | ✅ | ✅ | `ClientHomeView.swift` | `HomeScreen.kt` | Dynamic greeting, workout pills, activity dots, message preview, avatar → Profile sheet. |
| C-M-05 | **Workout Read View** | ✅ | ✅ | `WorkoutReadView.swift` | `WorkoutReadScreen.kt` | Exercise list, progress bar, stat pills, Done/Next/Upcoming chips. |
| C-M-06 | **Active Workout Mode** | ✅ | ✅ | `ActiveWorkoutView.swift` | `ActiveWorkoutScreen.kt` | Set table, weight/reps steppers, rest timer with circular countdown, skip/adjust. |
| C-M-07 | **Workout Summary** | ✅ | ✅ | `WorkoutSummaryView.swift` | `WorkoutSummaryScreen.kt` | Completion hero, stats grid, RPE 1–10 selector, session note, Send to coach / Done. |
| C-M-08 | **Progress** | ✅ | ✅ | `ClientProgressView.swift` | `ProgressScreen.kt` | 4 tabs: Weight (chart+log), PRs, Body, Photos. |
| C-M-09 | **Schedule** | ✅ | ✅ | `ScheduleView.swift` | `ScheduleScreen.kt` | Session cards, detail sheet, reschedule sheet with duration chips. |
| C-M-10 | **Messages** | ✅ | ✅ | `MessagesView.swift` | `MessagesScreen.kt` | Chat bubbles, input bar. Send/attach are stubs on both. |
| C-M-11 | **Payments** | ❌ | ❌ | — | — | Requires Stripe + backend. |
| C-M-12 | **Profile** | ✅ | ✅ | `ProfileSheet.swift` | `ProfileSheet.kt` | Editable fields, toggles, support links, Sign Out → role picker. |

### Client Mobile — Out of Scope

| Screen | iOS Status | Android Status | Decision |
|--------|-----------|----------------|----------|
| **Coach Vision** | ✅ | ❌ | Defer to Phase 2. iOS prototype exists. Android does not clone. |

---

## TRAINER MOBILE

| ID | Screen | iOS Status | Android Status | iOS File | Android File | Notes |
|----|--------|-----------|----------------|----------|--------------|-------|
| T-M-01 | **Sign In / Sign Up** | ✅ | ❌ | `TrainerAuthView.swift` | — | Trainer auth with sign-in and sign-up modes. Name, business, email, password fields. |
| T-M-02 | **Today** | ✅ | ✅ | `TodayView.swift` | `TrainerTodayScreen.kt` | Sessions list, stats, notifications sheet. |
| T-M-03 | **Clients** | ✅ | ✅ | `ClientsView.swift` | `TrainerClientsScreen.kt` | Search, filter pills, client rows with status. |
| T-M-04 | **Client Mini-Profile** | ✅ | ✅ | `ClientDetailView.swift` | `ClientDetailScreen.kt` | Tap client row → detail. 4 tabs: Overview, Programs, Progress, Notes. |
| T-M-05 | **Messages** | ✅ | ✅ | `TrainerMessagesView.swift` | `TrainerMessagesScreen.kt` | Conversation inbox with unread badges. |
| T-M-06 | **Notifications Inbox** | ✅ | ✅ | `NotificationsView.swift` | `TrainerTodayScreen.kt` (sheet) | Sheet triggered from bell icon on Today tab. |
| T-M-07 | **Settings** | ✅ | ✅ | `TrainerSettingsView.swift` | `TrainerSettingsScreen.kt` | Profile, preferences, support, Sign Out → role picker. |

### Trainer Mobile — Out of Scope

| Screen | iOS Status | Android Status | Decision |
|--------|-----------|----------------|----------|
| **New Client Evaluation** | ✅ | ❌ | Not in MVP. iOS prototype exists. Do not clone. |

---

## TRAINER WEB

> Entire surface is greenfield. No iOS/Android equivalent.

| ID | Screen | Status | Notes |
|----|--------|--------|-------|
| T-W-01 → T-W-16 | All web screens | ❌ | Next.js stack. Not started. |

---

## CROSS-CUTTING

| Item | iOS Status | Android Status | Notes |
|------|-----------|----------------|-------|
| **Role Selection / App Root** | ✅ | ✅ | Demo switcher. Both platforms match. |
| **Design System (Volt)** | ✅ | ✅ | Color tokens, spacing, radius, cards. Both match. |
| **Shared Models / Sample Data** | ✅ | ✅ | Exercise, Workout, ChatMessage, etc. |
| **Push Notifications** | ❌ | ❌ | Not started. |
| **Offline Support** | ❌ | ❌ | Not started. |

---

## QUANTIFIED STATUS

| Surface | Screens | iOS ✅ | Android ✅ | ❌ Both | 🚫 |
|---------|---------|--------|-----------|---------|-----|
| Client Mobile | 12 | 10 | 8 | 1 | 1 |
| Trainer Mobile | 7 | 7 | 6 | 0 | 1 |
| Trainer Web | 16 | 0 | 0 | 16 | 0 |
| **TOTAL** | **35** | **17** | **14** | **16** | **2** |

---

*Update this file after every session. If you change a screen, update both your platform's cell and the Notes column.*
