package com.fithero.ui.screens.trainer

import java.util.UUID

// ------------------------------------------------------------------
// Models (mirror iOS FHModels.swift)
// ------------------------------------------------------------------

data class Exercise(
    val id: String = UUID.randomUUID().toString(),
    val name: String,
    val category: String,
    val targetSets: Int,
    val targetReps: String,
    val restSeconds: Int,
    val notes: String? = null,
    val instructions: String? = null,
    val muscleGroups: List<String> = emptyList(),
    val equipment: String = "",
    val sfSymbol: String = "dumbbell.fill"
)

data class Workout(
    val id: String = UUID.randomUUID().toString(),
    val name: String,
    val category: String,
    val estimatedMinutes: Int,
    val exercises: List<Exercise> = emptyList()
)

// ------------------------------------------------------------------
// Sample data
// ------------------------------------------------------------------

val sampleExerciseLibrary: List<Exercise> = listOf(
    Exercise(name = "Barbell Bench Press", category = "Push", targetSets = 4, targetReps = "8-10", restSeconds = 90, notes = "Controlled eccentric, full ROM", instructions = "Lie flat on a bench with your eyes under the bar. Grip the bar with hands just wider than shoulder-width. Plant your feet firmly on the floor, arch your back slightly, and retract your shoulder blades. Unrack the bar and lower it to your mid-chest with control. Press the bar back up in a slight arc until your arms are locked out.", muscleGroups = listOf("Chest", "Triceps", "Front Delts"), equipment = "Barbell, Bench", sfSymbol = "dumbbell.fill"),
    Exercise(name = "Incline Dumbbell Press", category = "Push", targetSets = 3, targetReps = "10-12", restSeconds = 75, notes = "45° incline, control the negative", instructions = "Set bench to 45°. Hold dumbbells at shoulder height, palms facing forward. Press up and slightly inward until arms are extended. Lower with control.", muscleGroups = listOf("Upper Chest", "Front Delts"), equipment = "Dumbbells, Adjustable Bench", sfSymbol = "dumbbell.fill"),
    Exercise(name = "Overhead Press", category = "Push", targetSets = 3, targetReps = "8-10", restSeconds = 90, notes = "Brace core, don't arch back", instructions = "Stand with bar at upper chest, grip slightly wider than shoulders. Press bar straight up until arms are locked. Lower under control to upper chest.", muscleGroups = listOf("Shoulders", "Triceps"), equipment = "Barbell", sfSymbol = "dumbbell.fill"),
    Exercise(name = "Dumbbell Row", category = "Pull", targetSets = 4, targetReps = "10-12", restSeconds = 75, notes = "Pull to hip, squeeze at top", instructions = "Support upper body on bench with one hand and knee. Hold dumbbell in free hand, arm extended. Pull dumbbell to hip, squeezing lat at top. Lower with control.", muscleGroups = listOf("Lats", "Rhomboids", "Biceps"), equipment = "Dumbbell, Bench", sfSymbol = "dumbbell.fill"),
    Exercise(name = "Lat Pulldown", category = "Pull", targetSets = 3, targetReps = "10-12", restSeconds = 75, notes = "Lean back slightly, pull to upper chest", instructions = "Sit at lat pulldown machine, thighs secured. Grip bar wider than shoulders. Lean back slightly and pull bar to upper chest, squeezing shoulder blades together. Return with control.", muscleGroups = listOf("Lats", "Biceps", "Rear Delts"), equipment = "Cable Machine", sfSymbol = "dumbbell.fill"),
    Exercise(name = "Deadlift", category = "Pull", targetSets = 3, targetReps = "5-6", restSeconds = 150, notes = "Hinge at hips, keep bar close", instructions = "Stand with feet hip-width, bar over mid-foot. Grip bar just outside legs. Keep back flat, chest up. Push floor away, extending hips forward at top. Lower with control.", muscleGroups = listOf("Back", "Glutes", "Hamstrings"), equipment = "Barbell", sfSymbol = "dumbbell.fill"),
    Exercise(name = "Cable Face Pull", category = "Pull", targetSets = 3, targetReps = "15", restSeconds = 60, notes = "Pull to face height, external rotation", instructions = "Set cable at upper chest height. Grip rope with thumbs up. Pull towards face, externally rotating so thumbs point behind you. Squeeze rear delts.", muscleGroups = listOf("Rear Delts", "Rotator Cuff"), equipment = "Cable Machine", sfSymbol = "dumbbell.fill"),
    Exercise(name = "Back Squat", category = "Legs", targetSets = 4, targetReps = "6-8", restSeconds = 120, notes = "Break parallel, drive through heels", instructions = "Stand with feet shoulder-width apart, bar resting on your upper traps. Brace your core, keep your chest up, and squat down until your hip crease breaks the plane of your knee. Drive through your heels to stand back up.", muscleGroups = listOf("Quads", "Glutes", "Hamstrings", "Core"), equipment = "Barbell, Squat Rack", sfSymbol = "dumbbell.fill"),
    Exercise(name = "Romanian Deadlift", category = "Legs", targetSets = 3, targetReps = "10", restSeconds = 90, notes = "Soft knee bend, feel hamstring stretch", instructions = "Hold bar at hip level with pronated grip. Soft knee bend. Hinge at hips, pushing butt back while keeping bar close to legs. Lower until you feel hamstring stretch. Drive hips forward to stand.", muscleGroups = listOf("Hamstrings", "Glutes", "Lower Back"), equipment = "Barbell", sfSymbol = "dumbbell.fill"),
    Exercise(name = "Leg Press", category = "Legs", targetSets = 3, targetReps = "12", restSeconds = 90, notes = "Full ROM, don't lock knees", instructions = "Sit in leg press machine, feet shoulder-width on platform. Lower platform until knees are at 90°. Press through heels to extend legs without locking knees.", muscleGroups = listOf("Quads", "Glutes"), equipment = "Leg Press Machine", sfSymbol = "dumbbell.fill"),
    Exercise(name = "Plank", category = "Core", targetSets = 3, targetReps = "45s", restSeconds = 60, notes = "Body in straight line, brace core", instructions = "Support body on forearms and toes. Keep body in a straight line from head to heels. Brace core and hold position. Breathe normally.", muscleGroups = listOf("Core", "Shoulders"), equipment = "None", sfSymbol = "dumbbell.fill"),
    Exercise(name = "Hanging Leg Raise", category = "Core", targetSets = 3, targetReps = "12", restSeconds = 60, notes = "Control the swing, lift to 90°", instructions = "Hang from pull-up bar. Keeping legs straight, raise them to 90°. Lower with control. Minimize swinging.", muscleGroups = listOf("Abs", "Hip Flexors"), equipment = "Pull-up Bar", sfSymbol = "dumbbell.fill"),
    Exercise(name = "Treadmill Sprint", category = "Cardio", targetSets = 6, targetReps = "30s", restSeconds = 60, notes = "Max effort, full recovery between sets", instructions = "Set treadmill to high speed (10-12 mph). Sprint at max effort for 30 seconds. Step off for full recovery. Repeat.", muscleGroups = listOf("Full Body"), equipment = "Treadmill", sfSymbol = "dumbbell.fill"),
    Exercise(name = "Rowing Machine", category = "Cardio", targetSets = 1, targetReps = "500m", restSeconds = 120, notes = "Legs first, then back, then arms", instructions = "Sit on rower, feet secured. Start with legs bent, arms extended. Drive with legs, lean back slightly, pull handle to lower ribs. Reverse the sequence to return.", muscleGroups = listOf("Full Body"), equipment = "Rowing Machine", sfSymbol = "dumbbell.fill"),
    Exercise(name = "Hip Flexor Stretch", category = "Mobility", targetSets = 2, targetReps = "30s", restSeconds = 0, notes = "Sink hips forward, keep torso upright", instructions = "Kneel on one knee, other foot forward. Push hips forward until you feel stretch in front of hip. Keep torso upright. Hold.", muscleGroups = listOf("Hip Flexors"), equipment = "None", sfSymbol = "dumbbell.fill"),
    Exercise(name = "Thoracic Rotation", category = "Mobility", targetSets = 2, targetReps = "10/side", restSeconds = 0, notes = "Rotate through full range", instructions = "On all fours, one hand behind head. Rotate upper body, bringing elbow towards opposite arm, then rotate open, pointing elbow to ceiling.", muscleGroups = listOf("Thoracic Spine"), equipment = "None", sfSymbol = "dumbbell.fill")
)

val sampleWorkoutLibrary: List<Workout> = listOf(
    Workout(
        name = "Upper Body Strength",
        category = "Push / Pull",
        estimatedMinutes = 45,
        exercises = listOf(
            sampleExerciseLibrary[0], // Bench Press
            sampleExerciseLibrary[3], // DB Row
            sampleExerciseLibrary[2], // OHP
            sampleExerciseLibrary[6], // Face Pull
            sampleExerciseLibrary[1]  // Incline DB Press
        )
    ),
    Workout(
        name = "Lower Body Power",
        category = "Legs",
        estimatedMinutes = 55,
        exercises = listOf(
            sampleExerciseLibrary[7],  // Squat
            sampleExerciseLibrary[4],  // Lat Pulldown
            sampleExerciseLibrary[8],  // RDL
            sampleExerciseLibrary[9],  // Leg Press
            sampleExerciseLibrary[10], // Plank
            sampleExerciseLibrary[11]  // Leg Raise
        )
    ),
    Workout(
        name = "Full Body HIIT",
        category = "Full Body",
        estimatedMinutes = 35,
        exercises = listOf(
            sampleExerciseLibrary[7],  // Squat
            sampleExerciseLibrary[0],  // Bench Press
            sampleExerciseLibrary[5],  // Deadlift
            sampleExerciseLibrary[12], // Treadmill Sprint
            sampleExerciseLibrary[13], // Rowing
            sampleExerciseLibrary[10], // Plank
            sampleExerciseLibrary[2],  // OHP
            sampleExerciseLibrary[3]   // DB Row
        )
    ),
    Workout(
        name = "Push Day",
        category = "Push",
        estimatedMinutes = 50,
        exercises = listOf(
            sampleExerciseLibrary[0], // Bench Press
            sampleExerciseLibrary[2], // OHP
            sampleExerciseLibrary[1], // Incline DB Press
            sampleExerciseLibrary[6], // Face Pull
            sampleExerciseLibrary[11], // Leg Raise
            sampleExerciseLibrary[12]  // Treadmill Sprint
        )
    ),
    Workout(
        name = "Pull Day",
        category = "Pull",
        estimatedMinutes = 45,
        exercises = listOf(
            sampleExerciseLibrary[5], // Deadlift
            sampleExerciseLibrary[3], // DB Row
            sampleExerciseLibrary[4], // Lat Pulldown
            sampleExerciseLibrary[6], // Face Pull
            sampleExerciseLibrary[8]  // RDL
        )
    )
)
