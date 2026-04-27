const pptxgen = require("pptxgenjs");
const fs = require("fs");
const path = require("path");

const pres = new pptxgen();
pres.layout = "LAYOUT_16x9";
pres.author = "Peter — FitHero";
pres.title = "FitHero — Partner Briefing";

// ── Brand palette ──
const C = {
  bg:        "0B0D10",
  surface:   "14181D",
  surface2:  "1C2128",
  border:    "262C34",
  text:      "F4F6F8",
  muted:     "B8BFC7",
  subtle:    "8891A0",
  primary:   "C6FF3D",
  primaryInk:"0B0D10",
  accent:    "5B8CFF",
  success:   "22C55E",
  warning:   "F5B83D",
  danger:    "FF5C5C",
  white:     "FFFFFF",
};

const FONT_TITLE = "Trebuchet MS";
const FONT_BODY  = "Calibri";

// Screenshot paths
const SHOTS = "/Users/petarpetkov/Developer/FitHero/screenshots/framed";
const OUT   = "/Users/petarpetkov/Developer/FitHero/FitHero_Partner_Deck.pptx";

// Helper: create fresh shadow
const cardShadow = () => ({ type: "outer", blur: 8, offset: 3, angle: 135, color: "000000", opacity: 0.25 });

// ════════════════════════════════════════
// SLIDE 1 — COVER
// ════════════════════════════════════════
{
  const s = pres.addSlide();
  s.background = { color: C.bg };

  // Decorative lime accent shape top-right
  s.addShape(pres.shapes.RECTANGLE, { x: 7.5, y: -0.5, w: 3.5, h: 1.8, fill: { color: C.primary, transparency: 8 }, rotate: -8 });
  s.addShape(pres.shapes.RECTANGLE, { x: 8.2, y: -0.3, w: 2.8, h: 1.2, fill: { color: C.primary, transparency: 15 }, rotate: -8 });

  // Logo text
  s.addText("FitHero", { x: 0.8, y: 1.2, w: 5, h: 1.0, fontFace: FONT_TITLE, fontSize: 52, bold: true, color: C.primary, margin: 0 });

  // Tagline
  s.addText("The operating system for\nindependent personal trainers.", { x: 0.8, y: 2.2, w: 6, h: 1.0, fontFace: FONT_BODY, fontSize: 22, color: C.text, lineSpacingMultiple: 1.3, margin: 0 });

  // Subtitle
  s.addText("Partner Briefing  |  Confidential  |  April 2026", { x: 0.8, y: 3.6, w: 6, h: 0.5, fontFace: FONT_BODY, fontSize: 13, color: C.subtle, margin: 0 });

  // Phone mockup on right
  s.addImage({ path: path.join(SHOTS, "01_home.png"), x: 6.8, y: 1.0, w: 2.5, h: 5.1, sizing: { type: "contain", w: 2.5, h: 4.2 } });
}

// ════════════════════════════════════════
// SLIDE 2 — THE PROBLEM
// ════════════════════════════════════════
{
  const s = pres.addSlide();
  s.background = { color: C.bg };

  s.addText("The Problem", { x: 0.8, y: 0.4, w: 8, h: 0.7, fontFace: FONT_TITLE, fontSize: 36, bold: true, color: C.primary, margin: 0 });
  s.addText("Independent trainers cobble together 5–7 tools to run their business.", { x: 0.8, y: 1.1, w: 8, h: 0.5, fontFace: FONT_BODY, fontSize: 16, color: C.muted, margin: 0 });

  // Problem cards — left column
  const problems = [
    { icon: "WhatsApp", desc: "Client communication scattered across WhatsApp, SMS, email" },
    { icon: "Sheets", desc: "Programs built in Google Sheets or scribbled on paper" },
    { icon: "Calendly", desc: "Scheduling via Calendly, DMs, or verbal agreements" },
    { icon: "Stripe", desc: "Payments chased via Revolut links, Venmo, or cash" },
    { icon: "Notion", desc: "Progress tracked in Notion, Notes, or not at all" },
  ];

  problems.forEach((p, i) => {
    const y = 1.85 + i * 0.7;
    // Lime dot
    s.addShape(pres.shapes.OVAL, { x: 1.0, y: y + 0.12, w: 0.18, h: 0.18, fill: { color: C.primary } });
    s.addText(p.desc, { x: 1.4, y: y, w: 5.5, h: 0.5, fontFace: FONT_BODY, fontSize: 15, color: C.text, margin: 0 });
  });

  // Right side — stat callout
  s.addShape(pres.shapes.RECTANGLE, { x: 7.2, y: 1.8, w: 2.5, h: 2.0, fill: { color: C.surface }, shadow: cardShadow() });
  s.addText("6+", { x: 7.2, y: 1.9, w: 2.5, h: 1.0, fontFace: FONT_TITLE, fontSize: 56, bold: true, color: C.primary, align: "center", margin: 0 });
  s.addText("hours/week\nlost to admin", { x: 7.2, y: 2.8, w: 2.5, h: 0.8, fontFace: FONT_BODY, fontSize: 14, color: C.muted, align: "center", margin: 0 });

  // Bottom stat
  s.addShape(pres.shapes.RECTANGLE, { x: 7.2, y: 4.05, w: 2.5, h: 1.2, fill: { color: C.surface }, shadow: cardShadow() });
  s.addText("5–7", { x: 7.2, y: 4.1, w: 2.5, h: 0.7, fontFace: FONT_TITLE, fontSize: 40, bold: true, color: C.warning, align: "center", margin: 0 });
  s.addText("different tools used", { x: 7.2, y: 4.7, w: 2.5, h: 0.4, fontFace: FONT_BODY, fontSize: 13, color: C.muted, align: "center", margin: 0 });
}

// ════════════════════════════════════════
// SLIDE 3 — THE VISION
// ════════════════════════════════════════
{
  const s = pres.addSlide();
  s.background = { color: C.bg };

  s.addText("Our Vision", { x: 0.8, y: 0.4, w: 8, h: 0.7, fontFace: FONT_TITLE, fontSize: 36, bold: true, color: C.primary, margin: 0 });

  s.addText("One beautiful app that replaces everything.", { x: 0.8, y: 1.15, w: 8, h: 0.5, fontFace: FONT_BODY, fontSize: 18, italic: true, color: C.text, margin: 0 });

  // Two pillars
  // Pillar 1
  s.addShape(pres.shapes.RECTANGLE, { x: 0.8, y: 1.9, w: 4.0, h: 2.4, fill: { color: C.surface }, shadow: cardShadow() });
  s.addShape(pres.shapes.RECTANGLE, { x: 0.8, y: 1.9, w: 4.0, h: 0.06, fill: { color: C.primary } });
  s.addText("Convenience", { x: 1.1, y: 2.15, w: 3.5, h: 0.5, fontFace: FONT_TITLE, fontSize: 22, bold: true, color: C.text, margin: 0 });
  s.addText([
    { text: "Every action a trainer or client needs is ", options: { color: C.muted } },
    { text: "two taps away", options: { color: C.primary, bold: true } },
    { text: ".", options: { color: C.muted } },
    { text: "\n\nPrograms, payments, scheduling, messaging, and progress — all in one place. No switching apps.", options: { color: C.muted, breakLine: true } },
  ], { x: 1.1, y: 2.65, w: 3.5, h: 1.5, fontFace: FONT_BODY, fontSize: 13, lineSpacingMultiple: 1.4, margin: 0 });

  // Pillar 2
  s.addShape(pres.shapes.RECTANGLE, { x: 5.2, y: 1.9, w: 4.0, h: 2.4, fill: { color: C.surface }, shadow: cardShadow() });
  s.addShape(pres.shapes.RECTANGLE, { x: 5.2, y: 1.9, w: 4.0, h: 0.06, fill: { color: C.accent } });
  s.addText("Design Quality", { x: 5.5, y: 2.15, w: 3.5, h: 0.5, fontFace: FONT_TITLE, fontSize: 22, bold: true, color: C.text, margin: 0 });
  s.addText([
    { text: "Feels like a ", options: { color: C.muted } },
    { text: "premium consumer app", options: { color: C.accent, bold: true } },
    { text: ", not a clunky SMB tool.", options: { color: C.muted } },
    { text: "\n\nTrainers are proud to show it to clients. Clients love using it more than their other fitness apps.", options: { color: C.muted, breakLine: true } },
  ], { x: 5.5, y: 2.65, w: 3.5, h: 1.5, fontFace: FONT_BODY, fontSize: 13, lineSpacingMultiple: 1.4, margin: 0 });

  // Bottom quote
  s.addText([
    { text: '"', options: { fontSize: 28, color: C.primary } },
    { text: "Become the default OS for the independent trainer — the way Square became the default for the independent merchant.", options: { fontSize: 14, italic: true, color: C.muted } },
    { text: '"', options: { fontSize: 28, color: C.primary } },
  ], { x: 0.8, y: 4.6, w: 8.4, h: 0.7, fontFace: FONT_BODY, align: "center", margin: 0 });
}

// ════════════════════════════════════════
// SLIDE 4 — WHAT WE'RE NOT
// ════════════════════════════════════════
{
  const s = pres.addSlide();
  s.background = { color: C.bg };

  s.addText("What FitHero is Not", { x: 0.8, y: 0.4, w: 8, h: 0.7, fontFace: FONT_TITLE, fontSize: 36, bold: true, color: C.primary, margin: 0 });
  s.addText("Focus means saying no. Here's what we deliberately leave out of MVP.", { x: 0.8, y: 1.1, w: 8, h: 0.5, fontFace: FONT_BODY, fontSize: 15, color: C.muted, margin: 0 });

  const nots = [
    "No AI features (form check, program generation, chatbot)",
    "No group classes or bootcamps",
    "No nutrition / meal planning",
    "No in-app video calls (use Zoom/Meet links)",
    "No marketplace or \"find a trainer\" directory",
    "No social feed, leaderboards, or public profiles",
    "No wearable integrations (Apple Health, Garmin)",
  ];

  nots.forEach((item, i) => {
    const y = 1.85 + i * 0.48;
    // Red X
    s.addText("✕", { x: 0.8, y: y, w: 0.4, h: 0.4, fontFace: FONT_BODY, fontSize: 14, bold: true, color: C.danger, align: "center", valign: "middle", margin: 0 });
    s.addText(item, { x: 1.3, y: y, w: 5.5, h: 0.4, fontFace: FONT_BODY, fontSize: 14, color: C.text, valign: "middle", margin: 0 });
  });

  // Right side callout
  s.addShape(pres.shapes.RECTANGLE, { x: 7.0, y: 1.8, w: 2.7, h: 3.5, fill: { color: C.surface }, shadow: cardShadow() });
  s.addText("Why?", { x: 7.0, y: 1.95, w: 2.7, h: 0.5, fontFace: FONT_TITLE, fontSize: 20, bold: true, color: C.primary, align: "center", margin: 0 });
  s.addText("These features are deferred to Phase 2 as paid add-ons.\n\nThe MVP core must be:\n", { x: 7.2, y: 2.45, w: 2.3, h: 1.0, fontFace: FONT_BODY, fontSize: 12, color: C.muted, margin: 0 });
  const whys = [
    { t: "Near-zero cost", c: C.success },
    { t: "Dead simple", c: C.accent },
    { t: "Ship fast", c: C.warning },
  ];
  whys.forEach((w, i) => {
    s.addShape(pres.shapes.OVAL, { x: 7.4, y: 3.5 + i * 0.45, w: 0.14, h: 0.14, fill: { color: w.c } });
    s.addText(w.t, { x: 7.7, y: 3.42 + i * 0.45, w: 2.0, h: 0.35, fontFace: FONT_BODY, fontSize: 13, bold: true, color: w.c, margin: 0 });
  });
}

// ════════════════════════════════════════
// SLIDE 5 — CLIENT EXPERIENCE: HOME + WORKOUT (screenshots)
// ════════════════════════════════════════
{
  const s = pres.addSlide();
  s.background = { color: C.bg };

  s.addText("The Client Experience", { x: 0.8, y: 0.3, w: 8, h: 0.7, fontFace: FONT_TITLE, fontSize: 36, bold: true, color: C.primary, margin: 0 });
  s.addText("What your clients see every day — clean, focused, two taps to start training.", { x: 0.8, y: 0.95, w: 8, h: 0.4, fontFace: FONT_BODY, fontSize: 14, color: C.muted, margin: 0 });

  // Phone 1 — Home
  s.addImage({ path: path.join(SHOTS, "01_home.png"), x: 1.2, y: 1.4, w: 2.6, h: 3.6, sizing: { type: "contain", w: 2.6, h: 3.6 } });
  s.addText("Home", { x: 1.2, y: 4.65, w: 2.6, h: 0.35, fontFace: FONT_TITLE, fontSize: 14, bold: true, color: C.text, align: "center", margin: 0 });
  s.addText("Today's workout, schedule,\nmessages — all at a glance", { x: 0.7, y: 4.95, w: 3.6, h: 0.55, fontFace: FONT_BODY, fontSize: 11, color: C.muted, align: "center", margin: 0 });

  // Phone 2 — Workout
  s.addImage({ path: path.join(SHOTS, "02_workout.png"), x: 4.2, y: 1.4, w: 2.6, h: 3.6, sizing: { type: "contain", w: 2.6, h: 3.6 } });
  s.addText("Active Workout", { x: 4.2, y: 4.65, w: 2.6, h: 0.35, fontFace: FONT_TITLE, fontSize: 14, bold: true, color: C.text, align: "center", margin: 0 });
  s.addText("Log sets, rest timer,\ncoach notes in real time", { x: 3.7, y: 4.95, w: 3.6, h: 0.55, fontFace: FONT_BODY, fontSize: 11, color: C.muted, align: "center", margin: 0 });

  // Phone 3 — Progress
  s.addImage({ path: path.join(SHOTS, "03_progress.png"), x: 7.2, y: 1.4, w: 2.6, h: 3.6, sizing: { type: "contain", w: 2.6, h: 3.6 } });
  s.addText("Progress", { x: 7.2, y: 4.65, w: 2.6, h: 0.35, fontFace: FONT_TITLE, fontSize: 14, bold: true, color: C.text, align: "center", margin: 0 });
  s.addText("Weight trends, PRs,\nbody measurements", { x: 6.7, y: 4.95, w: 3.6, h: 0.55, fontFace: FONT_BODY, fontSize: 11, color: C.muted, align: "center", margin: 0 });
}

// ════════════════════════════════════════
// SLIDE 6 — CLIENT EXPERIENCE: SCHEDULE + MESSAGES
// ════════════════════════════════════════
{
  const s = pres.addSlide();
  s.background = { color: C.bg };

  s.addText("Schedule & Communication", { x: 0.8, y: 0.3, w: 8, h: 0.7, fontFace: FONT_TITLE, fontSize: 36, bold: true, color: C.primary, margin: 0 });
  s.addText("Clients book sessions and message their trainer — no WhatsApp needed.", { x: 0.8, y: 0.95, w: 8, h: 0.4, fontFace: FONT_BODY, fontSize: 14, color: C.muted, margin: 0 });

  // Phone 4 — Schedule (centered left)
  s.addImage({ path: path.join(SHOTS, "04_schedule.png"), x: 1.8, y: 1.4, w: 2.6, h: 3.6, sizing: { type: "contain", w: 2.6, h: 3.6 } });
  s.addText("Schedule", { x: 1.8, y: 4.65, w: 2.6, h: 0.35, fontFace: FONT_TITLE, fontSize: 14, bold: true, color: C.text, align: "center", margin: 0 });
  s.addText("Upcoming sessions, reschedule\nrequests, calendar integration", { x: 1.3, y: 4.95, w: 3.6, h: 0.55, fontFace: FONT_BODY, fontSize: 11, color: C.muted, align: "center", margin: 0 });

  // Phone 5 — Messages (centered right)
  s.addImage({ path: path.join(SHOTS, "05_messages.png"), x: 5.8, y: 1.4, w: 2.6, h: 3.6, sizing: { type: "contain", w: 2.6, h: 3.6 } });
  s.addText("Messages", { x: 5.8, y: 4.65, w: 2.6, h: 0.35, fontFace: FONT_TITLE, fontSize: 14, bold: true, color: C.text, align: "center", margin: 0 });
  s.addText("1:1 chat with trainer,\npush notifications, images", { x: 5.3, y: 4.95, w: 3.6, h: 0.55, fontFace: FONT_BODY, fontSize: 11, color: C.muted, align: "center", margin: 0 });
}

// ════════════════════════════════════════
// SLIDE 7 — TRAINER SIDE
// ════════════════════════════════════════
{
  const s = pres.addSlide();
  s.background = { color: C.bg };

  s.addText("The Trainer Side", { x: 0.8, y: 0.4, w: 8, h: 0.7, fontFace: FONT_TITLE, fontSize: 36, bold: true, color: C.primary, margin: 0 });
  s.addText("Trainers get a web dashboard + mobile app to run their entire business.", { x: 0.8, y: 1.1, w: 8, h: 0.4, fontFace: FONT_BODY, fontSize: 15, color: C.muted, margin: 0 });

  // Feature cards 2x3 grid
  const features = [
    { title: "Client Management", desc: "Invite clients, track goals, intake forms, notes. See everything about each client in one profile.", color: C.accent },
    { title: "Program Builder", desc: "Drag-and-drop workout builder with 300+ exercises. Create once, assign to many. Templates save hours.", color: C.primary },
    { title: "Scheduling", desc: "Calendar view with 1:1 sessions. In-person, video, or check-in. Clients get notifications + calendar invites.", color: C.success },
    { title: "Payments", desc: "Send invoices, set up recurring subscriptions. Clients pay with saved card or Apple Pay. Auto-charge.", color: C.warning },
    { title: "Messaging", desc: "Built-in 1:1 chat. Push + email notifications. No more scattered WhatsApp threads.", color: C.accent },
    { title: "Dashboard", desc: "Today's sessions, revenue, pending payments, unread messages — all at a glance when you open the app.", color: C.primary },
  ];

  features.forEach((f, i) => {
    const col = i % 3;
    const row = Math.floor(i / 3);
    const x = 0.8 + col * 3.0;
    const y = 1.75 + row * 1.75;

    s.addShape(pres.shapes.RECTANGLE, { x, y, w: 2.75, h: 1.5, fill: { color: C.surface }, shadow: cardShadow() });
    s.addShape(pres.shapes.RECTANGLE, { x, y, w: 2.75, h: 0.05, fill: { color: f.color } });
    s.addText(f.title, { x: x + 0.2, y: y + 0.15, w: 2.35, h: 0.35, fontFace: FONT_TITLE, fontSize: 14, bold: true, color: C.text, margin: 0 });
    s.addText(f.desc, { x: x + 0.2, y: y + 0.5, w: 2.35, h: 0.9, fontFace: FONT_BODY, fontSize: 11, color: C.muted, lineSpacingMultiple: 1.3, margin: 0 });
  });
}

// ════════════════════════════════════════
// SLIDE 8 — BUSINESS MODEL
// ════════════════════════════════════════
{
  const s = pres.addSlide();
  s.background = { color: C.bg };

  s.addText("Business Model", { x: 0.8, y: 0.4, w: 8, h: 0.7, fontFace: FONT_TITLE, fontSize: 36, bold: true, color: C.primary, margin: 0 });
  s.addText("The trainer pays. The client never pays FitHero directly.", { x: 0.8, y: 1.05, w: 8, h: 0.4, fontFace: FONT_BODY, fontSize: 15, color: C.muted, margin: 0 });

  // Pricing tiers — 4 cards
  const tiers = [
    { name: "Solo", price: "Free", clients: "Up to 3", note: "Acquisition funnel", color: C.subtle },
    { name: "Starter", price: "$19/mo", clients: "Up to 15", note: "$1.27 per client", color: C.accent },
    { name: "Pro", price: "$39/mo", clients: "Up to 40", note: "$0.98 per client", color: C.primary },
    { name: "Studio", price: "$79/mo", clients: "Up to 100", note: "$0.79 per client", color: C.warning },
  ];

  tiers.forEach((t, i) => {
    const x = 0.8 + i * 2.25;
    const isPro = i === 2;
    s.addShape(pres.shapes.RECTANGLE, { x, y: 1.7, w: 2.05, h: 2.6, fill: { color: isPro ? C.surface2 : C.surface }, shadow: cardShadow() });
    s.addShape(pres.shapes.RECTANGLE, { x, y: 1.7, w: 2.05, h: 0.05, fill: { color: t.color } });
    if (isPro) {
      s.addShape(pres.shapes.RECTANGLE, { x: x + 0.4, y: 1.55, w: 1.25, h: 0.28, fill: { color: C.primary } });
      s.addText("RECOMMENDED", { x: x + 0.4, y: 1.55, w: 1.25, h: 0.28, fontFace: FONT_BODY, fontSize: 8, bold: true, color: C.primaryInk, align: "center", valign: "middle", margin: 0 });
    }
    s.addText(t.name, { x, y: 1.9, w: 2.05, h: 0.35, fontFace: FONT_TITLE, fontSize: 16, bold: true, color: C.text, align: "center", margin: 0 });
    s.addText(t.price, { x, y: 2.3, w: 2.05, h: 0.55, fontFace: FONT_TITLE, fontSize: 30, bold: true, color: t.color, align: "center", margin: 0 });
    s.addText(t.clients, { x, y: 2.9, w: 2.05, h: 0.35, fontFace: FONT_BODY, fontSize: 13, color: C.text, align: "center", margin: 0 });
    s.addText(t.note, { x, y: 3.25, w: 2.05, h: 0.35, fontFace: FONT_BODY, fontSize: 11, italic: true, color: C.muted, align: "center", margin: 0 });
  });

  // Additional revenue
  s.addText("Additional Revenue Streams", { x: 0.8, y: 4.55, w: 4, h: 0.35, fontFace: FONT_TITLE, fontSize: 16, bold: true, color: C.text, margin: 0 });

  const revenue = [
    { text: "1% platform fee on client-to-trainer payments (via Stripe Connect)", icon: C.success },
    { text: "Phase 2: AI add-ons, branded apps, nutrition, wearables, marketplace", icon: C.accent },
  ];
  revenue.forEach((r, i) => {
    s.addShape(pres.shapes.OVAL, { x: 0.95, y: 5.0 + i * 0.38, w: 0.12, h: 0.12, fill: { color: r.icon } });
    s.addText(r.text, { x: 1.2, y: 4.9 + i * 0.38, w: 7.5, h: 0.35, fontFace: FONT_BODY, fontSize: 12, color: C.muted, margin: 0 });
  });

  // "Active client" definition
  s.addShape(pres.shapes.RECTANGLE, { x: 5.8, y: 4.55, w: 3.9, h: 1.0, fill: { color: C.surface } });
  s.addText([
    { text: '"Active client"', options: { bold: true, color: C.primary, fontSize: 12 } },
    { text: " = logged in or had a workout assigned in the last 30 days. Inactive clients are free. This removes friction for trainers.", options: { color: C.muted, fontSize: 11 } },
  ], { x: 6.0, y: 4.6, w: 3.5, h: 0.9, fontFace: FONT_BODY, lineSpacingMultiple: 1.3, margin: 0 });
}

// ════════════════════════════════════════
// SLIDE 9 — MVP ROADMAP
// ════════════════════════════════════════
{
  const s = pres.addSlide();
  s.background = { color: C.bg };

  s.addText("MVP Scope", { x: 0.8, y: 0.4, w: 8, h: 0.7, fontFace: FONT_TITLE, fontSize: 36, bold: true, color: C.primary, margin: 0 });
  s.addText("Ship a focused product one trainer can use to fully manage 10–30 clients.", { x: 0.8, y: 1.05, w: 8, h: 0.4, fontFace: FONT_BODY, fontSize: 15, color: C.muted, margin: 0 });

  // Left column — Trainer
  s.addShape(pres.shapes.RECTANGLE, { x: 0.8, y: 1.7, w: 4.0, h: 3.6, fill: { color: C.surface }, shadow: cardShadow() });
  s.addShape(pres.shapes.RECTANGLE, { x: 0.8, y: 1.7, w: 4.0, h: 0.05, fill: { color: C.accent } });
  s.addText("Trainer (Web + Mobile)", { x: 1.0, y: 1.85, w: 3.6, h: 0.4, fontFace: FONT_TITLE, fontSize: 16, bold: true, color: C.accent, margin: 0 });

  const trainerFeats = [
    "Account setup + Stripe Connect onboarding",
    "Client invite & management",
    "Drag-and-drop program builder",
    "300+ exercise library",
    "Calendar scheduling (1:1 sessions)",
    "1:1 messaging with push notifications",
    "Invoicing + subscription billing",
    "Revenue dashboard",
  ];
  s.addText(trainerFeats.map((f, i) => ({
    text: f, options: { bullet: true, breakLine: i < trainerFeats.length - 1, color: C.text, fontSize: 12 }
  })), { x: 1.0, y: 2.3, w: 3.6, h: 2.8, fontFace: FONT_BODY, paraSpaceAfter: 4, margin: 0 });

  // Right column — Client
  s.addShape(pres.shapes.RECTANGLE, { x: 5.2, y: 1.7, w: 4.0, h: 3.6, fill: { color: C.surface }, shadow: cardShadow() });
  s.addShape(pres.shapes.RECTANGLE, { x: 5.2, y: 1.7, w: 4.0, h: 0.05, fill: { color: C.primary } });
  s.addText("Client (Mobile)", { x: 5.4, y: 1.85, w: 3.6, h: 0.4, fontFace: FONT_TITLE, fontSize: 16, bold: true, color: C.primary, margin: 0 });

  const clientFeats = [
    "Accept invite + intake form",
    "Today's workout with \"Start\" CTA",
    "Active workout logging (sets, reps, weight)",
    "Rest timer + coach notes",
    "Progress charts + personal records",
    "Session schedule + reschedule",
    "1:1 messaging with trainer",
    "Payment management + receipts",
  ];
  s.addText(clientFeats.map((f, i) => ({
    text: f, options: { bullet: true, breakLine: i < clientFeats.length - 1, color: C.text, fontSize: 12 }
  })), { x: 5.4, y: 2.3, w: 3.6, h: 2.8, fontFace: FONT_BODY, paraSpaceAfter: 4, margin: 0 });
}

// ════════════════════════════════════════
// SLIDE 10 — PHASE 2
// ════════════════════════════════════════
{
  const s = pres.addSlide();
  s.background = { color: C.bg };

  s.addText("Phase 2 — What Comes Next", { x: 0.8, y: 0.4, w: 8, h: 0.7, fontFace: FONT_TITLE, fontSize: 36, bold: true, color: C.primary, margin: 0 });
  s.addText("After product-market fit. Each feature is a revenue lever, not a freebie.", { x: 0.8, y: 1.05, w: 8, h: 0.4, fontFace: FONT_BODY, fontSize: 15, color: C.muted, margin: 0 });

  const phase2 = [
    { feature: "AI Program Generation", desc: "Auto-create periodized programs from goals + history", tag: "$10–20/mo add-on", tagColor: C.primary },
    { feature: "AI Form Check", desc: "Upload a video, get rep-by-rep feedback on technique", tag: "$10–20/mo add-on", tagColor: C.primary },
    { feature: "Nutrition Module", desc: "Meal logging, macro targets, food photos", tag: "Premium tier", tagColor: C.accent },
    { feature: "Wearable Sync", desc: "Apple Health, Garmin, Whoop — auto-import activity data", tag: "Premium tier", tagColor: C.accent },
    { feature: "Custom Branding", desc: "Trainer's logo, colors, and custom app icon for clients", tag: "$25/mo add-on", tagColor: C.warning },
    { feature: "Group Programs", desc: "One program for a cohort — bootcamps, challenges, classes", tag: "Studio plan", tagColor: C.success },
    { feature: "Template Marketplace", desc: "Trainers sell programs to other trainers. FitHero takes 15%", tag: "Revenue share", tagColor: C.danger },
    { feature: "Document Signing", desc: "PAR-Q forms, liability waivers — built-in, no DocuSign needed", tag: "Pro+ plan", tagColor: C.success },
  ];

  phase2.forEach((p, i) => {
    const y = 1.65 + i * 0.48;
    s.addShape(pres.shapes.OVAL, { x: 0.95, y: y + 0.12, w: 0.14, h: 0.14, fill: { color: p.tagColor } });
    s.addText(p.feature, { x: 1.3, y: y, w: 3.0, h: 0.4, fontFace: FONT_BODY, fontSize: 13, bold: true, color: C.text, margin: 0 });
    s.addText(p.desc, { x: 4.3, y: y, w: 3.5, h: 0.4, fontFace: FONT_BODY, fontSize: 12, color: C.muted, margin: 0 });
    s.addText(p.tag, { x: 7.9, y: y + 0.02, w: 1.5, h: 0.32, fontFace: FONT_BODY, fontSize: 9, bold: true, color: p.tagColor, align: "right", margin: 0 });
  });
}

// ════════════════════════════════════════
// SLIDE 11 — COMPETITIVE EDGE
// ════════════════════════════════════════
{
  const s = pres.addSlide();
  s.background = { color: C.bg };

  s.addText("Why We Win", { x: 0.8, y: 0.4, w: 8, h: 0.7, fontFace: FONT_TITLE, fontSize: 36, bold: true, color: C.primary, margin: 0 });
  s.addText("The market has tools, but none that trainers actually love using.", { x: 0.8, y: 1.05, w: 8, h: 0.4, fontFace: FONT_BODY, fontSize: 15, color: C.muted, margin: 0 });

  // Competitor table
  const header = [
    { text: "Product", options: { bold: true, color: C.primary, fontSize: 12, fill: { color: C.surface2 } } },
    { text: "Strength", options: { bold: true, color: C.primary, fontSize: 12, fill: { color: C.surface2 } } },
    { text: "Our Advantage", options: { bold: true, color: C.primary, fontSize: 12, fill: { color: C.surface2 } } },
  ];

  const compRows = [
    ["Trainerize", "Mature features", "Dated UI, complex, expensive at scale"],
    ["TrueCoach", "Serious coaches", "Limited payments, feels like 2018"],
    ["Everfit", "Free tier, AI push", "Cluttered, AI-first not coach-first"],
    ["PT Distinction", "Nutrition tools", "Steep learning curve, ugly client UX"],
    ["Spreadsheets\n+ WhatsApp", "Free, flexible", "The messy status quo we replace"],
  ];

  const tableData = [header, ...compRows.map(r => [
    { text: r[0], options: { color: C.text, fontSize: 11, fill: { color: C.surface } } },
    { text: r[1], options: { color: C.muted, fontSize: 11, fill: { color: C.surface } } },
    { text: r[2], options: { color: C.text, fontSize: 11, fill: { color: C.surface } } },
  ])];

  s.addTable(tableData, {
    x: 0.8, y: 1.65, w: 8.4, colW: [2.0, 2.5, 3.9],
    border: { pt: 0.5, color: C.border },
    fontFace: FONT_BODY,
    rowH: [0.4, 0.45, 0.45, 0.45, 0.45, 0.55],
  });

  // Our wedge callout
  s.addShape(pres.shapes.RECTANGLE, { x: 0.8, y: 4.35, w: 8.4, h: 0.9, fill: { color: C.surface }, shadow: cardShadow() });
  s.addShape(pres.shapes.RECTANGLE, { x: 0.8, y: 4.35, w: 0.06, h: 0.9, fill: { color: C.primary } });
  s.addText([
    { text: "Our wedge: ", options: { bold: true, color: C.primary, fontSize: 15 } },
    { text: "the prettiest, simplest product in the category — with native payment handling — priced for solo trainers.", options: { color: C.text, fontSize: 15 } },
  ], { x: 1.1, y: 4.35, w: 7.9, h: 0.9, fontFace: FONT_BODY, valign: "middle", margin: 0 });
}

// ════════════════════════════════════════
// SLIDE 12 — WHY YOU / WHAT WE PROPOSE
// ════════════════════════════════════════
{
  const s = pres.addSlide();
  s.background = { color: C.bg };

  s.addText("Why We Need You", { x: 0.8, y: 0.4, w: 8, h: 0.7, fontFace: FONT_TITLE, fontSize: 36, bold: true, color: C.primary, margin: 0 });
  s.addText("We have the product and engineering. You have the domain expertise.", { x: 0.8, y: 1.05, w: 8, h: 0.4, fontFace: FONT_BODY, fontSize: 15, color: C.muted, margin: 0 });

  // What we bring
  s.addShape(pres.shapes.RECTANGLE, { x: 0.8, y: 1.7, w: 4.0, h: 3.2, fill: { color: C.surface }, shadow: cardShadow() });
  s.addShape(pres.shapes.RECTANGLE, { x: 0.8, y: 1.7, w: 4.0, h: 0.05, fill: { color: C.primary } });
  s.addText("What We Bring", { x: 1.0, y: 1.9, w: 3.6, h: 0.4, fontFace: FONT_TITLE, fontSize: 16, bold: true, color: C.primary, margin: 0 });

  const weBring = [
    "Product vision and design",
    "Full engineering team",
    "Business model + go-to-market strategy",
    "Design system + working prototype",
    "Payment infrastructure (Stripe Connect)",
    "Commitment to ship MVP in 8–12 weeks",
  ];
  s.addText(weBring.map((f, i) => ({
    text: f, options: { bullet: true, breakLine: i < weBring.length - 1, color: C.text, fontSize: 12 }
  })), { x: 1.0, y: 2.35, w: 3.6, h: 2.4, fontFace: FONT_BODY, paraSpaceAfter: 4, margin: 0 });

  // What you bring
  s.addShape(pres.shapes.RECTANGLE, { x: 5.2, y: 1.7, w: 4.0, h: 3.2, fill: { color: C.surface }, shadow: cardShadow() });
  s.addShape(pres.shapes.RECTANGLE, { x: 5.2, y: 1.7, w: 4.0, h: 0.05, fill: { color: C.accent } });
  s.addText("What You Bring", { x: 5.4, y: 1.9, w: 3.6, h: 0.4, fontFace: FONT_TITLE, fontSize: 16, bold: true, color: C.accent, margin: 0 });

  const youBring = [
    "Real-world training experience",
    "Understanding of what trainers actually need",
    "Insight into client expectations and pain points",
    "Validation of features and pricing",
    "Beta testing with your own client base",
    "Network access to the trainer community",
  ];
  s.addText(youBring.map((f, i) => ({
    text: f, options: { bullet: true, breakLine: i < youBring.length - 1, color: C.text, fontSize: 12 }
  })), { x: 5.4, y: 2.35, w: 3.6, h: 2.4, fontFace: FONT_BODY, paraSpaceAfter: 4, margin: 0 });
}

// ════════════════════════════════════════
// SLIDE 13 — OPEN QUESTIONS
// ════════════════════════════════════════
{
  const s = pres.addSlide();
  s.background = { color: C.bg };

  s.addText("Questions for You", { x: 0.8, y: 0.4, w: 8, h: 0.7, fontFace: FONT_TITLE, fontSize: 36, bold: true, color: C.primary, margin: 0 });
  s.addText("We'd love your honest input on these before we finalize the MVP.", { x: 0.8, y: 1.05, w: 8, h: 0.4, fontFace: FONT_BODY, fontSize: 15, color: C.muted, margin: 0 });

  const questions = [
    { q: "Is the feature set right?", d: "Are we missing something critical that solo trainers can't live without? Is anything here unnecessary?" },
    { q: "Is the pricing fair?", d: "Would you pay $19–39/mo for this? Would your peers? What's the price sensitivity in this market?" },
    { q: "Programs vs. ad-hoc workouts?", d: "Do most trainers plan multi-week programs, or do they decide workouts day-by-day? How should the builder work?" },
    { q: "Payments — what's reality?", d: "How do you currently collect payments? Would built-in billing change your workflow for the better?" },
    { q: "Client adoption — what's the barrier?", d: "Would your clients actually download and use an app? What would make them resist?" },
    { q: "What would make you switch?", d: "If you're using something today, what would FitHero need to do to make you move?" },
  ];

  questions.forEach((q, i) => {
    const y = 1.65 + i * 0.63;
    s.addText(`${i + 1}`, { x: 0.8, y: y, w: 0.35, h: 0.35, fontFace: FONT_TITLE, fontSize: 14, bold: true, color: C.primaryInk, align: "center", valign: "middle", fill: { color: C.primary }, margin: 0 });
    s.addText(q.q, { x: 1.3, y: y - 0.02, w: 7.5, h: 0.3, fontFace: FONT_BODY, fontSize: 14, bold: true, color: C.text, margin: 0 });
    s.addText(q.d, { x: 1.3, y: y + 0.25, w: 7.5, h: 0.3, fontFace: FONT_BODY, fontSize: 11, color: C.muted, margin: 0 });
  });
}

// ════════════════════════════════════════
// SLIDE 14 — CLOSING
// ════════════════════════════════════════
{
  const s = pres.addSlide();
  s.background = { color: C.bg };

  // Decorative
  s.addShape(pres.shapes.RECTANGLE, { x: -0.5, y: 4.0, w: 4, h: 2.5, fill: { color: C.primary, transparency: 5 }, rotate: 8 });

  s.addText("Let's Build This Together", { x: 0.8, y: 1.4, w: 8.4, h: 0.9, fontFace: FONT_TITLE, fontSize: 42, bold: true, color: C.text, align: "center", margin: 0 });

  s.addText("FitHero is early-stage and intentionally so.\nYour expertise shapes what we build.", { x: 1.5, y: 2.5, w: 7, h: 0.8, fontFace: FONT_BODY, fontSize: 18, color: C.muted, align: "center", lineSpacingMultiple: 1.4, margin: 0 });

  // Contact (centered)
  s.addShape(pres.shapes.RECTANGLE, { x: 3.25, y: 3.5, w: 3.5, h: 1.1, fill: { color: C.surface }, shadow: cardShadow() });
  s.addText("Peter — Founder", { x: 3.25, y: 3.6, w: 3.5, h: 0.5, fontFace: FONT_TITLE, fontSize: 18, bold: true, color: C.primary, align: "center", margin: 0 });
  s.addText("Let's talk when you're ready.", { x: 3.25, y: 4.0, w: 3.5, h: 0.4, fontFace: FONT_BODY, fontSize: 14, color: C.muted, align: "center", margin: 0 });

  // Footer
  s.addText("FitHero  |  Confidential  |  April 2026", { x: 0.8, y: 5.1, w: 8.4, h: 0.3, fontFace: FONT_BODY, fontSize: 10, color: C.subtle, align: "center", margin: 0 });
}

// ════════════════════════════════════════
// WRITE FILE
// ════════════════════════════════════════
pres.writeFile({ fileName: OUT }).then(() => {
  console.log("Deck saved to:", OUT);
}).catch(err => {
  console.error("Error:", err);
});
