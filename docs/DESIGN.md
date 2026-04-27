# FitHero — Design System

> Single source of truth for all design tokens, components, screen layouts, and interaction patterns across iOS (SwiftUI) and Web (Next.js / React).
> Based on PRODUCT_SPEC.md §11 + existing SwiftUI prototype (`FHTheme.swift`, `Client/`, `Trainer/`).
> Palette: **Volt** (dark-first, electric lime).

---

## 1. Brand Direction

**Adjectives:** confident, calm, premium, focused, energetic-but-not-loud.

**Avoid:** neon gym-bro aesthetics, hyper-masculine, busy gradients, stock fitness photography of grimacing people.

**Reference moodboard:** Linear (clarity), Whoop (data confidence), Apple Fitness (warmth), Strava (movement), Notion (calm utility), Headspace (approachability).

**MVP principle:** the client app must be usable by both a 34-year-old marketing manager (Alex) and a 58-year-old rehab client (Sam). Clean, generous spacing, plain language, no gamification clutter.

---

## 2. Color System

### 2.1 Primary Palette — "Volt" (Ship This)

| Token | Hex | SwiftUI | CSS / Tailwind | Usage |
|-------|-----|---------|----------------|-------|
| `--bg` | `#0B0D10` | `FH.Colors.bg` | `bg-[#0B0D10]` | App background (dark) |
| `--surface` | `#14181D` | `FH.Colors.surface` | `bg-[#14181D]` | Cards, sheets |
| `--surface-2` | `#1C2128` | `FH.Colors.surface2` | `bg-[#1C2128]` | Elevated cards, inputs, button secondary bg |
| `--border` | `#262C34` | `FH.Colors.border` | `border-[#262C34]` | Hairlines, dividers, card strokes |
| `--text` | `#F4F6F8` | `FH.Colors.text` | `text-[#F4F6F8]` | Primary text on dark |
| `--text-muted` | `#9BA4AE` | `FH.Colors.textMuted` | `text-[#9BA4AE]` | Secondary text |
| `--text-subtle` | `#5E6671` | `FH.Colors.textSubtle` | `text-[#5E6671]` | Tertiary, captions, placeholders |
| `--primary` | `#C6FF3D` | `FH.Colors.primary` | `bg-[#C6FF3D]` | Primary CTAs, highlights, brand accent |
| `--primary-ink` | `#0B0D10` | `FH.Colors.primaryInk` | `text-[#0B0D10]` | Text on primary buttons |
| `--accent` | `#5B8CFF` | `FH.Colors.accent` | `bg-[#5B8CFF]` | Links, secondary accents, trainer avatars |
| `--success` | `#22C55E` | `FH.Colors.success` | `bg-[#22C55E]` | Confirmations, completed sets, online indicator |
| `--warning` | `#F5B83D` | `FH.Colors.warning` | `bg-[#F5B83D]` | Warnings, PR highlights |
| `--danger` | `#FF5C5C` | `FH.Colors.danger` | `bg-[#FF5C5C]` | Errors, destructive actions |

### 2.2 Light Mode Fallback (Phase 2)

| Token | Hex | Usage |
|-------|-----|-------|
| `--bg-light` | `#FAFAF7` | Light mode background |
| `--surface-light` | `#FFFFFF` | Light mode card |
| `--text-light` | `#0B0D10` | Light mode text |

> **MVP rule:** ship dark-only. Light mode is Phase 2. All web and native code should default to dark.

### 2.3 Gradients

```swift
// Primary gradient (rarely used — prefer solid primary)
FH.Colors.primaryGradient = LinearGradient(
    colors: [Color(hex: 0xC6FF3D), Color(hex: 0xA8E025)],
    startPoint: .topLeading,
    endPoint: .bottomTrailing
)

// Surface gradient (subtle depth)
FH.Colors.surfaceGradient = LinearGradient(
    colors: [Color(hex: 0x14181D), Color(hex: 0x0B0D10)],
    startPoint: .top,
    endPoint: .bottom
)
```

### 2.4 Color Usage Rules

- **No gradients on buttons.** Solid `--primary` only.
- **No glassmorphism.** No blur/backdrop filters.
- **No skeuomorphic shadows.** Cards use 1px `--border` stroke on dark. Soft shadows only on light surfaces (web modals).
- **Primary opacity variants:** use `.opacity(0.15)` for subtle highlights, `.opacity(0.1)` for backgrounds, `.opacity(0.3)` for borders.
- **Success opacity:** `.opacity(0.15)` for completed-exercise backgrounds, `.opacity(0.1)` for done badges.

---

## 3. Typography

### 3.1 Font Families

| Role | Font | Weight | Usage |
|------|------|--------|-------|
| Primary | **Inter** | 400–600 | UI text, body, labels, buttons |
| Display | **Sora** or **Space Grotesk** | 700 | Large numbers, page titles, stat values |
| Monospace | **SF Mono** (iOS) / **JetBrains Mono** (web) | 500 | Timers, sets/reps/weights, timestamps |

> **Numeric rule:** all workout-logging numbers use **tabular figures** (`font-variant-numeric: tabular-nums` on web; `.monospacedDigit()` in SwiftUI).

### 3.2 Type Scale

| Token | Size | Line | Weight | Usage | iOS Code |
|-------|------|------|--------|-------|----------|
| `display-xl` | 56px | 60px | 700 | Marketing hero | — |
| `display-l` | 40px | 44px | 700 | Page titles (web) | — |
| `display-m` | 32px | 36px | 700 | Section heads | — |
| `h1` | 28px | 32px | 700 | Screen titles (mobile) | `.system(size: 28, weight: .bold)` |
| `h2` | 22px | 26px | 700 | Card titles, workout names | `.system(size: 22, weight: .bold)` |
| `h3` | 17px | 24px | 600 | Subheads | `.system(size: 17, weight: .semibold)` |
| `body` | 15px | 22px | 400 | Default body text | `.system(size: 15)` |
| `body-s` | 13px | 20px | 400 | Secondary text | `.system(size: 13)` |
| `caption` | 12px | 16px | 500 | Labels, captions, tracking 1.2 | `.system(size: 12, weight: .semibold)` |
| `numeric-xl` | 64px | 64px | 700 | Workout reps/weights (tabular) | `.system(size: 64, weight: .bold, design: .rounded)` |
| `numeric-l` | 32px | 36px | 700 | Stat values, durations | `.system(size: 32, weight: .bold, design: .rounded)` |

### 3.3 Label Styling Pattern

All section labels in cards use this exact pattern:

```swift
Text("SECTION NAME")
    .font(.system(size: 12, weight: .semibold))
    .foregroundStyle(FH.Colors.textSubtle)
    .tracking(1.2)
    .textCase(.uppercase)
```

---

## 4. Spacing & Layout

### 4.1 Token System (4pt base grid)

| Token | Value | SwiftUI | Usage |
|-------|-------|---------|-------|
| `xs` | 4px | `FH.Spacing.xs` | Tight internal gaps |
| `sm` | 8px | `FH.Spacing.sm` | Icon-to-label gaps, pill padding |
| `md` | 12px | `FH.Spacing.md` | Card internal padding (loose) |
| `base` | 16px | `FH.Spacing.base` | Screen horizontal padding, card padding |
| `lg` | 20px | `FH.Spacing.lg` | Section spacing |
| `xl` | 24px | `FH.Spacing.xl` | Major section gaps |
| `xxl` | 32px | `FH.Spacing.xxl` | Between card groups |
| `xxxl` | 40px | `FH.Spacing.xxxl` | Bottom safe area padding |
| `huge` | 56px | `FH.Spacing.huge` | Hero spacing |

### 4.2 Platform Layout Rules

**iOS Mobile:**
- Screen horizontal padding: `16px` (`FH.Spacing.base`)
- Bottom padding for scrollable content: `40px` (`FH.Spacing.xxxl`) to clear home indicator
- Tab bar: 5 items max. Tint: `--primary`.
- Status bar area: no custom styling, let system handle.

**Web App:**
- Max content width: `1280px`
- Sidebar width: `256px`
- Content area: `1024px`
- Screen padding: `24px` for desktop, `16px` for tablet, `16px` for mobile web

---

## 5. Radius & Elevation

| Token | Value | Usage |
|-------|-------|-------|
| `sm` | 6px | Small pills, tags, chips |
| `md` | 10px | Buttons, input fields, small cards |
| `lg` | 16px | Standard cards, list rows |
| `xl` | 24px | Modals, bottom sheets, hero cards |
| `pill` | 999px | Capsule buttons, badges, avatars |

**Elevation rules:**
- Cards: `radius: lg`, `1px border: --border`, **no shadow** on dark backgrounds
- Modals/Sheets: `radius: xl`, soft shadow `0 8px 32px rgba(0,0,0,0.4)`
- Buttons: `radius: md`
- Input fields: `radius: md`
- Pills/Chips: `radius: pill`

---

## 6. Iconography

### 6.1 Libraries

| Platform | Library | Stroke | Style |
|----------|---------|--------|-------|
| iOS | **SF Symbols** | 1.75pt (font-weight: medium/semibold) | Hierarchical rendering, monochrome or single-color |
| Web | **Lucide Icons** | 1.75px | Stroke only, never filled |

> **Rule:** one icon library per platform. Never mix Lucide and Phosphor on web. Never mix SF Symbols with custom icons on iOS.

### 6.2 Common Icon Mapping

| Concept | iOS SF Symbol | Web Lucide |
|---------|--------------|------------|
| Home | `house.fill` | `Home` |
| Workout | `dumbbell.fill` | `Dumbbell` |
| Progress | `chart.line.uptrend.xyaxis` | `TrendingUp` |
| Schedule | `calendar` | `Calendar` |
| Messages | `message.fill` | `MessageSquare` |
| Send | `paperplane.fill` | `Send` |
| Check/Done | `checkmark` | `Check` |
| Rest/Timer | `timer` | `Timer` |
| Video | `video.fill` | `Video` |
| Settings | `gearshape.fill` | `Settings` |
| Add | `plus.circle.fill` | `PlusCircle` |
| Close | `xmark` | `X` |
| Chevron | `chevron.right` | `ChevronRight` |
| Online indicator | — | — | Green dot (`--success`) + "Online" text |

---

## 7. Components

### 7.1 Card

**Standard Card (`fhCard`):**
- Padding: `16px` (`base`)
- Background: `--surface`
- Radius: `16px` (`lg`)
- Border: `1px solid --border`
- No shadow

```swift
// SwiftUI
SomeView()
    .fhCard()

// Equivalent manual
.padding(FH.Spacing.base)
.background(FH.Colors.surface)
.clipShape(RoundedRectangle(cornerRadius: FH.Radius.lg))
.overlay(
    RoundedRectangle(cornerRadius: FH.Radius.lg)
        .stroke(FH.Colors.border, lineWidth: 1)
)
```

**Interactive Card (exercise row, session card):**
- Same as standard + `opacity: 0.75` when done/completed
- Border highlight: `1px --primary opacity 0.35` when "next" or active
- Press feedback: `scaleEffect(0.98)` or `opacity(0.9)`

**Stat Card:**
- Same as standard + centered content
- Icon above value above label
- Value: `numeric-l` scale, `--primary` if highlighted

### 7.2 Buttons

**Primary Button (`FHPrimaryButtonStyle`):**
- Height: ~52px (padding vertical 14px + font size)
- Font: 16px, weight 600
- Text color: `--primary-ink`
- Background: `--primary`
- Radius: `10px` (`md`)
- Full width (`maxWidth: .infinity`)
- Pressed: `opacity: 0.85`, `scale: 0.98`

```swift
Button("Start Workout") { }
    .buttonStyle(FHPrimaryButtonStyle())
```

**Secondary Button (`FHSecondaryButtonStyle`):**
- Height: ~44px (padding vertical 12px)
- Font: 15px, weight 500
- Text color: `--text`
- Background: `--surface-2`
- Border: `1px solid --border`
- Radius: `10px`
- Pressed: `opacity: 0.8`

**Ghost / Icon Button:**
- Size: `44×44px` tap target (WCAG AA)
- Background: `--surface-2` or transparent
- Icon: `--text-muted`, `--primary` when active
- Radius: `pill` (circle)

**Pill / Tag / Badge:**
- Padding: `horizontal 10px`, `vertical 4–6px`
- Font: 11–12px, weight 500–600
- Radius: `pill`
- Background: `--surface-2` (default), `--primary opacity 0.1` (accent), `--success opacity 0.1` (done)
- Border: optional `1px` stroke matching background tint

### 7.3 Inputs

**Text Input:**
- Background: `--surface`
- Border: `1px solid --border`
- Radius: `md` (10px) or `pill` (999px) for chat input
- Text: `--text`, 15px
- Placeholder: `--text-subtle`
- Focused border: `--primary opacity 0.5`
- Padding: `horizontal 16px`, `vertical 12–14px`
- Height: ~52px

**Stepper (weight/reps input):**
- Minus / Plus buttons: `44×52px`, `--text` icon
- Value display: `numeric-xl` style, `--primary`, min width 56px
- Label below value: 9px, weight 600, `--text-subtle`, tracking 1
- Background: `--surface`, border `1px --border`, radius `md`

### 7.4 Segmented Control / Tabs

**Pill-style segmented control (Progress tabs):**
- Container: `--surface`, radius `lg`, padding `4px`
- Active pill: `--primary` bg, `--primary-ink` text, weight 600
- Inactive pill: transparent bg, `--text-muted` text, weight 500
- Transition: `easeInOut(duration: 0.2)`

**Bottom Nav (iOS):**
- 4–5 items max
- Tint: `--primary`
- Unselected: `--text-muted`

### 7.5 Avatar

- Size: `40–48px` diameter
- Shape: circle
- Fallback: initials, `--primary` text on `--primary opacity 0.15` background
- Online indicator: `7px` green (`--success`) dot, bottom-right offset

### 7.6 Progress Indicators

**Linear Progress:**
- Track: `--surface-2`, height `6px`, radius `3px`
- Fill: `--primary`
- Animation: `easeInOut(duration: 0.3)`

**Circular Ring (evaluation dial, rest timer):**
- Track: `--surface-2` or `--border`
- Fill: `--primary` or angular gradient
- Stroke width: `4–10px`, line cap `.round`
- Rotation: `.degrees(-90)`
- Animation: `easeInOut(duration: 0.3)` for progress, `.linear(duration: 1)` for countdowns

**Activity Dots (weekly streak):**
- Size: `28px` circle
- Done: `--primary` fill + `checkmark` icon (`--primary-ink`)
- Skipped/Rest: `--surface-2` fill + small `10px` `--primary` dot
- Future/None: `--surface-2` fill only

### 7.7 Chat Bubble

- Trainer message: `--surface` background, `--text` color, left-aligned
- Client message: `--primary` background, `--primary-ink` color, right-aligned
- Radius: `lg` (16px), no tail/pointer
- Padding: `horizontal 16px`, `vertical 12px`
- Timestamp: 11px, `--text-subtle`, below bubble
- Max width: 75% of screen, with `60px` min spacer on opposite side

### 7.8 Bottom Sheet / Modal

- Background: `--surface` or `--bg`
- Radius: `xl` (24px) top corners only
- Handle: `38×5px` rounded rect, `--text` at 20% opacity
- Drag indicator: visible
- Detents: `[.fraction(0.55), .large]` for video/content sheets
- Entry: slide up, `easeOut(duration: 0.25)`

### 7.9 Toast / Banner

- Background: `--surface-2`
- Border: `1px --border`
- Radius: `lg`
- Icon + text + optional action
- Position: top of screen (web) or bottom above nav (mobile)
- Duration: 3 seconds, auto-dismiss

---

## 8. Screen Architecture

### 8.1 iOS Screen Template

Every client screen follows this structure:

```
┌─────────────────────────────┐  ← Safe area
│  H1 Title              [+]  │  ← Header: 28px bold, optional action button
│  Subtitle text              │  ← 14px --text-muted
├─────────────────────────────┤
│                             │
│  [ CARD 1 ]                 │  ← fhCard, 16px horizontal padding
│                             │
│  [ CARD 2 ]                 │
│                             │
│         ...                 │
│                             │
├─────────────────────────────┤
│  [ Bottom CTA ]             │  ← Fixed bottom bar if needed
└─────────────────────────────┘  ← Home indicator safe area
```

**Rules:**
- Background: `--bg` on all screens
- Horizontal padding: `16px`
- Vertical gap between cards: `20–24px`
- Scroll view: always `showsIndicators: false`
- Bottom safe area: `40px` padding on scroll content

### 8.2 Full-Screen Flow Template (Workout)

```
┌─────────────────────────────┐
│  [←]  Title          [X]    │  ← 44px height nav bar
├─────────────────────────────┤
│                             │
│      CONTENT AREA           │
│                             │
├─────────────────────────────┤
│  [ Primary CTA ]            │  ← Fixed bottom action bar
└─────────────────────────────┘
```

- Nav bar: `44px` height, horizontal padding `16px`
- Back/close buttons: `34–44px` circular tap targets, `--surface-2` background
- Bottom CTA bar: `bg --bg`, top divider `1px --border`, padding `16px horizontal, 20px bottom`

### 8.3 Web App Layout

```
┌────────┬─────────────────────────────────┐
│        │  Header / Breadcrumbs           │
│  Side  ├─────────────────────────────────┤
│  Nav   │                                 │
│  256px │      Main Content Area          │
│        │      (1024px max)               │
│        │                                 │
│        │                                 │
└────────┴─────────────────────────────────┘
```

- Side nav: `256px` fixed, `--surface` background, `1px` right border `--border`
- Content: `1024px` max, centered within remaining viewport
- Card grid: 2–3 columns depending on content density
- Modal drawer: slides from right, `480px` width on desktop, full-screen on mobile

---

## 9. Existing Screens (iOS Prototype)

### 9.1 Client Home (`ClientHomeView`)

**Layout:** Scrollable vertical stack of cards.

**Sections (top to bottom):**
1. **Greeting** — `h1` (28px bold), dynamic by time of day. Avatar circle `48px` with `--primary opacity 0.15` bg, initial fallback.
2. **Today's Workout Card** — `fhCard`.
   - Header row: "TODAY'S WORKOUT" label (12px `--primary`, tracking 1.2) + duration pill (13px `--text-muted`)
   - Workout name: `h2` (22px bold)
   - Meta: exercise count + category (14px `--text-muted`)
   - Exercise preview pills: horizontal scroll, capsule shape, `--surface-2` bg, 12px text
   - CTA: `FHPrimaryButtonStyle`, "Start Workout" with arrow icon
3. **Weekly Activity Card** — `fhCard`.
   - Header: "THIS WEEK" label + "3 of 5 workouts" count
   - 7 day dots (M T W T F S S), `28px` circles, activity state logic
4. **Next Session Card** — `fhCard`.
   - "NEXT SESSION" label
   - Icon in `44px` rounded square, `--accent opacity 0.15` bg
   - Session type + trainer name (15px semibold), date/time (13px), location if present
   - Chevron right
5. **Message Preview Card** — `fhCard`.
   - "MESSAGES" label + unread badge (`20px` circle, `--primary` bg)
   - Avatar + name + message preview (2 lines) + relative time

### 9.2 Workout Read View (`WorkoutReadView`)

**Layout:** Full-screen, scrollable, fixed bottom bar.

**Top bar:**
- Left: close button (`34px` circle, `--surface-2`, `xmark` icon)
- Center: category label (10px uppercase) + "TODAY" badge (11px `--primary`, monospaced)
- Right: `34px` clear spacer for balance

**Progress header:**
- Workout name: `h1` (28px bold)
- Progress counter: `doneCount / totalCount`, monospaced, `--primary` for done count
- Linear progress bar: `6px` height, `--surface-2` track, `--primary` fill
- Stat pills: duration, total sets, done count (if > 0)

**Exercise list:**
- Section label: "EXERCISES" (11px uppercase) + "Tap any to jump" hint
- Rows: `fhCard` style interactive cards
  - Left: `48px` status icon (done = checkmark in `--success` bg; next = exercise icon in `--primary` bg; upcoming = icon in `--surface-2`)
  - Center: exercise name (15px semibold), sets/reps + rest (12px monospaced)
  - Right: "Done" badge, "Next" pill (`--primary` bg), or chevron
  - Done rows: `opacity 0.75`, strikethrough name
  - Next row: `1px --primary opacity 0.35` border

**Bottom bar:**
- Divider `1px --border`
- Left: next exercise name + remaining count
- Right: "Start" / "Continue" pill button (`--primary` bg, capsule shape, `48px` height)

### 9.3 Active Workout (`ActiveWorkoutView`)

**Layout:** Full-screen, no scroll. Vertical stack: nav → divider → video strip → exercise header → set table → bottom panel.

**Nav bar:**
- Left: "← List" back button
- Center: "Exercise N of M" + capsule progress indicators (active capsule `18px` wide, `--primary`; inactive `6px`, `--surface-2`)
- Right: elapsed timer (monospaced, 13px `--text-subtle`)

**Video strip (conditional):**
- Only shows if demo video exists for exercise
- `52×36px` thumbnail + play icon + "Watch demo" text
- Tap opens sheet with `VideoPlayer`, detents `[.fraction(0.55), .large]`

**Exercise header:**
- `44px` icon in `--primary opacity 0.1` rounded square
- Name: 18px bold
- Chips: sets, reps, rest — capsule, `--surface-2` bg, 11px

**Set table:**
- Container: `--surface` bg, `radius: lg`, `1px --border`
- Header row: SET | TARGET | KG | REPS | (check col)
  - Font: 10px semibold, `--text-subtle`, tracking 0.8
- Data rows:
  - Set number: 14px bold rounded, color by state (done = `--success`, active = `--primary`, future = `--text-subtle`)
  - Target: 13px, strikethrough if done
  - Actual KG/REPS: shown only if done, otherwise "—"
  - Check circle: `22px`, filled `--success` + checkmark, or empty `--surface-2`
  - Active row: `--primary opacity 0.05` background highlight

**Bottom panel (input mode):**
- Trainer note (if exists): quote icon + italic text, 12px `--text-muted`
- Weight + Reps steppers side by side
  - Minus / Plus buttons: `44×52px`
  - Value: 22px bold `--primary`, monospaced
  - Label: 9px semibold, `--text-subtle`, tracking 1
- "Log Set N" button: `FHPrimaryButtonStyle` variant, `52px` height, checkmark icon

**Bottom panel (rest mode):**
- Circular timer: `56px` diameter, `4px` stroke
  - Track: `--surface-2`
  - Fill: `--primary`, trim from top (`-90°`)
  - Countdown text: 18px bold monospaced inside
- "Rest" label + "Next: Set N" sublabel
- Controls: `−15` / `Skip` / `+15` buttons
  - Skip: `--primary` bg, `--primary-ink` text
  - Adjust: `--surface-2` bg

### 9.4 Workout Summary (`WorkoutSummaryView`)

**Layout:** Scrollable + fixed bottom bar.

**Completion hero:**
- `100px` circle, `--primary opacity 0.12` fill, `--primary opacity 0.3` stroke
- `40px` checkmark icon inside
- "Workout Complete": 28px bold
- Workout name: 16px `--text-muted`

**Stats grid:**
- 3-column layout, `FH.Spacing.sm` gap
- Each tile: icon (16px) + value (22px bold) + label (10px uppercase)
- Volume tile: `--primary` accent border + icon

**RPE section:**
- Header: "HOW HARD WAS IT?" label + dynamic text label ("Hard 🔥")
- 5×2 grid of number pills (1–10)
  - Selected: `--primary` bg, `--primary-ink` text
  - Unselected: `--surface-2` bg, `--text` color
  - Press animation: `easeInOut(duration: 0.12)`
- Footer: "RPE N/10 · description" (12px monospaced `--text-subtle`)

**Note section:**
- "SESSION NOTE" label
- `TextEditor` in `--surface` container, `radius: lg`
  - Placeholder: "How did it feel? Any PRs or issues..."
  - Focused border: `--primary opacity 0.5`
  - Unfocused border: `--border`
  - Min height: 80px

**Bottom bar:**
- "Send to coach" (secondary style, `--surface-2`) + "Done" (primary)
- Both `50px` height, `radius: lg`

### 9.5 Client Progress (`ClientProgressView`)

**Layout:** Fixed header + segmented control + scrollable content.

**Header:**
- Title: "Progress" (28px bold) + subtitle "8 weeks of training" (14px `--text-muted`)
- Action: `plus.circle.fill` icon, 28px, `--primary`

**Segmented control:**
- Pills: "Weight" · "PRs" · "Body" · "Photos"
- Active: `--primary` bg, `--primary-ink` text, weight 600
- Inactive: `--surface` bg, `--text-muted` text, weight 500
- Container: `--surface` bg, `radius: lg`, padding `4px`

**Weight tab:**
- Summary card: 3 stat blocks (Current / Start / Change), `fhCard`
- Chart card: `fhCard` containing SwiftUI Chart
  - LineMark: `--primary`, 2.5px, `.catmullRom`
  - AreaMark: gradient `--primary opacity 0.2 → 0`
  - PointMark: 24px
  - Y-axis: 4 ticks, 11px `--text-subtle`
  - X-axis: bi-weekly stride, 10px `--text-subtle`
  - Grid: `--border`
- Log card: `fhCard`, reverse-chronological list, divider between rows

**PRs tab:**
- List of PR cards, each `fhCard`
- Left: `48px` rounded square, `--warning opacity 0.12`, trophy icon
- Center: exercise name (16px semibold) + date (13px `--text-subtle`)
- Right: value (20px bold `--primary`), monospaced

**Body tab:**
- Measurement rows, each `fhCard`
- Name (15px medium) + current value (16px semibold) + delta (13px, green/orange/gray)

**Photos tab:**
- Start vs Current comparison row: two large placeholder cards (`140px` height), label + date below
- Photo timeline grid: adaptive `100–120px` columns, `4px` gap
- Each cell: colored placeholder (`--primary` / `--accent` / `--warning` / `--success` tint) + SF Symbol + label + date
- "+ Add" cell: dashed border (`--primary opacity 0.3`, dash `[6, 4]`), `plus` icon, opens `AddPhotoSheet`

**Add Photo Sheet:**
- Large photo capture area (`300px` height, dashed border)
- Label picker chips: "Progress" · "Front" · "Back" · "Side" · "Flexed"
- Save button: `FHPrimaryButtonStyle`

> **Missing:** Check-Ins tab (side-by-side comparison).

### 9.6 Schedule (`ScheduleView`)

**Layout:** Fixed header + scrollable session cards.

**Header:** "Schedule" (28px bold) + "Upcoming sessions" (14px `--text-muted`)

**Session cards:**
- Date column: weekday (11px uppercase `--text-subtle`), day number (24px bold, `--primary` if next), month (12px `--text-muted`)
- Vertical divider: `2px` wide, `--primary` if next session, `--border` otherwise
- Content: type icon (`32px` rounded square, type-color bg) + type name (15px semibold) + trainer name (13px)
- Meta: time, duration, location (if present)
- Actions (only for next session): "Add to Calendar" pill (`--primary` text + bg) + "Reschedule" pill
- **Tap gesture on card:** opens `SessionDetailSheet`

**Past sessions section:**
- "PAST SESSIONS" label
- Checkmark + session description + relative time

**Session Detail Sheet:**
- Layout: `NavigationStack` sheet, full height
- Date header: weekday + large day number + month + time, centered, `--surface` card
- Info card: type, trainer, duration, location — each as `detailRow` with icon
- Actions: "Add to Calendar" (`--primary` text + bg) + "Reschedule" (`--surface-2` bg)

**Reschedule Sheet:**
- Current session summary card
- Graphical date + time picker (`DatePicker`, `.graphical` style)
- Duration chips: 15m · 30m · 45m · 60m · 90m
- "Send Reschedule Request" primary CTA
- Confirmation alert on send

### 9.7 Messages (`MessagesView`)

**Layout:** Fixed header + scrollable chat + fixed input bar.

**Chat header:**
- Avatar (`44px`) + name (17px semibold) + online indicator (`7px` green dot)
- Video call button: `40px` circle, `--surface` bg

**Chat body:**
- "Today" date header (12px `--text-subtle`)
- Bubbles: trainer left, client right (see Component 7.7)

**Input bar:**
- Photo attach button (18px `--text-muted`)
- TextField: `--surface` bg, `radius: pill`, `1px --border`
- Send button: `arrow.up.circle.fill`, 32px, `--primary` when active, `--text-subtle` when empty

> **Missing:** Actual send logic, image attachment flow, push notifications.

### 9.8 App Root / Role Selection (`AppRootView`)

**Not a shipping screen.** Built for prototype demo only.

- Background: `--bg`
- Logo mark: `64px` rounded square, `--primary` bg, "FH" text (22px black)
- "FitHero": 36px bold, `--text`, tracking `-1`
- Buttons: "Trainer" (primary) + "Hero" (secondary)
- Floating role badge: capsule, `--surface` bg, `1px --border`, top-left

> **Decision:** Replace with real auth gate (sign in / sign up) before shipping.

---

## 10. Missing MVP Screens (To Build)

### 10.1 Client Mobile

#### C-M-01 — Invite Landing / Sign Up
- **Layout:** Centered vertical stack, generous vertical spacing.
- **Elements:**
  - Trainer avatar (`80px`) + name (22px bold) + "invited you to train together" (15px `--text-muted`)
  - "Accept & set up" primary CTA
  - Apple / Google SSO buttons (secondary style, icon + text)
  - Email + password fields (standard input style)
- **Edge:** If already has account → redirect to sign-in with email pre-filled.

#### C-M-02 — Onboarding Intake
- **Layout:** Multi-step, full-screen pages with horizontal swipe transition.
- **Pattern:** Progress dots at top (5 dots), large tap targets, skip-optional fields.
- **Steps:**
  1. Basics: name, age, height, weight
  2. Goals: selectable goal cards (lose weight, build muscle, rehab, general health)
  3. Injuries/medical: checkbox list + notes textarea
  4. Experience: radio buttons (beginner / intermediate / advanced)
  5. Measurements: optional photo upload + baseline measurements
- **CTA:** "Continue" primary, "Skip for now" ghost button.

#### C-M-03 — Add Payment Method
- **Layout:** Centered modal/sheet.
- **Elements:** Stripe payment sheet (native iOS `STPPaymentSheet` or web Stripe Elements).
- **Edge:** "Skip" button if trainer hasn't requested payment yet.

#### C-M-08 additions — Photos Tab & Check-Ins Tab
**Photos Tab:**
- Grid: 3-column, `4px` gap
- Each cell: square thumbnail, `radius: md`
- Tap → full-screen viewer with swipe
- "Add Photo" FAB triggers camera/gallery

**Check-Ins Tab (side-by-side):**
- Split view: previous week (left) vs current week (right)
- Section: Weight (value + delta arrow), Measurements (6-site list with deltas), Photos (before/after pair)
- Delta colors: green = improvement (trainer-defined direction), red = opposite, gray = no change
- "Submit Check-In" primary CTA at bottom
- Weekly cadence, push notification nudge

#### C-M-09 additions — Session Detail Sheet
- **Layout:** Bottom sheet, `detent: .fraction(0.6)`
- **Elements:**
  - Session type icon + name
  - Date, time, duration, location/link
  - "Add to Calendar" secondary button
  - "Request Reschedule" secondary button → opens date picker + time slots
  - "Message Trainer about this" ghost button

#### C-M-11 — Payments
- **Layout:** Scrollable list + card at top.
- **Elements:**
  - Active plan card: plan name, amount, next billing date, status pill
  - Payment history: chronological list, each row = date + amount + status (paid/pending/failed) + receipt link
  - "Update Payment Method" secondary button

#### C-M-12 — Profile
- **Trigger:** Tap avatar in Home tab header (`48px` circle, `--primary opacity 0.15` bg)
- **Layout:** Sheet with `NavigationStack`, scrollable grouped sections
- **Header section:**
  - Large avatar (`88px` circle, `--primary opacity 0.15` bg, initials)
  - Name (20px bold) + plan tier (14px `--text-muted`)
  - Centered, `--surface` card background
- **Personal Info section:**
  - Inline editable fields: Name, Age, Height, Weight
  - Each row: icon (`36px` rounded square, color tint) + label (15px medium) + `TextField` (15px semibold `--primary`, right-aligned)
  - Keyboard types: `.default`, `.numberPad`, `.decimalPad`
  - Values persist via `@AppStorage`
- **Notifications section:**
  - Toggle rows: Workout Reminders, Messages, Progress Updates
  - Each row: icon + label + `Toggle` (tint `--primary`)
  - Values persist via `@AppStorage`
- **Support section:**
  - "Help & Support" row → `mailto:` link
  - "Terms & Privacy" row → web link
  - External link indicator (`arrow.up.right`)
- **Sign Out:**
  - Destructive row (`--danger` text + icon)
  - `--surface` bg, `1px --border` stroke
- Background: `--bg`, section labels: 12px uppercase `--text-subtle`, tracking 1.2

### 10.2 Trainer Mobile

#### T-M-01 — Sign In
- Same auth pattern as client. Shared credentials, role determined by `User.role`.
- Decision: separate app entry or shared entry with role selector post-auth?

#### T-M-02 — Today
- **Layout:** Scrollable list, grouped by time.
- **Elements:**
  - Date header
  - Session rows: client avatar + name + time + type icon
  - Swipe actions: "Complete" (`--success`), "Add Note" (`--accent`)
  - "Mark all complete" button if > 1 session
  - Empty state: "No sessions today — enjoy the break ☕"

#### T-M-03 — Clients
- **Layout:** Search bar at top + scrollable list.
- **Elements:**
  - Search input: `--surface` bg, `radius: pill`, magnifying glass icon
  - Filter chips: "All" · "Active" · "Pending" · "Paused" — pill style
  - Client rows: avatar (`48px`) + name (16px semibold) + plan/status (13px `--text-muted`) + last activity (13px `--text-subtle`)
  - Tap → T-M-04 mini-profile

#### T-M-04 — Client Mini-Profile
- **Layout:** Bottom sheet or push screen.
- **Elements:**
  - Header: large avatar + name + status pill
  - Quick stats: last workout, next session, current program
  - Action buttons (horizontal scroll or grid): Message, Log Check-In, View Progress, Assign Program
  - Recent notes: 2–3 latest trainer notes

#### T-M-05 — Messages
- Reuse `MessagesView` components.
- Difference: conversation list on left (if iPad/landscape), or push to chat.

#### T-M-06 — Notifications Inbox
- **Layout:** Grouped list by date.
- **Elements:** Icon + title + description + relative time + unread dot.
- Types: workout completed, payment received, message received, session reminder.

#### T-M-07 — Settings
- **Layout:** Grouped list.
- **Sections:** Profile, Notifications, Sign Out.
- No billing/branding here (web only).

### 10.3 Trainer Web (Next.js)

All 16+ screens are greenfield. See `PRODUCT_SPEC.md` §9.1 for detailed specs.

Key screens to design first:
1. **T-W-04 Dashboard** — the "wow" screen. Left nav + stat cards + activity feed.
2. **T-W-09 Program Builder** — 3-pane drag-and-drop. The core differentiator.
3. **T-W-06 Client Detail** — 7 tabs. Most information-dense screen.

---

## 11. Motion & Animation

### 11.1 Principles
- Motion communicates state, never decorates.
- Default duration: `180–220ms`.
- Default easing: `cubic-bezier(0.2, 0.8, 0.2, 1)` (ease-out-quint feel).
- SwiftUI: `.easeInOut(duration: 0.2)` for UI state changes.
- Web: Framer Motion for React.

### 11.2 Specific Patterns

**Button press:**
- Scale: `0.98`
- Opacity: `0.85`
- Duration: `100ms`

**Card selection / tab switch:**
- Background color transition
- Duration: `200ms`
- Easing: `easeInOut`

**Progress animations:**
- Linear progress fill: `easeInOut(duration: 0.3)`
- Circular ring fill: `easeInOut(duration: 0.3)`
- Rest timer countdown: `linear(duration: 1)` per second

**Bottom sheet:**
- Entry: slide up `easeOut(duration: 0.25)`
- Exit: slide down `easeIn(duration: 0.2)`
- Backdrop: fade `opacity 0 → 0.5`, `duration: 0.2`

**Workout flow transitions:**
- Read → Active: full-screen cover, no animation (instant)
- Active → Summary: full-screen cover, optional scale-in of checkmark hero
- Summary → Read: dismiss, reset state

**Haptics (iOS):**
- Log set complete: medium impact
- Rest timer last 3 seconds: light impact per tick
- Rest timer finish: medium impact + subtle scale bounce on timer circle
- Workout complete: success notification + heavy impact

**Numeric transitions:**
- Stat value changes: `contentTransition(.numericText(countsDown: false))`
- Weight/reps stepper: instant (no animation — trainers need speed)

---

## 12. Voice & Tone

### 12.1 General Rules
- Conversational, warm, never bro-y. "Nice work today, Alex" not "BEAST MODE 💪".
- Plain language. "Today's workout" not "Scheduled training session".
- Error messages: honest, short, actionable. Never "Oops!". Use: "Couldn't save. Check your connection and try again."

### 12.2 Trainer-Facing Copy
- Functional and efficient. "3 invoices pending" not "You have some invoices waiting".
- Buttons: "Send invoice", "Assign program", "Mark complete".

### 12.3 Client-Facing Copy
- Human and encouraging. "You crushed your bench PR!" not "Bench PR achieved".
- Workout labels: "Today's workout", "Rest day", "Start workout".
- Empty states: "No workouts this week — enjoy the rest! 🌴"

### 12.4 Notifications
- Push: concise, actionable. "Your workout is ready 💪" not "You have a scheduled training session available."
- Email: slightly more formal but still warm. Subject lines under 50 characters.

---

## 13. Asset Guidelines

### 13.1 Icons
- **iOS:** SF Symbols, hierarchical rendering, weight `.medium` or `.semibold`
- **Web:** Lucide Icons, stroke `1.75`, never filled
- **Size:** 16px (small pills), 20px (list icons), 24px (nav), 28px (FAB)

### 13.2 Exercise Visuals
- **MVP:** Flat illustrations (consistent style, ~300 exercises). Licensed or commissioned.
- **Phase 2:** Short looping MP4/WebP videos (2–4s, neutral background, CDN-hosted).
- **Placeholder:** SF Symbol figure icons (`figure.strengthtraining.traditional`, etc.) with `--primary` tint.

### 13.3 Avatars / Photos
- Client avatar: initials on colored background, `pill` radius
- Progress photos: client-uploaded, cropped square, compressed to < 2MB
- Trainer photo: professional headshot, circular crop

### 13.4 Empty States
- Illustration: simple line art or friendly abstract shape (`--primary` accent)
- Headline: 20px bold, `--text`
- Subtext: 14px `--text-muted`
- CTA: primary button if actionable

---

## 14. File Mapping

| Design Token / Component | iOS Location | Web Location (future) |
|--------------------------|-------------|----------------------|
| Color tokens | `FHTheme.swift` → `FH.Colors` | `tailwind.config.ts` → `colors` |
| Spacing tokens | `FHTheme.swift` → `FH.Spacing` | `tailwind.config.ts` → `spacing` |
| Radius tokens | `FHTheme.swift` → `FH.Radius` | `tailwind.config.ts` → `borderRadius` |
| Card modifier | `FHCardModifier` | Reusable `<Card />` component |
| Primary button | `FHPrimaryButtonStyle` | `<Button variant="primary" />` |
| Secondary button | `FHSecondaryButtonStyle` | `<Button variant="secondary" />` |
| Sample data | `FHModels.swift` → `SampleData` | Mock API routes / fixtures |
| App entry | `fitheroApp.swift` | `app/layout.tsx` |
| Navigation | `MainTabView.swift` | React Router / Next.js App Router |

---

## 15. Design Decision Log

| Date | Decision | Context |
|------|----------|---------|
| 2026-04-08 | Palette A (Volt) chosen over Coast | More distinctive, photographs better, works in both dark/light |
| 2026-04-21 | Side-by-side check-ins added to MVP | Erika feedback: primary retention tool for trainers |
| 2026-04-21 | Alias search added to MVP | Erika feedback: trainers use different terminology |
| 2026-04-21 | Client emulation mode added to MVP | Erika feedback: trainers need to test UX as client |
| 2026-04-21 | 1RM calculation clarified in MVP | Erika feedback: strength analytics from day one |
| 2026-04-21 | Pre-approved exercise swaps = MVP stretch | Medium complexity, high value — ship if time permits |
| 2026-04-21 | Wearables, nutrition, AI = Phase 2 | Explicitly deferred per original spec |

---

*This document is the single source of truth. When building any new screen, reference this file first. Update the Design Decision Log when making visual or interaction changes.*
