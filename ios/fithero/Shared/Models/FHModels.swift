import Foundation

// MARK: - Models

struct Exercise: Identifiable {
    let id = UUID()
    let name: String
    let category: String
    let targetSets: Int
    let targetReps: String
    let restSeconds: Int
    let notes: String?
    let sfSymbol: String
}

struct SetEntry: Identifiable {
    let id = UUID()
    let setNumber: Int
    let targetReps: Int
    let targetWeight: Double
    var actualReps: Int?
    var actualWeight: Double?
    var isCompleted: Bool
}

struct Workout: Identifiable {
    let id = UUID()
    let name: String
    let category: String
    let estimatedMinutes: Int
    let exercises: [Exercise]
}

struct TrainingSession: Identifiable {
    let id = UUID()
    let trainerName: String
    let type: SessionType
    let date: Date
    let durationMinutes: Int
    let location: String?

    enum SessionType: String {
        case inPerson = "In-person"
        case video = "Video call"
        case checkIn = "Check-in"

        var icon: String {
            switch self {
            case .inPerson: "figure.walk"
            case .video: "video.fill"
            case .checkIn: "checkmark.message.fill"
            }
        }

        var color: String {
            switch self {
            case .inPerson: "accent"
            case .video: "primary"
            case .checkIn: "success"
            }
        }
    }
}

struct ChatMessage: Identifiable {
    let id = UUID()
    let senderName: String
    let isFromTrainer: Bool
    let text: String
    let timestamp: Date
    var isImageAttachment: Bool = false
}

struct WeightEntry: Identifiable {
    let id = UUID()
    let date: Date
    let weight: Double
}

struct PersonalRecord: Identifiable {
    let id = UUID()
    let exerciseName: String
    let value: String
    let date: Date
    let sfSymbol: String
}

struct ProgressPhoto: Identifiable {
    let id = UUID()
    let date: Date
    let label: String
    let sfSymbol: String
    let colorName: String
}

// MARK: - Sample Data

enum SampleData {

    static let trainerName = "Maya"
    static let clientName = "Alex"
    static let trainerAvatar = "M"
    static let clientAvatar = "A"

    static let todayWorkout = Workout(
        name: "Upper Body Strength",
        category: "Push / Pull",
        estimatedMinutes: 45,
        exercises: [
            Exercise(name: "Barbell Bench Press", category: "Push", targetSets: 4, targetReps: "8-10", restSeconds: 90, notes: "Focus on controlled eccentric. Full ROM.", sfSymbol: "figure.strengthtraining.traditional"),
            Exercise(name: "Dumbbell Row", category: "Pull", targetSets: 4, targetReps: "10-12", restSeconds: 75, notes: "Keep core braced, squeeze at the top.", sfSymbol: "figure.rowing"),
            Exercise(name: "Overhead Press", category: "Push", targetSets: 3, targetReps: "8-10", restSeconds: 90, notes: nil, sfSymbol: "figure.highintensity.intervaltraining"),
            Exercise(name: "Cable Face Pull", category: "Pull", targetSets: 3, targetReps: "15", restSeconds: 60, notes: "External rotate at the top. Light weight.", sfSymbol: "figure.flexibility"),
            Exercise(name: "Tricep Dips", category: "Push", targetSets: 3, targetReps: "12-15", restSeconds: 60, notes: "Bodyweight only. Full lockout.", sfSymbol: "figure.cooldown"),
        ]
    )

    static let benchPressSets: [SetEntry] = [
        SetEntry(setNumber: 1, targetReps: 10, targetWeight: 80, actualReps: 10, actualWeight: 80, isCompleted: true),
        SetEntry(setNumber: 2, targetReps: 10, targetWeight: 80, actualReps: nil, actualWeight: nil, isCompleted: false),
        SetEntry(setNumber: 3, targetReps: 10, targetWeight: 80, actualReps: nil, actualWeight: nil, isCompleted: false),
        SetEntry(setNumber: 4, targetReps: 8, targetWeight: 85, actualReps: nil, actualWeight: nil, isCompleted: false),
    ]

    static var upcomingSessions: [TrainingSession] {
        let cal = Calendar.current
        let now = Date()
        return [
            TrainingSession(trainerName: "Maya", type: .inPerson, date: cal.date(byAdding: .day, value: 1, to: now)!, durationMinutes: 60, location: "FitStudio Downtown"),
            TrainingSession(trainerName: "Maya", type: .video, date: cal.date(byAdding: .day, value: 3, to: now)!, durationMinutes: 30, location: nil),
            TrainingSession(trainerName: "Maya", type: .checkIn, date: cal.date(byAdding: .day, value: 5, to: now)!, durationMinutes: 15, location: nil),
            TrainingSession(trainerName: "Maya", type: .inPerson, date: cal.date(byAdding: .day, value: 8, to: now)!, durationMinutes: 60, location: "FitStudio Downtown"),
        ]
    }

    static var messages: [ChatMessage] {
        let cal = Calendar.current
        let now = Date()
        return [
            ChatMessage(senderName: "Maya", isFromTrainer: true, text: "Great session yesterday! Your bench is really improving. Let's push the weight up next week.", timestamp: cal.date(byAdding: .hour, value: -2, to: now)!),
            ChatMessage(senderName: "Alex", isFromTrainer: false, text: "Thanks! Felt strong on the last set. Ready for more!", timestamp: cal.date(byAdding: .hour, value: -1, to: now)!),
            ChatMessage(senderName: "Maya", isFromTrainer: true, text: "Love the energy. I've updated your program for next week — check it out when you get a chance.", timestamp: cal.date(byAdding: .minute, value: -30, to: now)!),
            ChatMessage(senderName: "Alex", isFromTrainer: false, text: "Will do! Quick question — should I increase protein on rest days too?", timestamp: cal.date(byAdding: .minute, value: -15, to: now)!),
            ChatMessage(senderName: "Maya", isFromTrainer: true, text: "Yes, keep protein consistent every day. At least 1.6g/kg. We'll dial in nutrition more next month.", timestamp: cal.date(byAdding: .minute, value: -5, to: now)!),
        ]
    }

    static var weightHistory: [WeightEntry] {
        let cal = Calendar.current
        let now = Date()
        let weights: [(Int, Double)] = [
            (-56, 82.3), (-49, 82.0), (-42, 81.5), (-35, 81.2),
            (-28, 80.8), (-21, 80.3), (-14, 80.0), (-7, 79.8),
        ]
        return weights.map { dayOffset, weight in
            WeightEntry(date: cal.date(byAdding: .day, value: dayOffset, to: now)!, weight: weight)
        }
    }

    static var personalRecords: [PersonalRecord] {
        let cal = Calendar.current
        let now = Date()
        return [
            PersonalRecord(exerciseName: "Bench Press", value: "100 kg", date: cal.date(byAdding: .day, value: -3, to: now)!, sfSymbol: "figure.strengthtraining.traditional"),
            PersonalRecord(exerciseName: "Back Squat", value: "140 kg", date: cal.date(byAdding: .day, value: -10, to: now)!, sfSymbol: "figure.strengthtraining.functional"),
            PersonalRecord(exerciseName: "Deadlift", value: "180 kg", date: cal.date(byAdding: .day, value: -14, to: now)!, sfSymbol: "figure.highintensity.intervaltraining"),
            PersonalRecord(exerciseName: "Overhead Press", value: "65 kg", date: cal.date(byAdding: .day, value: -7, to: now)!, sfSymbol: "figure.arms.open"),
            PersonalRecord(exerciseName: "Pull-ups", value: "12 reps", date: cal.date(byAdding: .day, value: -5, to: now)!, sfSymbol: "figure.climbing"),
        ]
    }

    static let weekActivity: [Bool?] = [true, true, nil, true, nil, nil, false]
    // Mon=done, Tue=done, Wed=skipped, Thu=done, Fri=skipped, Sat=skipped, Sun=today(in progress)

    static let onboardingTrainer = TrainerInfo(name: "Maya", photoInitial: "M", inviteMessage: "I'd love to help you reach your fitness goals. Let's get started.")

    static var progressPhotos: [ProgressPhoto] {
        let cal = Calendar.current
        let now = Date()
        return [
            ProgressPhoto(date: cal.date(byAdding: .day, value: -56, to: now)!, label: "Week 1", sfSymbol: "figure.strengthtraining.traditional", colorName: "accent"),
            ProgressPhoto(date: cal.date(byAdding: .day, value: -42, to: now)!, label: "Week 3", sfSymbol: "figure.strengthtraining.functional", colorName: "primary"),
            ProgressPhoto(date: cal.date(byAdding: .day, value: -28, to: now)!, label: "Week 5", sfSymbol: "figure.highintensity.intervaltraining", colorName: "warning"),
            ProgressPhoto(date: cal.date(byAdding: .day, value: -14, to: now)!, label: "Week 7", sfSymbol: "figure.core.training", colorName: "success"),
        ]
    }
}

// MARK: - Onboarding Models

struct TrainerInfo {
    let name: String
    let photoInitial: String
    let inviteMessage: String
}

struct OnboardingData {
    var name: String = ""
    var age: String = ""
    var height: String = ""
    var weight: String = ""
    var goal: String = ""
    var injuries: [String] = []
    var injuryNotes: String = ""
    var experience: String = ""
    var measurements: BodyMeasurements = BodyMeasurements()
    var hasPhoto: Bool = false
}

struct BodyMeasurements {
    var chest: String = ""
    var waist: String = ""
    var hips: String = ""
    var leftArm: String = ""
    var rightArm: String = ""
    var leftThigh: String = ""
    var rightThigh: String = ""
}

// MARK: - Payment Models

struct PaymentMethod: Identifiable, Codable {
    var id = UUID()
    var brand: String // "Visa", "Mastercard", etc.
    var lastFour: String
    var expiryMonth: String
    var expiryYear: String
}

struct PaymentHistoryItem: Identifiable, Codable {
    var id = UUID()
    var date: Date
    var amount: String
    var status: PaymentStatus
    var description: String
    var receiptId: String?

    enum PaymentStatus: String, Codable {
        case paid = "Paid"
        case pending = "Pending"
        case failed = "Failed"
    }
}

struct SubscriptionPlan: Codable {
    var name: String
    var amount: String
    var billingInterval: String // "month", "year"
    var nextBillingDate: Date
    var status: String // "Active", "Paused", "Cancelled"
}

extension SampleData {
    static let exerciseLibrary: [Exercise] = [
        Exercise(name: "Barbell Bench Press", category: "Push", targetSets: 4, targetReps: "8-10", restSeconds: 90, notes: "Controlled eccentric, full ROM", sfSymbol: "figure.strengthtraining.traditional"),
        Exercise(name: "Dumbbell Row", category: "Pull", targetSets: 4, targetReps: "10-12", restSeconds: 75, notes: "Core braced, squeeze at top", sfSymbol: "figure.rowing"),
        Exercise(name: "Overhead Press", category: "Push", targetSets: 3, targetReps: "8-10", restSeconds: 90, notes: nil, sfSymbol: "figure.highintensity.intervaltraining"),
        Exercise(name: "Cable Face Pull", category: "Pull", targetSets: 3, targetReps: "15", restSeconds: 60, notes: "External rotate at top", sfSymbol: "figure.flexibility"),
        Exercise(name: "Tricep Dips", category: "Push", targetSets: 3, targetReps: "12-15", restSeconds: 60, notes: "Bodyweight only, full lockout", sfSymbol: "figure.cooldown"),
        Exercise(name: "Back Squat", category: "Legs", targetSets: 4, targetReps: "6-8", restSeconds: 120, notes: "Break parallel, drive through heels", sfSymbol: "figure.strengthtraining.functional"),
        Exercise(name: "Romanian Deadlift", category: "Legs", targetSets: 4, targetReps: "8-10", restSeconds: 90, notes: "Soft knee bend, hip hinge", sfSymbol: "figure.core.training"),
        Exercise(name: "Walking Lunge", category: "Legs", targetSets: 3, targetReps: "10/leg", restSeconds: 60, notes: "Upright torso, controlled step", sfSymbol: "figure.walk"),
        Exercise(name: "Plank", category: "Core", targetSets: 3, targetReps: "45-60s", restSeconds: 45, notes: "Brace abs, neutral spine", sfSymbol: "figure.core.training"),
        Exercise(name: "Dead Bug", category: "Core", targetSets: 3, targetReps: "8/side", restSeconds: 30, notes: "Low back pressed to floor", sfSymbol: "figure.mind.and.body"),
        Exercise(name: "Hip Flexor Stretch", category: "Mobility", targetSets: 2, targetReps: "30s", restSeconds: 0, notes: "Tall posture, tuck pelvis", sfSymbol: "figure.cooldown"),
        Exercise(name: "Thoracic Rotation", category: "Mobility", targetSets: 2, targetReps: "8/side", restSeconds: 0, notes: "Open chest, follow hand with eyes", sfSymbol: "figure.flexibility"),
        Exercise(name: "Treadmill Sprint", category: "Cardio", targetSets: 6, targetReps: "30s", restSeconds: 60, notes: "Max effort, full recovery", sfSymbol: "figure.run"),
        Exercise(name: "Rowing Machine", category: "Cardio", targetSets: 1, targetReps: "500m", restSeconds: 0, notes: "Legs-drive-core-pull pattern", sfSymbol: "figure.rowing"),
    ]

    static let workoutLibrary: [Workout] = [
        Workout(name: "Upper Body Strength", category: "Push / Pull", estimatedMinutes: 45, exercises: [
            exerciseLibrary[0], exerciseLibrary[1], exerciseLibrary[2], exerciseLibrary[3], exerciseLibrary[4]
        ]),
        Workout(name: "Leg Day A", category: "Legs", estimatedMinutes: 55, exercises: [
            exerciseLibrary[5], exerciseLibrary[6], exerciseLibrary[7], exerciseLibrary[8]
        ]),
        Workout(name: "Core & Mobility", category: "Core / Mobility", estimatedMinutes: 30, exercises: [
            exerciseLibrary[8], exerciseLibrary[9], exerciseLibrary[10], exerciseLibrary[11]
        ]),
        Workout(name: "HIIT Conditioning", category: "Cardio", estimatedMinutes: 25, exercises: [
            exerciseLibrary[12], exerciseLibrary[13]
        ]),
        Workout(name: "Full Body A", category: "Full Body", estimatedMinutes: 60, exercises: [
            exerciseLibrary[5], exerciseLibrary[0], exerciseLibrary[1], exerciseLibrary[6], exerciseLibrary[8]
        ]),
    ]
}
