# FitHero — Screen Status Matrix

> Living document tracking implementation status across **both platforms**.
> Last updated: 2026-04-29

**Legend**
- `✅` Done — built and functional
- `🟡` Partial — exists but missing features
- `❌` Not built
- `🚫` Out of scope (Phase 2)

---

## CLIENT MOBILE

| ID | Screen | iOS Status | Android Status | iOS File | Android File | Notes |
|----|--------|-----------|----------------|----------|--------------|-------|
| C-M-01 | **Invite Landing / Sign Up** | ✅ | ✅ | `ClientAuthView.swift` | `auth/ClientAuthScreen.kt` | Trainer invite landing, invite code field, email/password, Apple/Google SSO stubs, sign-in/sign-up toggle. |
| C-M-02 | **Onboarding Intake** | ✅ | ✅ | `ClientOnboardingView.swift` | `ClientOnboardingScreen.kt` | 5-step form (basics, goals, injuries, experience, measurements). Integrated into client auth flow. |
| C-M-03 | **Add Payment Method** | ✅ | ✅ | `AddPaymentMethodView.swift` | `AddPaymentMethodSheet.kt` | Card form sheet (number, expiry, CVC, brand picker). Mock persistence via @AppStorage. |
| C-M-04 | **Home** | ✅ | ✅ | `ClientHomeView.swift` | `HomeScreen.kt` | Dynamic greeting, workout pills, activity dots, message preview, avatar → Profile sheet. |
| C-M-05 | **Workout Read View** | ✅ | ✅ | `WorkoutReadView.swift` | `WorkoutReadScreen.kt` | Exercise list, progress bar, stat pills, Done/Next/Upcoming chips. |
| C-M-06 | **Active Workout Mode** | ✅ | ✅ | `ActiveWorkoutView.swift` | `ActiveWorkoutScreen.kt` | Set table, weight/reps steppers, rest timer with circular countdown, skip/adjust. |
| C-M-07 | **Workout Summary** | ✅ | ✅ | `WorkoutSummaryView.swift` | `WorkoutSummaryScreen.kt` | Completion hero, stats grid, RPE 1–10 selector, session note, Send to coach / Done. |
| C-M-08 | **Progress** | ✅ | ✅ | `ClientProgressView.swift` | `ProgressScreen.kt` | 5 tabs: Weight (chart+log), PRs, Body, Photos, Check-Ins. |
| C-M-09 | **Schedule** | ✅ | ✅ | `ScheduleView.swift` | `ScheduleScreen.kt` | Session cards, detail sheet, reschedule sheet. EventKit calendar integration (Add to Calendar). |
| C-M-10 | **Messages** | ✅ | ✅ | `MessagesView.swift` | `MessagesScreen.kt` | Chat bubbles, input bar. Functional send, photo picker attachment, video call alert. |
| C-M-11 | **Payments** | ✅ | ✅ | `PaymentsView.swift` | `PaymentsScreen.kt` | Active plan card, payment method row, payment history list. Reached from Profile → Billing. |
| C-M-12 | **Profile** | ✅ | ✅ | `ProfileSheet.swift` | `ProfileSheet.kt` | Editable fields, toggles, support links, Sign Out → role picker. |
| C-M-13 | **Exercise Detail** | ✅ | ✅ | `ExerciseDetailView.swift` | `ExerciseDetailScreen.kt` | Exercise info, muscle groups, equipment, instructions, PR highlight, recent set history. Reached from workout rows, active header, or PRs. |
| C-M-14 | **Workout History** | ✅ | ✅ | `WorkoutHistoryView.swift` | `WorkoutHistoryScreen.kt` | List of completed workouts with date, duration, RPE, stats. Detail sheet per session. Reached from Profile → Activity. |
| C-M-15 | **Add Measurement** | ✅ | ✅ | `AddMeasurementSheet.swift` | `AddMeasurementSheet.kt` | Date picker, weight, body measurements (chest/waist/hips/arms/thighs). Reached from Progress + button. |
| C-M-16 | **Forgot Password** | ✅ | ✅ | `ForgotPasswordSheet.swift` | `auth/ForgotPasswordSheet.kt` | Email input with validation, confirmation state. Shared across client/trainer/auth sign-in. |

### Client Mobile — Out of Scope

| Screen | iOS Status | Android Status | Decision |
|--------|-----------|----------------|----------|
| **Coach Vision** | ✅ | 🚫 | Defer to Phase 2. iOS prototype exists. Android does not clone. |

---

## TRAINER MOBILE

| ID | Screen | iOS Status | Android Status | iOS File | Android File | Notes |
|----|--------|-----------|----------------|----------|--------------|-------|
| T-M-01 | **Sign In / Sign Up** | ✅ | ✅ | `TrainerAuthView.swift` | `auth/TrainerAuthScreen.kt` | Trainer auth with sign-in and sign-up modes. Name, business, email, password fields. Forgot password flow included. |
| T-M-02 | **Today** | ✅ | ✅ | `TodayView.swift` | `trainer/TrainerTodayScreen.kt` | Sessions list with swipe actions, empty state, mark-all-complete, dynamic stats, haptics. |
| T-M-03 | **Clients** | ✅ | ✅ | `ClientsView.swift` | `trainer/TrainerClientsScreen.kt` | Search, filter pills, client rows with status. |
| T-M-04 | **Client Mini-Profile** | ✅ | ✅ | `ClientDetailView.swift` | `trainer/ClientDetailScreen.kt` | Tap client row → detail. 4 tabs. Action buttons: Message (→ chat), Schedule (→ picker), Assign (→ workout library). Workout detail + edit/duplicate/delete from library. |
| T-M-05 | **Messages** | ✅ | ✅ | `TrainerMessagesView.swift` | `trainer/TrainerMessagesScreen.kt` | Conversation inbox with unread badges. Tappable rows → chat sheet. |
| T-M-06 | **Notifications Inbox** | ✅ | ✅ | `NotificationsView.swift` | `trainer/TrainerTodayScreen.kt` (sheet) | Sheet triggered from bell icon on Today tab. |
| T-M-07 | **Settings** | ✅ | ✅ | `TrainerSettingsView.swift` | `trainer/TrainerSettingsScreen.kt` | Profile, preferences, support, Sign Out → role picker. |

### Trainer Mobile — Extra (Beyond MVP)

These Android screens exist but have no iOS MVP equivalent. Built for trainer convenience.

| Screen | Android File | Notes |
|--------|-------------|-------|
| **Trainer Library** | `trainer/TrainerLibraryScreen.kt` | Exercise + workout library browser. iOS equivalent is spread across `ExerciseListView` + `WorkoutListView`. |
| **New Exercise** | `trainer/NewExerciseSheet.kt` | Sheet to create a new exercise. iOS: `NewExerciseSheet`. |
| **New Workout** | `trainer/NewWorkoutSheet.kt` | Sheet to build a new workout. iOS: `NewWorkoutSheet`. |
| **Workout Detail** | `trainer/WorkoutDetailScreen.kt` | View workout details. iOS: `WorkoutDetailView`. |
| **Edit Workout** | `trainer/EditWorkoutSheet.kt` | Edit workout name/category/exercises. iOS: `EditWorkoutSheet`. |
| **Exercise Picker** | `trainer/ExercisePickerSheet.kt` | Add exercises from library when building a workout. iOS: `ExercisePickerSheet`. |

### Trainer Mobile — Out of Scope

| Screen | iOS Status | Android Status | Decision |
|--------|-----------|----------------|----------|
| **New Client Evaluation** | ✅ | 🚫 | Not in MVP. iOS prototype exists. Do not clone. |

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
| Client Mobile | 16 | 16 | 16 | 0 | 1 |
| Trainer Mobile | 7 | 7 | 7 | 0 | 1 |
| Trainer Web | 16 | 0 | 0 | 16 | 0 |
| **TOTAL** | **39** | **23** | **23** | **0** | **2** |

---

*Update this file after every session. If you change a screen, update both your platform's cell and the Notes column.*
