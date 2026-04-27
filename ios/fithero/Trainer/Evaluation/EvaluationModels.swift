import Foundation

// MARK: - Data model

struct EvalTest: Identifiable, Equatable {
    let id: String
    let name: String
    let metric: String
    let target: String?
    let tool: String
    var done: Bool = false
    var value: String? = nil
}

struct EvalCategory: Identifiable {
    let id: String
    let name: String
    let short: String
    var tests: [EvalTest]

    var doneCount: Int { tests.filter(\.done).count }
    var progress: Double {
        guard !tests.isEmpty else { return 0 }
        return Double(doneCount) / Double(tests.count)
    }
}

struct EvalClient {
    let name: String
    let age: Int
    let sex: String
    let height: String
    let weight: String
    let goal: String
    let date: String
    let session: String
    let initials: String

    var firstName: String { name.components(separatedBy: " ").first ?? name }
}

// MARK: - Sample data

extension EvalCategory {
    static let samples: [EvalCategory] = [
        EvalCategory(id: "mobility", name: "Mobility", short: "MOB", tests: [
            EvalTest(id: "m1", name: "Shoulder flexion",      metric: "°",           target: "170–180°", tool: "Goniometer",            done: true,  value: "168°"),
            EvalTest(id: "m2", name: "Shoulder IR/ER",        metric: "°",           target: "70/90°",   tool: "Goniometer",            done: true,  value: "62 / 85°"),
            EvalTest(id: "m3", name: "Hip flexion",           metric: "°",           target: "120°+",    tool: "Supine",                done: true,  value: "115°"),
            EvalTest(id: "m4", name: "Ankle dorsiflexion",    metric: "cm",          target: ">10 cm",   tool: "Knee-to-wall"),
            EvalTest(id: "m5", name: "Thoracic rotation",     metric: "°",           target: "45°+",     tool: "Seated"),
        ]),
        EvalCategory(id: "posture", name: "Posture", short: "POS", tests: [
            EvalTest(id: "p1", name: "Static posture (A/P)", metric: "notes", target: nil,      tool: "Plumb line + photo", done: true, value: "Mild APT"),
            EvalTest(id: "p2", name: "Lateral view",         metric: "notes", target: nil,      tool: "Photo",              done: true, value: "Forward head"),
            EvalTest(id: "p3", name: "Pelvic tilt",          metric: "°",     target: "8–12°", tool: "Inclinometer"),
        ]),
        EvalCategory(id: "movement", name: "Movement screen", short: "MVT", tests: [
            EvalTest(id: "mv1", name: "Overhead squat",          metric: "score /3", target: "3", tool: "Video, front+side"),
            EvalTest(id: "mv2", name: "Single-leg squat (L/R)",  metric: "score /3", target: "3", tool: "Video"),
            EvalTest(id: "mv3", name: "Forward lunge",           metric: "score /3", target: nil, tool: "Video"),
            EvalTest(id: "mv4", name: "Push-up form",            metric: "score /3", target: nil, tool: "Video, side"),
        ]),
        EvalCategory(id: "strength", name: "Strength baseline", short: "STR", tests: [
            EvalTest(id: "s1", name: "Grip strength (L/R)",  metric: "kg",       target: "≥40 / 42", tool: "Dynamometer"),
            EvalTest(id: "s2", name: "Push-up (max reps)",   metric: "reps",     target: "≥20",      tool: "AMRAP"),
            EvalTest(id: "s3", name: "Plank (max hold)",     metric: "s",        target: "≥60s",     tool: "Stopwatch"),
            EvalTest(id: "s4", name: "Bodyweight squat",     metric: "reps/60s", target: nil,        tool: "60s AMRAP"),
        ]),
        EvalCategory(id: "cardio", name: "Cardio", short: "CAR", tests: [
            EvalTest(id: "c1", name: "Resting HR",      metric: "bpm",         target: "60–80",   tool: "HR strap, seated 5 min"),
            EvalTest(id: "c2", name: "Blood pressure",  metric: "mmHg",        target: "<130/85", tool: "Cuff"),
            EvalTest(id: "c3", name: "3-min step test", metric: "recovery HR", target: nil,       tool: "30cm step, 96 bpm"),
        ]),
        EvalCategory(id: "composition", name: "Body composition", short: "BC", tests: [
            EvalTest(id: "b1", name: "Weight",          metric: "kg",   target: nil, tool: "Scale"),
            EvalTest(id: "b2", name: "Height",          metric: "cm",   target: nil, tool: "Stadiometer"),
            EvalTest(id: "b3", name: "Girths (6-site)", metric: "cm",   target: nil, tool: "Tape"),
            EvalTest(id: "b4", name: "Skinfolds / BIA", metric: "% BF", target: nil, tool: "Caliper or BIA"),
        ]),
        EvalCategory(id: "flex", name: "Flexibility", short: "FLX", tests: [
            EvalTest(id: "f1", name: "Sit & reach",            metric: "cm",       target: ">5 cm", tool: "Box"),
            EvalTest(id: "f2", name: "Shoulder reach (back)",  metric: "cm",       target: nil,     tool: "Behind-back"),
            EvalTest(id: "f3", name: "Thomas test",            metric: "pass/fail", target: nil,    tool: "Supine edge"),
        ]),
        EvalCategory(id: "history", name: "Pain & medical history", short: "HIS", tests: [
            EvalTest(id: "h1", name: "Current pain sites", metric: "notes",      target: nil, tool: "Body map"),
            EvalTest(id: "h2", name: "Injury history",     metric: "notes",      target: nil, tool: "Interview"),
            EvalTest(id: "h3", name: "PAR-Q clearance",    metric: "pass/refer", target: nil, tool: "Form"),
            EvalTest(id: "h4", name: "Medications",        metric: "notes",      target: nil, tool: "Interview"),
        ]),
        EvalCategory(id: "goals", name: "Goals & lifestyle", short: "GLS", tests: [
            EvalTest(id: "g1", name: "Primary goal",           metric: "text",  target: nil, tool: "Interview"),
            EvalTest(id: "g2", name: "Training history",       metric: "text",  target: nil, tool: "Interview"),
            EvalTest(id: "g3", name: "Sleep / stress / diet",  metric: "notes", target: nil, tool: "Questionnaire"),
            EvalTest(id: "g4", name: "Availability",           metric: "d/wk",  target: nil, tool: "Interview"),
        ]),
    ]
}

extension EvalClient {
    static let sample = EvalClient(
        name: "Marco Rossi",
        age: 34,
        sex: "M",
        height: "182 cm",
        weight: "84 kg",
        goal: "Return to 5-a-side + lose 6 kg",
        date: "Apr 17 · 10:30",
        session: "Initial evaluation · 60 min",
        initials: "MR"
    )
}
