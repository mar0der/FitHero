# FitHero — Product Specification (v0.1)

> **Owner:** Peter (Founder / PM)
> **Author:** Senior Product Designer
> **Status:** Draft for design + engineering kickoff
> **Date:** 2026-04-08
> **Working name:** FitHero (final name TBD)

---

## 1. Executive Summary

FitHero is a SaaS platform for **individual and small personal trainers** to run their entire coaching business from one app — and for their **clients** to receive workouts, log progress, schedule sessions, message their coach, and pay, all in a single beautiful experience.

The product wins on **two axes**:
1. **Convenience** — every action a trainer or client needs is two taps away.
2. **Design quality** — feels like a premium consumer app, not a clunky SMB tool.

It does **not** try to win on AI, exhaustive features, or being a "platform for everyone." That keeps cost-per-client near zero and the surface area small.

**Business model.** The trainer is the paying customer. FitHero charges the trainer **per active client account** on a low monthly fee. Client-to-trainer payments flow through FitHero via Stripe Connect (revenue share optional, see §5). Clients never pay FitHero directly.

**MVP goal.** Ship a focused product that one trainer can use to fully manage 10–30 clients, accept payments, and deliver programs — with zero AI, zero "marketplace," zero "social feed."

---

## 2. Vision, Goals, Non-Goals

### 2.1 Vision
Become the default operating system for the independent personal trainer — the way Square became the default for the independent merchant. Loved by trainers because it's affordable and saves them hours every week. Loved by clients because it's the nicest fitness app on their phone.

### 2.2 MVP Goals (what success looks like 6 months post-launch)
- **Activation:** 70% of signed-up trainers add ≥3 clients in their first 14 days.
- **Retention:** 60% of trainers active in month 3.
- **Client engagement:** 50% of invited clients log at least one workout per week.
- **Unit economics:** Average gross margin per trainer ≥ 80% (i.e. infra cost per trainer-with-15-clients < $1.50/mo).
- **NPS:** ≥ 50 from trainers, ≥ 40 from clients.

### 2.3 Non-Goals (explicitly out of scope for MVP)
- AI features of any kind (form check, program generation, chatbot).
- Group classes / bootcamps / one-to-many session management.
- Nutrition / meal planning (deferred to Phase 2 add-on).
- In-app video calls (use Zoom/Google Meet links in MVP).
- Marketplace / "find a trainer" directory.
- Social feed, leaderboards, public profiles.
- Wearable integrations (Apple Health / Garmin / Whoop) — Phase 2.
- Custom branding / white-label — Phase 2 add-on.
- Multi-trainer gyms / staff seats — Phase 2.

---

## 3. Personas

### 3.1 Trainer — "Maya, 31, independent PT"
- 4 years independent. Used to use a mix of WhatsApp, Google Sheets, Notion, Calendly, and Revolut/Stripe links.
- 18 active clients at $200–400/mo each.
- Spends ~6 hours/week on admin she'd rather spend training.
- Frustrations: chasing payments, rewriting programs, losing track of who needs what, no clean way to share progress with clients.
- Goals: spend more time coaching, look professional, get paid on time.
- Tech comfort: high. Uses Instagram for marketing, comfortable with apps, will *not* tolerate ugly software.

### 3.2 Trainer — "Tom, 47, PT at a small studio + 8 private clients"
- Less tech-savvy than Maya. Uses paper notebooks.
- Will adopt FitHero only if onboarding is **dead simple** and his clients aren't confused.

### 3.3 Client — "Alex, 34, marketing manager, trains 3x/week with Maya"
- Wants to know: what am I doing today, did I do it, what's next, when's my next session, did I pay.
- Uses iPhone primarily. Will not download a second app for "log my food" or whatever.
- Will judge the product on its first 60 seconds and its first workout screen.

### 3.4 Client — "Sam, 58, trains 2x/week with Tom for back rehab"
- Lower tech tolerance. Needs huge tap targets, clear language, no jargon.

**Design implication:** the client app must be usable by *both* Alex and Sam. That means: clean, generous spacing, plain language, no gamification clutter.

---

## 4. Competitive Landscape (brief)

| Product | Strength | Weakness we exploit |
|---|---|---|
| **Trainerize** | Mature feature set | Dated UI, complex, expensive at scale |
| **TrueCoach** | Strong with serious coaches | Limited payment handling, web-feels-like-2018 |
| **Everfit** | Free tier, AI push | Cluttered, AI-first not coach-first |
| **PT Distinction** | Powerful for nutrition | Steep learning curve, ugly client experience |
| **Spreadsheets + WhatsApp + Stripe links** | Free, flexible | The status quo we're displacing |

**Our wedge:** the *prettiest, simplest* product in the category, with native payment handling, priced for solo trainers.

---

## 5. Business Model & Pricing

### 5.1 Primary revenue: per-client SaaS fee to trainer

| Plan | Active clients | Price (USD/mo) | Per-client cost |
|---|---|---|---|
| **Solo** (free tier) | up to 3 | $0 | $0 — acquisition funnel |
| **Starter** | up to 15 | $19/mo | $1.27 |
| **Pro** | up to 40 | $39/mo | $0.98 |
| **Studio** | up to 100 | $79/mo | $0.79 |

> *Final pricing TBD via market test. The structure (free + 3 paid tiers, capped by active clients) is the recommended model.*

**"Active client" = a client who has logged in or had a workout assigned in the trailing 30 days.** Inactive clients do not count toward the cap. This is critical: it removes friction from inviting/keeping prospects and avoids punishing trainers for retention dips.

### 5.2 Secondary revenue (MVP-eligible)
- **Stripe Connect platform fee** on client→trainer payments. Recommended: **1.0%** flat on top of Stripe's processing fees, or **$0** (fully passthrough) on the Studio plan as a perk. Test both.

### 5.3 Future revenue (Phase 2+, NOT in MVP)
- **AI add-ons** ($10–20/mo): program generation, form-check via video, smart scheduling.
- **Branded client app** ($25/mo): trainer's logo + colors, custom icon.
- **Lead generation** ($X per qualified lead): opt-in directory listing.
- **Premium content marketplace**: trainers sell programs to other trainers, FitHero takes 15%.
- **Wearable sync premium**: Apple Health / Garmin / Whoop integration.
- **Nutrition module**: meal logging + macro targets.
- **Document signing**: PAR-Q forms, liability waivers.

**Locked principle:** none of the above ship in MVP. They are levers for after PMF.

---

## 6. Product Architecture

FitHero is delivered across **three surfaces**:

| Surface | Audience | Why this surface |
|---|---|---|
| **Trainer Web App** | Trainer | Heavy program-building, billing, dashboard work — better on a real screen |
| **Trainer Mobile App** | Trainer | On-the-go: check-ins, messaging, marking sessions complete |
| **Client Mobile App** | Client | Where they live — workouts, logging, payments, chat |

**Shared backend.** Single API/database. Trainer mobile and client mobile can share a React Native (Expo) codebase via role-based routing to keep build cost low.

**No client web app in MVP.** Clients can pay invoices via web link, but the day-to-day experience is mobile-only. This simplifies scope dramatically.

---

## 7. MVP Feature Set (locked)

This is the **must-ship** list. Anything not here is deferred.

### 7.1 Trainer (Web + Mobile)
1. **Account & onboarding**
   - Email/password + Google/Apple sign-in
   - Stripe Connect Express onboarding (KYC)
   - Profile setup: name, photo, bio, timezone, currency
2. **Client management**
   - Invite client by email or shareable link
   - Client list (search, filter by status: active / pending / paused)
   - Client profile: contact, goals, intake form answers, notes
   - **Client emulation mode:** trainer can switch into a read-only client view to test UX, record demo videos, and verify program appearance
3. **Program builder**
   - Create reusable workout templates
   - Drag-and-drop exercises into days
   - Set sets / reps / rest / tempo / RPE / notes per exercise
   - Built-in exercise library (~300 exercises with clean illustrations or short looping videos)
   - **Alias-based search:** exercises searchable by multiple names (e.g., "Bench Press" and "Chest Press")
   - Add custom exercise (with optional uploaded video)
   - **Pre-approved exercise alternatives (MVP stretch):** trainer can define swap options per exercise so clients substitute when equipment is busy without choosing inappropriate movements
   - Assign program to client (one-off or recurring weekly)
4. **Scheduling**
   - Calendar view: day / week / month
   - Create session (1:1 only in MVP), recurring optional
   - Session types: in-person, video (Zoom/Meet link field), check-in
   - Client receives notification + calendar invite
5. **Messaging**
   - 1:1 chat with each client (text + image attachments)
   - Push + email notifications
   - **No group chat in MVP**
6. **Payments**
   - Send invoice (one-off)
   - Create subscription package (e.g., "8 sessions/month for $320")
   - View payments, payouts, outstanding balances
   - Auto-charge clients on saved card
7. **Dashboard**
   - Today's sessions
   - Unread messages
   - Pending payments
   - This week's revenue
   - New client requests
8. **Settings**
   - Profile, branding (logo + accent color preview only), billing (the trainer's own FitHero subscription), notifications

### 7.2 Client (Mobile only)
1. **Onboarding**
   - Accept invite from trainer
   - Set password / sign in with Apple/Google
   - Complete intake form (height, weight, goals, injuries, experience, medical flags)
   - Add payment method
2. **Home**
   - Today's workout (or rest day)
   - Next session card
   - Latest message preview
   - Quick progress strip (last 7 days)
3. **Workout**
   - Read view: list of exercises, sets, reps, video/illustration, trainer notes
   - **Active workout mode**: tap-through sets, rest timer auto-starts, log weight + reps + RPE
   - Mark workout complete → trainer sees it
4. **Progress**
   - Body weight chart
   - Body measurements (chest, waist, hips, arms, thighs)
   - Progress photos (private to client + trainer)
   - **Weekly check-in with side-by-side comparison:** previous week's data displayed directly alongside current week for instant visual trend demonstration
   - Personal records (auto-calculated from logged sets, including estimated 1RM from sub-maximal sets using standard formulas)
5. **Schedule**
   - Upcoming sessions
   - Request reschedule (sends message to trainer in MVP — no auto-rescheduling logic yet)
6. **Messages**
   - 1:1 chat with trainer
7. **Payments**
   - Active plan/subscription
   - Payment history + receipts
   - Update card
8. **Profile**
   - Edit personal info
   - Notifications, sign out, support

### 7.3 Cross-cutting
- Push notifications (Expo)
- Email notifications (transactional only — Resend or Postmark)
- Time zone handling
- Soft-delete / data export (GDPR)
- Empty states + first-run tutorials (lightweight, dismissible)

---

## 8. Phase 2 (post-MVP, NOT for design now)

Listed here so designers know where extensibility is needed in MVP foundations:

- AI program generation (premium add-on)
- AI form-check via uploaded video (premium add-on)
- Nutrition logging
- Wearable sync (Apple Health, Garmin, Whoop)
- Group programs / cohorts
- Trainer-to-trainer template marketplace
- Custom-branded client app
- Document signing + customizable form builder (waivers, PAR-Q, weekly check-in templates editable by trainer)
- Pre-approved exercise alternatives (full feature: client-initiated swaps with trainer-controlled substitution list)
- Heart-rate intelligence: HR zone suggestions per training plan, automated effort ratings from wearable HR data post-workout
- Smart exercise suggestions (AI-powered alternate recommendations)
- Multi-staff / studio mode
- Public trainer profile + lead-gen directory

---

## 9. Detailed Screen Specs

For each surface, screens are listed with: **purpose**, **key elements**, **primary CTA**, and **edge cases**. Designers should treat each as a separate Figma frame.

> Notation: `T-W-##` = Trainer Web, `T-M-##` = Trainer Mobile, `C-M-##` = Client Mobile.

### 9.1 Trainer Web

**T-W-01 — Sign Up**
- Elements: logo, email, password, Google/Apple SSO, "I'm a trainer" copy block, social proof strip
- Primary CTA: Create account
- Edge: existing email → friendly redirect to login

**T-W-02 — Stripe Connect Onboarding**
- Elements: progress bar, "Set up payouts" framing, embedded Stripe Connect Express flow
- Primary CTA: Continue to Stripe
- Edge: skip-for-now allowed but flagged in dashboard until completed

**T-W-03 — Profile Setup**
- Elements: profile photo upload, display name, short bio, timezone, currency, accent color picker
- Primary CTA: Continue to dashboard

**T-W-04 — Dashboard**
- Layout: left nav (Dashboard, Clients, Programs, Schedule, Messages, Payments, Settings) + main grid
- Modules (top-to-bottom):
  - Greeting + date
  - "Today" card: list of today's sessions with client avatar, time, type
  - Stat row: Active clients · This week's revenue · Outstanding payments · Unread messages
  - Recent activity feed (client X logged workout, client Y paid invoice)
- Primary CTA: contextual per module
- Edge: empty state → "Invite your first client" hero

**T-W-05 — Clients List**
- Elements: search, filter chips (Active / Pending / Paused / All), sortable table or card grid (toggle), avatar, name, plan, last activity, status, quick actions (message, view)
- Primary CTA: + Invite client
- Edge: empty → onboarding hero with invite link

**T-W-06 — Client Detail**
- Tabs: Overview · Programs · Sessions · Progress · Payments · Messages · Notes
- Header: avatar, name, status pill, quick actions (Message, Assign program, Schedule session, Send invoice)
- Overview tab modules: goals, intake summary, last 4 workouts, next session, current plan
- Edge: no programs assigned yet → CTA to assign

**T-W-07 — Invite Client (modal)**
- Elements: email field, optional personal note, copy shareable link
- Primary CTA: Send invite

**T-W-08 — Programs (Library)**
- Elements: grid of program template cards (cover image, name, duration, # of sessions), search, "+ New program"
- Primary CTA: + New program

**T-W-09 — Program Builder**
- Layout: 3-pane
  - Left: weeks/days outline (drag to reorder)
  - Center: selected day → exercise blocks (drag to reorder, set sets/reps/rest/tempo/notes)
  - Right: exercise library search (drag exercises into center pane)
- Top bar: program name, save/publish, assign-to-client
- Edge: unsaved changes warning on navigate

**T-W-10 — Exercise Library**
- Elements: searchable list, category filters (Push / Pull / Legs / Core / Mobility / Cardio / etc.), "+ Add custom"
- Edge: custom exercise modal with name, category, video upload, instructions

**T-W-11 — Schedule (Calendar)**
- Views: Day / Week / Month toggle
- Elements: color-coded events by client, drag to reschedule, click to edit
- Primary CTA: + New session
- Edge: timezone mismatch warning when client TZ ≠ trainer TZ

**T-W-12 — New/Edit Session (modal or right drawer)**
- Elements: client picker, date/time, duration, type (in-person / video / check-in), location or video link, recurring toggle, notes
- Primary CTA: Save & notify client

**T-W-13 — Messages**
- Layout: left list of conversations (avatar, name, last message preview, unread badge), right pane chat
- Elements: text input, image attach, send
- Edge: empty thread → suggested first message

**T-W-14 — Payments Overview**
- Modules: balance card (this month gross, payouts to date), pending invoices list, recent transactions, "+ New invoice" / "+ New subscription"
- Primary CTA: + New invoice

**T-W-15 — New Invoice / Subscription (modal)**
- Elements: client picker, line items, amount, currency, due date or recurrence, optional message
- Primary CTA: Send

**T-W-16 — Settings**
- Tabs: Profile · Branding · Billing (the trainer's FitHero plan) · Notifications · Integrations · Danger zone

**T-W-17 — Client Emulation Mode**
- Elements: banner indicating "Viewing as [Client Name]", read-only client home/workout/progress screens, one-tap exit back to trainer view
- Primary CTA: Exit emulation
- Edge: changes made in emulator are not persisted (or optionally logged as trainer notes)

### 9.2 Trainer Mobile (lighter — focused on on-the-go)

**T-M-01** Sign in
**T-M-02** Today (list of today's sessions, quick mark complete, quick add note)
**T-M-03** Clients (list, search, tap → profile)
**T-M-04** Client mini-profile (last workout, next session, message, log a check-in note)
**T-M-05** Messages (full chat)
**T-M-06** Notifications inbox
**T-M-07** Settings (limited subset)

> Trainer mobile is **deliberately scoped down**. Program building and billing happen on web. Mobile is for the 80% of daily-driver actions.

### 9.3 Client Mobile

**C-M-01 — Invite landing / Sign up**
- Trainer's name + photo prominent ("Maya invited you to train together")
- Primary CTA: Accept & set up

**C-M-02 — Onboarding intake**
- Multi-step (5 screens, max): basics → goals → injuries/medical → experience → measurements
- Progress bar, large tap targets, skip-optional fields

**C-M-03 — Add payment method**
- Stripe payment sheet
- Skippable if trainer hasn't sent any payment request yet

**C-M-04 — Home**
- Greeting + day-of-week
- Today card: Workout name, est duration, "Start workout" CTA — or "Rest day" if none
- Next session card: time, type, location/link, "Add to calendar"
- Message preview card if unread
- Progress strip (last 7 days dots)

**C-M-05 — Workout (read view)**
- Header: workout name, est duration
- Vertical list of exercises with thumbnail, name, sets×reps, rest, trainer note
- Bottom CTA: Start workout

**C-M-06 — Active workout mode**
- One exercise at a time, full-screen
- Big visual (looping video or illustration)
- Set tiles: target reps × weight, tap to log
- Auto rest timer with skip + +15s
- Swipe / button to next exercise
- "Finish workout" → summary screen with PRs highlighted

**C-M-07 — Workout summary**
- Time taken, total volume, any new PRs
- "How did it feel?" mood/RPE picker
- Optional note
- Send to trainer

**C-M-08 — Progress**
- Tabs: Weight · Measurements · Photos · PRs · Check-Ins
- Charts (clean line, minimal axes)
- **Check-In tab (side-by-side):** split view showing previous week (left) vs current week (right) for weight, measurements, and photos. Trend arrows (↓↑→) and delta values. Designed for trainer to screen-share or show client in-person.
- "+ Log" floating button
- "Submit Check-In" CTA (weekly cadence, nudged via push notification)

**C-M-09 — Schedule**
- Upcoming sessions list
- Tap → session detail, request reschedule, add to calendar
- Past sessions section

**C-M-10 — Messages**
- 1:1 thread with trainer

**C-M-11 — Payments**
- Active plan card
- Payment history list with receipts
- Update payment method

**C-M-12 — Profile**
- Personal info, notifications, support, sign out

---

## 10. Key User Flows

These are the **flows designers should prototype first** because they make or break the product feel.

### 10.1 Trainer first-run (5 minutes to value)
1. Sign up → 2. Verify email → 3. Stripe Connect (or skip) → 4. Profile photo + bio → 5. **Invite first client (mandatory step before reaching dashboard, but skippable)** → 6. Dashboard with empty state nudging "Build your first program"

> **Design rule:** the trainer must hit "wow, this is mine" within 5 minutes. No long forms, no surveys.

### 10.2 Client first workout (under 60 seconds from notification to first set)
1. Push notification "Today's workout is ready" → 2. Tap → app opens to Home → 3. Tap "Start workout" → 4. First exercise full-screen → 5. Tap to log first set

> **Design rule:** if it takes more than 5 taps from notification to logging the first set, redesign.

### 10.3 Get paid
1. Trainer creates invoice or subscription → 2. Client receives push + email → 3. One-tap pay with saved card (or Apple Pay first time) → 4. Both parties see receipt instantly

### 10.4 Assign a program
1. Trainer opens client profile → 2. "Assign program" → 3. Pick template or start from scratch → 4. Set start date → 5. Client gets push notification

### 10.5 Reschedule a session
1. Client taps session → 2. "Request reschedule" → 3. Picks 2–3 alternative slots → 4. Message sent to trainer → 5. Trainer accepts in chat → 6. Calendar updates for both

---

## 11. Design System

### 11.1 Brand direction
**Adjectives:** confident, calm, premium, focused, energetic-but-not-loud.
**Avoid:** neon gym-bro aesthetics, hyper-masculine, busy gradients, stock fitness photography of grimacing people.
**Reference moodboard:** Linear (clarity), Whoop (data confidence), Apple Fitness (warmth), Strava (movement), Notion (calm utility), Headspace (approachability).

### 11.2 Color system

Two recommended palettes — pick one in design kickoff. Both are designed to feel premium, work in dark + light mode, and survive the WCAG AA contrast bar.

#### Palette A — "Volt" (recommended primary)
A confident dark-first palette with an electric lime accent. Feels modern, energetic, and distinct in a category dominated by orange/red.

| Token | Hex | Usage |
|---|---|---|
| `--bg` | `#0B0D10` | App background (dark) |
| `--surface` | `#14181D` | Cards, sheets |
| `--surface-2` | `#1C2128` | Elevated cards, modals |
| `--border` | `#262C34` | Hairlines, dividers |
| `--text` | `#F4F6F8` | Primary text on dark |
| `--text-muted` | `#9BA4AE` | Secondary text |
| `--text-subtle` | `#5E6671` | Tertiary, captions |
| `--primary` | `#C6FF3D` | Primary CTAs, highlights, brand |
| `--primary-ink` | `#0B0D10` | Text on primary buttons |
| `--accent` | `#5B8CFF` | Links, secondary accents |
| `--success` | `#22C55E` | Confirmations |
| `--warning` | `#F5B83D` | Warnings |
| `--danger` | `#FF5C5C` | Errors, destructive |
| `--bg-light` | `#FAFAF7` | Light mode background |
| `--surface-light` | `#FFFFFF` | Light mode card |
| `--text-light` | `#0B0D10` | Light mode text |

#### Palette B — "Coast"
A warm, light-first alternative. Feels closer to Headspace / Calm. Better if Peter wants the product to skew approachable over performance-driven.

| Token | Hex | Usage |
|---|---|---|
| `--bg` | `#FBF8F4` | App background (light) |
| `--surface` | `#FFFFFF` | Cards |
| `--border` | `#ECE6DB` | Hairlines |
| `--text` | `#1A1A1A` | Primary text |
| `--text-muted` | `#6B6661` | Secondary text |
| `--primary` | `#FF6B4A` | Coral primary |
| `--primary-ink` | `#FFFFFF` | Text on primary |
| `--accent` | `#0E6BA8` | Deep ocean accent |
| `--success` | `#2E9D5C` | |
| `--warning` | `#E0A800` | |
| `--danger` | `#D64545` | |

> **Recommendation:** ship with Palette A. It is more visually distinctive in app stores and screenshots, photographs better, and works in both dark and light. Palette B is the safer fallback if user testing skews older / less performance-oriented (i.e. if the Sam persona dominates).

### 11.3 Typography

Use **two free, modern, geometric sans-serifs** with excellent number rendering (critical for sets/reps/weights):

**Primary:** **Inter** (Google Fonts) — UI text, body, labels.
**Display:** **Sora** or **Space Grotesk** (Google Fonts) — large numbers, page titles, marketing surfaces.

Optional premium upgrade post-PMF: **Satoshi** (Fontshare, free) or **General Sans** (Fontshare, free) for a more distinctive voice.

**Type scale:**
| Token | Size / Line | Usage |
|---|---|---|
| `display-xl` | 56 / 60 | Marketing hero |
| `display-l` | 40 / 44 | Page titles |
| `display-m` | 32 / 36 | Section heads |
| `h1` | 24 / 30 | Screen titles |
| `h2` | 20 / 26 | Card titles |
| `h3` | 17 / 24 | Subheads |
| `body` | 15 / 22 | Default body |
| `body-s` | 13 / 20 | Secondary |
| `caption` | 12 / 16 | Labels, captions |
| `numeric-xl` | 64 / 64 | Workout reps/weights (tabular) |
| `numeric-l` | 32 / 36 | Stat values |

**Numeric rule:** all numbers in workout-logging contexts use **tabular figures** (`font-variant-numeric: tabular-nums`). Trainers and clients must be able to scan columns of weights without misalignment.

### 11.4 Spacing & layout
- 4-pt base grid. Spacing tokens: 4 / 8 / 12 / 16 / 20 / 24 / 32 / 40 / 56 / 80.
- Mobile: 16 px screen padding default, 20 px for marketing/landing screens.
- Web app: max content width 1280, sidebar 256, content 1024.

### 11.5 Radius & elevation
- Radius tokens: `sm 6` / `md 10` / `lg 16` / `xl 24` / `pill 999`.
- Cards: radius `lg`, 1 px border `--border`, no shadow on dark, soft shadow on light.
- Modals: radius `xl`, soft shadow.
- **No skeuomorphic shadows. No glassmorphism. No gradients on buttons.** Solid, calm.

### 11.6 Components (must exist in the design system from day 1)
- Button (primary, secondary, ghost, destructive, icon-only) — 3 sizes
- Input (text, number, textarea, select, date, time, search)
- Toggle / Switch / Checkbox / Radio
- Tag / Pill / Badge
- Avatar (with initial fallback)
- Card (default, interactive, stat)
- Tabs
- Modal / Sheet / Drawer
- Toast / Banner
- Empty state
- Loading skeletons
- Calendar / date picker
- Chart (line, bar) — minimal axes, primary color line, soft grid
- Progress bar / step indicator
- Bottom nav (mobile, 4–5 items max)
- Side nav (web)
- Action sheet (mobile)
- Rest timer (custom component, large)
- Set logger row (custom component, big tap target)

### 11.7 Iconography
Use **Lucide Icons** (open source, 1000+, MIT). Stroke 1.75, never filled. One icon library only.

### 11.8 Motion
- Use motion to communicate state, never to decorate.
- Default duration: 180–220 ms. Default easing: `cubic-bezier(0.2, 0.8, 0.2, 1)` ("ease-out-quint" feel).
- Use Framer Motion (web) and Reanimated (mobile).
- Rest timer countdown is the only "celebratory" motion in MVP — micro-haptic on each second of last 3, big haptic + scale animation when a set completes.

### 11.9 Voice & tone
- Conversational, warm, never bro-y. "Nice work today, Alex" not "BEAST MODE 💪".
- Plain language. "Today's workout" not "Scheduled training session".
- Trainer-facing copy is more functional ("3 invoices pending"), client-facing is more human ("You crushed your bench PR!").
- Error messages are honest, short, and actionable. Never "Oops!".

---

## 12. Asset & Resource Library

Designers should pull from these (all are free/open or low-cost) so we don't reinvent the wheel:

### 12.1 Icons
- **Lucide Icons** — https://lucide.dev (primary)
- **Phosphor Icons** — secondary fallback if Lucide is missing something

### 12.2 Illustrations (for empty states, onboarding)
- **Blush** (https://blush.design) — customizable, friendly
- **Storyset** (https://storyset.com) — free with attribution, broad library
- **unDraw** (https://undraw.co) — free, easy to recolor to brand
- **Humaaans** (https://humaaans.com) — diverse, modular

> **Style rule:** pick **one** illustration set and stick with it. Mixing sets looks amateur. Recommendation: Blush "Pochke" or Storyset "Pana" set, recolored to brand.

### 12.3 Exercise visuals (this is the biggest asset question)
Three options, ranked by recommendation:

1. **Licensed illustration set** — e.g. **Workout Labs** library, or **Strength Level** open assets, or commission a single illustrator to draw ~300 exercises in one consistent flat style. **Best for brand consistency.** Budget: ~$3–6k one-time or ~$0.10–0.50/exercise license.
2. **Short looping MP4 / WebP videos** — 2–4 second loops on a neutral background. Can be sourced from **Musclewiki** (CC), **ExRx**, or filmed with one model in a single day. **Best for clarity but heavier on storage/bandwidth.** Mitigate cost with aggressive compression + a CDN like Cloudflare R2.
3. **3D-rendered models** — most premium, most expensive. Skip for MVP.

> **Recommendation for MVP:** option 1 (licensed flat illustrations) — keeps storage near zero, looks distinctive, and fits the calm aesthetic. Add looping videos in Phase 2.

### 12.4 Stock photography (for marketing site only — never inside the app)
- **Unsplash** fitness collections, curated tightly
- **Pexels** for backups
- Avoid generic "person smiling at protein shake" — prefer real, candid, diverse, low-saturation images

### 12.5 Animations / Lottie
- **LottieFiles** (https://lottiefiles.com) — for celebration animations, loaders, empty states. Use sparingly.

### 12.6 Fonts
- **Google Fonts**: Inter, Sora, Space Grotesk
- **Fontshare** (free pro fonts): Satoshi, General Sans, Switzer

### 12.7 UI kit / component starting points (engineering side)
- **shadcn/ui** + **Radix** for web
- **NativeWind** + **Tamagui** or **gluestack-ui** for React Native
- **Tailwind CSS** as the foundation across both
- **Framer Motion** (web) / **Reanimated** + **Moti** (mobile)

### 12.8 Design tools
- **Figma** as source of truth — set up a single FitHero design system file with tokens, components, and screens
- **Figma variables** for color/spacing/type tokens (exportable to code via `figma-tokens` plugin → JSON → Tailwind config)

---

## 13. Engineering Recommendations (zero-infra-cost path)

> Included so designers and engineering align early and so the per-account cost target stays achievable. Final tech choices belong to the engineering lead.

### 13.1 Stack
- **Web (trainer):** Next.js 14+ (App Router), React, TypeScript, Tailwind, shadcn/ui, deployed on **Vercel** (free tier covers MVP).
- **Mobile (trainer + client):** React Native via **Expo** (EAS Build). Single codebase, role-based routing.
- **Backend:** **Supabase** (Postgres + Auth + Storage + Realtime + Edge Functions). Free tier supports hundreds of users; Pro plan ($25/mo) supports thousands. **This is the single biggest cost-saver.**
- **Payments:** **Stripe Connect Express** for trainer onboarding + client payments + payouts.
- **Push notifications:** **Expo Push** (free).
- **Email:** **Resend** ($0–20/mo at MVP scale) or **Postmark**.
- **File storage:** Supabase Storage (S3-compatible) for exercise videos / progress photos. Cap upload sizes aggressively.
- **Analytics:** **PostHog** (free self-hosted or generous cloud free tier).
- **Error tracking:** **Sentry** (free tier).
- **Domain + CDN:** Cloudflare.

### 13.2 Per-account cost model (estimate at 1,000 trainers × 15 clients each = 15,000 client accounts)
| Item | Estimated monthly cost |
|---|---|
| Supabase Pro (DB + Auth + Storage) | $25–100 |
| Vercel Pro | $20 |
| Resend | $20 |
| PostHog | $0–50 |
| Sentry | $0–26 |
| Cloudflare | $0 |
| **Total** | **~$65–215/mo** |
| **Per trainer** | **~$0.06–0.21** |
| **Per client** | **~$0.004–0.014** |

**Conclusion:** the "near zero per account" target is achievable. The dominant variable cost will be **video/image storage and bandwidth**, which is why MVP defaults to flat illustrations and aggressively compressed photos.

### 13.3 Architecture principles
- **Mobile-first, offline-tolerant.** Workout logging must work without a connection. Sync on reconnect.
- **Realtime only where it matters.** Messages and live workout state. Everything else is request/response.
- **Role-based row-level security in Postgres.** Trainer can only see their clients; client can only see their own data. Enforce in the database, not just the app layer.
- **Single source of truth for design tokens.** Figma variables → JSON → Tailwind config → shared between web and native.
- **Feature flags from day 1.** Use a free tool (PostHog or Unleash) so we can dark-launch Phase 2 features to beta trainers later without merging behind big release branches.

---

## 14. High-Level Data Model

Entities (MVP scope only):

```
User (id, email, role: trainer | client, name, photo, timezone, locale, created_at)
TrainerProfile (user_id, bio, currency, stripe_account_id, plan, accent_color)
ClientProfile (user_id, trainer_id, status, intake_json, joined_at)
Exercise (id, owner_id_nullable, name, aliases_json, category, asset_url, instructions, preapproved_alternatives_json)
Program (id, trainer_id, name, description, weeks_json)
ProgramAssignment (id, program_id, client_id, start_date, status)
WorkoutSession (id, assignment_id, day_index, scheduled_for, status, notes)
SetLog (id, workout_session_id, exercise_id, set_index, target_reps, actual_reps, weight, rpe, completed_at)
Session (id, trainer_id, client_id, starts_at, duration, type, location, video_link, status)
Message (id, thread_id, sender_id, body, attachments_json, sent_at, read_at)
Thread (id, trainer_id, client_id)
Invoice (id, trainer_id, client_id, amount, currency, status, stripe_invoice_id, due_at, paid_at)
Subscription (id, trainer_id, client_id, amount, interval, status, stripe_sub_id)
PaymentMethod (id, client_id, stripe_pm_id, brand, last4)
ProgressEntry (id, client_id, type: weight | measurement | photo | checkin, value_json, taken_at, checkin_week_index)
```

This schema is intentionally lean. Phase 2 features (nutrition, wearables, etc.) bolt on with new tables, never by overloading existing ones.

---

## 15. Compliance, Security, Legal (MVP minimum)

- **GDPR**: explicit consent on signup, data export, account deletion endpoint, processor agreements with Supabase / Stripe / Resend.
- **PCI**: never touch card data — Stripe Connect handles it end-to-end.
- **Health data**: client intake form may include medical flags. Treat as sensitive: encrypt at rest (Supabase default), restrict via RLS, do NOT use for marketing.
- **HIPAA**: explicitly out of scope for MVP. If a trainer wants HIPAA-grade rehab/PT use cases, that's a Phase 2 paid tier with BAAs.
- **Terms / Privacy / Cookie policy**: lawyer-drafted before public launch.
- **Liability disclaimer**: surfaced on client onboarding ("FitHero is a tool, not medical advice").
- **Accessibility**: WCAG 2.1 AA target. All tap targets ≥ 44 pt, all text passes contrast, all flows keyboard-navigable on web.

---

## 16. Success Metrics (instrumented from day 1)

**Trainer-side:**
- Time-to-first-client (target: < 10 min from signup)
- Time-to-first-program (target: < 30 min)
- Time-to-first-paid-invoice (target: < 24 hr after Stripe Connect)
- D7 / D30 trainer retention
- Trial → paid conversion
- Per-trainer monthly active clients

**Client-side:**
- Invite → activation rate (target: > 70%)
- D1 / D7 client retention
- Workouts logged per active client per week (target: ≥ 2)
- Notification open rate

**Business:**
- MRR
- Gross margin per trainer
- Churn (logo + revenue)
- NPS (trainer + client, surveyed quarterly in-app)

Instrument with PostHog from day one. Every screen has a `screen_view` event. Every primary CTA has a `cta_click` event. Funnel views for the 5 key flows in §10.

---

## 17. Open Questions for Peter

These need a decision before or during design kickoff:

1. **Final name.** "FitHero" is a working name. Trademark search needed before logo work.
2. **Geography for launch.** US-only? US + EU? Currency, language, payment methods, and tax handling differ. Recommendation: launch US-only, expand to EU after PMF.
3. **Pricing tiers — final numbers.** §5.1 are my recommendations. Validate with 5–10 trainer interviews before locking.
4. **Stripe platform fee.** Take a 1% cut on client→trainer payments, or zero (revenue purely from SaaS fee)? Affects positioning vs. competitors.
5. **Free tier — yes or no.** Recommendation: yes, capped at 3 clients. Drives organic acquisition.
6. **Brand palette: A or B.** §11.2.
7. **Exercise visuals: license vs. commission vs. film.** §12.3.
8. **Marketing site scope.** Out of this spec — should be a parallel work-stream.
9. **Beta program.** How do we recruit the first 20 trainers? (Recommendation: founder-led outreach to trainers Peter knows + Instagram fitness coach DMs.)
10. **Legal entity, terms, privacy.** Lawyer needed before signups go live.

---

## 18. Recommended Next Steps

1. **Peter** answers §17 questions (or marks parking lot).
2. **Brand & visual designer** (1 week): logo exploration, lock palette + typography, build moodboard, deliver brand guidelines doc.
3. **Product designer** (3–4 weeks): build Figma design system from §11, then design all MVP screens from §9 in low-fi, then high-fi, then prototype the 5 flows from §10.
4. **Eng lead** (parallel, 1 week): stand up Supabase + Next.js + Expo skeletons, auth, Stripe Connect sandbox.
5. **Usability test** the prototype with 5 trainers + 5 clients **before** writing production code.
6. **Build MVP** in 8–12 weeks against this spec.
7. **Closed beta** with 20 trainers.
8. **Public launch** after iterating on beta feedback.

---

## Appendix A — Glossary

- **Active client**: a client who has logged in or had a workout assigned in the last 30 days. Used for billing tier counting.
- **Program**: a reusable training plan template (multi-week, multi-day).
- **Assignment**: an instance of a program given to a specific client with a start date.
- **Session**: a calendar event between trainer and client (in-person, video, or check-in). Distinct from a workout.
- **Workout**: a single day of training within a program.
- **PR**: personal record (max weight × reps for an exercise).
- **RPE**: Rate of Perceived Exertion (1–10 scale, used in many programs).

## Appendix B — Design system token export format

When the design system is built in Figma, export tokens as a JSON file shaped like:

```json
{
  "color": {
    "bg": { "value": "#0B0D10" },
    "primary": { "value": "#C6FF3D" }
  },
  "space": { "1": { "value": "4px" } },
  "radius": { "md": { "value": "10px" } },
  "font": { "family": { "sans": { "value": "Inter, sans-serif" } } }
}
```

Engineering will consume this JSON in both the Tailwind config (web) and a shared theme file (mobile) so design and code can never drift.

---

*End of v0.1. This document is a living spec — version it in git alongside the product.*
