import Foundation

// MARK: - Models

struct Exercise: Identifiable {
    let id = UUID()
    let name: String
    let category: String
    let targetSets: Int
    let targetReps: String
    let restSeconds: Int
    let notes: String?          // Short trainer cue
    let instructions: String?   // Full how-to description
    let muscleGroups: [String]
    let equipment: String
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

struct ExerciseHistoryEntry: Identifiable {
    let id = UUID()
    let date: Date
    let workoutName: String
    let sets: [SetEntry]
    
    var maxWeight: Double {
        sets.compactMap { $0.actualWeight }.max() ?? 0
    }
    
    var totalVolume: Double {
        sets.reduce(0) { $0 + (Double($1.actualReps ?? 0) * ($1.actualWeight ?? 0)) }
    }
}

struct CompletedWorkout: Identifiable {
    let id = UUID()
    let workoutName: String
    let category: String
    let date: Date
    let durationSeconds: Int
    let exerciseCount: Int
    let rpe: Int?
    let notes: String?
    
    var durationFormatted: String {
        let m = durationSeconds / 60
        let s = durationSeconds % 60
        return s > 0 ? "\(m)m \(s)s" : "\(m) min"
    }
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
    var imageData: Data? = nil
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
            Exercise(name: "Barbell Bench Press", category: "Push", targetSets: 4, targetReps: "8-10", restSeconds: 90, notes: "Focus on controlled eccentric. Full ROM.", instructions: "Lie flat on a bench with your eyes under the bar. Grip the bar with hands just wider than shoulder-width. Plant your feet firmly on the floor, arch your back slightly, and retract your shoulder blades. Unrack the bar and lower it to your mid-chest with control. Press the bar back up in a slight arc until your arms are locked out.", muscleGroups: ["Chest", "Triceps", "Front Delts"], equipment: "Barbell, Bench", sfSymbol: "figure.strengthtraining.traditional"),
            Exercise(name: "Dumbbell Row", category: "Pull", targetSets: 4, targetReps: "10-12", restSeconds: 75, notes: "Keep core braced, squeeze at the top.", instructions: "Place one knee and hand on a bench for support. Hold a dumbbell in the opposite hand with a neutral grip. Pull the dumbbell up toward your hip, keeping your elbow close to your body. Squeeze your lat at the top, then lower with control.", muscleGroups: ["Lats", "Rhomboids", "Biceps"], equipment: "Dumbbell, Bench", sfSymbol: "figure.rowing"),
            Exercise(name: "Overhead Press", category: "Push", targetSets: 3, targetReps: "8-10", restSeconds: 90, notes: nil, instructions: "Stand with feet shoulder-width apart. Hold the bar at shoulder height with palms facing forward. Brace your core and press the bar straight up until your arms are fully extended. Lower the bar back to the starting position with control.", muscleGroups: ["Shoulders", "Triceps", "Core"], equipment: "Barbell", sfSymbol: "figure.highintensity.intervaltraining"),
            Exercise(name: "Cable Face Pull", category: "Pull", targetSets: 3, targetReps: "15", restSeconds: 60, notes: "External rotate at the top. Light weight.", instructions: "Set a cable pulley at upper chest height. Attach a rope handle. Pull the rope toward your face, separating your hands as you pull. Externally rotate your shoulders so your knuckles face the ceiling at the end. Control the return.", muscleGroups: ["Rear Delts", "Rotator Cuff", "Upper Back"], equipment: "Cable Machine, Rope", sfSymbol: "figure.flexibility"),
            Exercise(name: "Tricep Dips", category: "Push", targetSets: 3, targetReps: "12-15", restSeconds: 60, notes: "Bodyweight only. Full lockout.", instructions: "Sit on the edge of a bench or chair. Place your hands next to your hips with fingers forward. Slide your hips off the bench and lower your body by bending your elbows to about 90 degrees. Press back up to full lockout.", muscleGroups: ["Triceps", "Chest", "Front Delts"], equipment: "Bodyweight, Bench", sfSymbol: "figure.cooldown"),
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
        Exercise(name: "Barbell Bench Press", category: "Push", targetSets: 4, targetReps: "8-10", restSeconds: 90, notes: "Controlled eccentric, full ROM", instructions: "Lie flat on a bench with your eyes under the bar. Grip the bar with hands just wider than shoulder-width. Plant your feet firmly on the floor, arch your back slightly, and retract your shoulder blades. Unrack the bar and lower it to your mid-chest with control. Press the bar back up in a slight arc until your arms are locked out.", muscleGroups: ["Chest", "Triceps", "Front Delts"], equipment: "Barbell, Bench", sfSymbol: "figure.strengthtraining.traditional"),
        Exercise(name: "Dumbbell Row", category: "Pull", targetSets: 4, targetReps: "10-12", restSeconds: 75, notes: "Core braced, squeeze at top", instructions: "Place one knee and hand on a bench for support. Hold a dumbbell in the opposite hand with a neutral grip. Pull the dumbbell up toward your hip, keeping your elbow close to your body. Squeeze your lat at the top, then lower with control.", muscleGroups: ["Lats", "Rhomboids", "Biceps"], equipment: "Dumbbell, Bench", sfSymbol: "figure.rowing"),
        Exercise(name: "Overhead Press", category: "Push", targetSets: 3, targetReps: "8-10", restSeconds: 90, notes: nil, instructions: "Stand with feet shoulder-width apart. Hold the bar at shoulder height with palms facing forward. Brace your core and press the bar straight up until your arms are fully extended. Lower the bar back to the starting position with control.", muscleGroups: ["Shoulders", "Triceps", "Core"], equipment: "Barbell", sfSymbol: "figure.highintensity.intervaltraining"),
        Exercise(name: "Cable Face Pull", category: "Pull", targetSets: 3, targetReps: "15", restSeconds: 60, notes: "External rotate at top", instructions: "Set a cable pulley at upper chest height. Attach a rope handle. Pull the rope toward your face, separating your hands as you pull. Externally rotate your shoulders so your knuckles face the ceiling at the end. Control the return.", muscleGroups: ["Rear Delts", "Rotator Cuff", "Upper Back"], equipment: "Cable Machine, Rope", sfSymbol: "figure.flexibility"),
        Exercise(name: "Tricep Dips", category: "Push", targetSets: 3, targetReps: "12-15", restSeconds: 60, notes: "Bodyweight only, full lockout", instructions: "Sit on the edge of a bench or chair. Place your hands next to your hips with fingers forward. Slide your hips off the bench and lower your body by bending your elbows to about 90 degrees. Press back up to full lockout.", muscleGroups: ["Triceps", "Chest", "Front Delts"], equipment: "Bodyweight, Bench", sfSymbol: "figure.cooldown"),
        Exercise(name: "Back Squat", category: "Legs", targetSets: 4, targetReps: "6-8", restSeconds: 120, notes: "Break parallel, drive through heels", instructions: "Stand with feet shoulder-width apart, bar resting on your upper traps. Brace your core, keep your chest up, and squat down until your hip crease breaks the plane of your knee. Drive through your heels to stand back up.", muscleGroups: ["Quads", "Glutes", "Hamstrings", "Core"], equipment: "Barbell, Squat Rack", sfSymbol: "figure.strengthtraining.functional"),
        Exercise(name: "Romanian Deadlift", category: "Legs", targetSets: 4, targetReps: "8-10", restSeconds: 90, notes: "Soft knee bend, hip hinge", instructions: "Stand holding a barbell with an overhand grip. Keep a slight bend in your knees and push your hips back while lowering the bar along your thighs. Feel a stretch in your hamstrings, then drive your hips forward to return to standing.", muscleGroups: ["Hamstrings", "Glutes", "Lower Back"], equipment: "Barbell", sfSymbol: "figure.core.training"),
        Exercise(name: "Walking Lunge", category: "Legs", targetSets: 3, targetReps: "10/leg", restSeconds: 60, notes: "Upright torso, controlled step", instructions: "Hold dumbbells at your sides. Step forward into a lunge, lowering your back knee toward the floor. Keep your torso upright. Push through your front foot to step forward into the next lunge. Alternate legs.", muscleGroups: ["Quads", "Glutes", "Hamstrings"], equipment: "Dumbbells", sfSymbol: "figure.walk"),
        Exercise(name: "Plank", category: "Core", targetSets: 3, targetReps: "45-60s", restSeconds: 45, notes: "Brace abs, neutral spine", instructions: "Support your body on your forearms and toes. Keep your body in a straight line from head to heels. Brace your abs and glutes. Hold the position without letting your hips sag or rise.", muscleGroups: ["Abs", "Obliques", "Lower Back"], equipment: "Bodyweight", sfSymbol: "figure.core.training"),
        Exercise(name: "Dead Bug", category: "Core", targetSets: 3, targetReps: "8/side", restSeconds: 30, notes: "Low back pressed to floor", instructions: "Lie on your back with arms extended toward the ceiling and knees bent at 90 degrees. Slowly lower one arm behind you and the opposite leg toward the floor while keeping your lower back pressed into the ground. Return to start and repeat on the other side.", muscleGroups: ["Abs", "Hip Flexors"], equipment: "Bodyweight", sfSymbol: "figure.mind.and.body"),
        Exercise(name: "Hip Flexor Stretch", category: "Mobility", targetSets: 2, targetReps: "30s", restSeconds: 0, notes: "Tall posture, tuck pelvis", instructions: "Kneel on one knee with the other foot forward in a lunge position. Tuck your pelvis under and gently push your hips forward until you feel a stretch in the front of your hip. Hold and breathe.", muscleGroups: ["Hip Flexors"], equipment: "Bodyweight", sfSymbol: "figure.cooldown"),
        Exercise(name: "Thoracic Rotation", category: "Mobility", targetSets: 2, targetReps: "8/side", restSeconds: 0, notes: "Open chest, follow hand with eyes", instructions: "Start on all fours. Place one hand behind your head. Rotate your upper body, bringing that elbow toward the opposite arm, then rotate open pointing the elbow to the ceiling. Follow your elbow with your eyes.", muscleGroups: ["Thoracic Spine", "Obliques"], equipment: "Bodyweight", sfSymbol: "figure.flexibility"),
        Exercise(name: "Treadmill Sprint", category: "Cardio", targetSets: 6, targetReps: "30s", restSeconds: 60, notes: "Max effort, full recovery", instructions: "Warm up thoroughly. Set the treadmill to a challenging speed or use manual mode. Sprint at maximum effort for the prescribed time. Step off to the sides for recovery. Repeat for all sets.", muscleGroups: ["Legs", "Core", "Cardiovascular"], equipment: "Treadmill", sfSymbol: "figure.run"),
        Exercise(name: "Rowing Machine", category: "Cardio", targetSets: 1, targetReps: "500m", restSeconds: 0, notes: "Legs-drive-core-pull pattern", instructions: "Sit on the rower and strap your feet in. Grab the handle with an overhand grip. Drive through your legs first, then lean back slightly and pull the handle to your lower ribs. Reverse the sequence on the return. Maintain a steady rhythm.", muscleGroups: ["Back", "Legs", "Core", "Cardiovascular"], equipment: "Rowing Machine", sfSymbol: "figure.rowing"),
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

    // MARK: - Exercise History

    static func exerciseHistory(for exerciseName: String) -> [ExerciseHistoryEntry] {
        let cal = Calendar.current
        let now = Date()
        switch exerciseName {
        case "Barbell Bench Press":
            return [
                ExerciseHistoryEntry(date: cal.date(byAdding: .day, value: -3, to: now)!, workoutName: "Upper Body Strength", sets: [
                    SetEntry(setNumber: 1, targetReps: 10, targetWeight: 80, actualReps: 10, actualWeight: 80, isCompleted: true),
                    SetEntry(setNumber: 2, targetReps: 10, targetWeight: 80, actualReps: 10, actualWeight: 82.5, isCompleted: true),
                    SetEntry(setNumber: 3, targetReps: 8, targetWeight: 85, actualReps: 8, actualWeight: 85, isCompleted: true),
                    SetEntry(setNumber: 4, targetReps: 8, targetWeight: 85, actualReps: 7, actualWeight: 85, isCompleted: true),
                ]),
                ExerciseHistoryEntry(date: cal.date(byAdding: .day, value: -10, to: now)!, workoutName: "Upper Body Strength", sets: [
                    SetEntry(setNumber: 1, targetReps: 10, targetWeight: 80, actualReps: 10, actualWeight: 80, isCompleted: true),
                    SetEntry(setNumber: 2, targetReps: 10, targetWeight: 80, actualReps: 10, actualWeight: 80, isCompleted: true),
                    SetEntry(setNumber: 3, targetReps: 8, targetWeight: 82.5, actualReps: 8, actualWeight: 82.5, isCompleted: true),
                    SetEntry(setNumber: 4, targetReps: 8, targetWeight: 82.5, actualReps: 8, actualWeight: 82.5, isCompleted: true),
                ]),
                ExerciseHistoryEntry(date: cal.date(byAdding: .day, value: -17, to: now)!, workoutName: "Full Body A", sets: [
                    SetEntry(setNumber: 1, targetReps: 10, targetWeight: 75, actualReps: 10, actualWeight: 75, isCompleted: true),
                    SetEntry(setNumber: 2, targetReps: 10, targetWeight: 75, actualReps: 10, actualWeight: 77.5, isCompleted: true),
                    SetEntry(setNumber: 3, targetReps: 8, targetWeight: 80, actualReps: 8, actualWeight: 80, isCompleted: true),
                ]),
            ]
        case "Back Squat":
            return [
                ExerciseHistoryEntry(date: cal.date(byAdding: .day, value: -5, to: now)!, workoutName: "Leg Day A", sets: [
                    SetEntry(setNumber: 1, targetReps: 6, targetWeight: 135, actualReps: 6, actualWeight: 135, isCompleted: true),
                    SetEntry(setNumber: 2, targetReps: 6, targetWeight: 135, actualReps: 6, actualWeight: 140, isCompleted: true),
                    SetEntry(setNumber: 3, targetReps: 6, targetWeight: 140, actualReps: 5, actualWeight: 140, isCompleted: true),
                    SetEntry(setNumber: 4, targetReps: 6, targetWeight: 140, actualReps: 5, actualWeight: 140, isCompleted: true),
                ]),
                ExerciseHistoryEntry(date: cal.date(byAdding: .day, value: -12, to: now)!, workoutName: "Leg Day A", sets: [
                    SetEntry(setNumber: 1, targetReps: 6, targetWeight: 130, actualReps: 6, actualWeight: 130, isCompleted: true),
                    SetEntry(setNumber: 2, targetReps: 6, targetWeight: 130, actualReps: 6, actualWeight: 130, isCompleted: true),
                    SetEntry(setNumber: 3, targetReps: 6, targetWeight: 135, actualReps: 6, actualWeight: 135, isCompleted: true),
                    SetEntry(setNumber: 4, targetReps: 6, targetWeight: 135, actualReps: 5, actualWeight: 135, isCompleted: true),
                ]),
            ]
        default:
            return []
        }
    }

    // MARK: - Completed Workout History

    static var completedWorkouts: [CompletedWorkout] {
        let cal = Calendar.current
        let now = Date()
        return [
            CompletedWorkout(workoutName: "Upper Body Strength", category: "Push / Pull", date: cal.date(byAdding: .day, value: -3, to: now)!, durationSeconds: 2580, exerciseCount: 5, rpe: 8, notes: "Felt strong on bench. Pushed weight up on rows."),
            CompletedWorkout(workoutName: "Leg Day A", category: "Legs", date: cal.date(byAdding: .day, value: -5, to: now)!, durationSeconds: 3120, exerciseCount: 4, rpe: 9, notes: "Squats were tough. Needed extra rest between sets."),
            CompletedWorkout(workoutName: "Core & Mobility", category: "Core / Mobility", date: cal.date(byAdding: .day, value: -7, to: now)!, durationSeconds: 1740, exerciseCount: 4, rpe: 6, notes: nil),
            CompletedWorkout(workoutName: "Upper Body Strength", category: "Push / Pull", date: cal.date(byAdding: .day, value: -10, to: now)!, durationSeconds: 2700, exerciseCount: 5, rpe: 7, notes: nil),
            CompletedWorkout(workoutName: "Full Body A", category: "Full Body", date: cal.date(byAdding: .day, value: -14, to: now)!, durationSeconds: 3300, exerciseCount: 5, rpe: 8, notes: "Good overall session. Deadlifts felt smooth."),
            CompletedWorkout(workoutName: "HIIT Conditioning", category: "Cardio", date: cal.date(byAdding: .day, value: -18, to: now)!, durationSeconds: 1560, exerciseCount: 2, rpe: 9, notes: "Sprints were brutal. HR peaked at 185."),
            CompletedWorkout(workoutName: "Leg Day A", category: "Legs", date: cal.date(byAdding: .day, value: -21, to: now)!, durationSeconds: 3000, exerciseCount: 4, rpe: 7, notes: nil),
            CompletedWorkout(workoutName: "Upper Body Strength", category: "Push / Pull", date: cal.date(byAdding: .day, value: -24, to: now)!, durationSeconds: 2640, exerciseCount: 5, rpe: 7, notes: nil),
        ]
    }
}
