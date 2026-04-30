package com.fithero.ui.screens

import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableIntStateOf
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Modifier

// ---------- Data ----------

internal data class ExerciseItem(
    val id: Int,
    val name: String,
    val sfSymbol: String,
    val targetSets: Int,
    val targetReps: String,
    val restSeconds: Int
)

internal data class WorkoutData(
    val name: String,
    val category: String,
    val estimatedMinutes: Int,
    val exercises: List<ExerciseItem>
)

internal val todayWorkoutData = WorkoutData(
    name = "Upper Body Strength",
    category = "Push / Pull",
    estimatedMinutes = 45,
    exercises = listOf(
        ExerciseItem(0, "Barbell Bench Press", "dumbbell", 4, "8-10", 90),
        ExerciseItem(1, "Dumbbell Row", "figure.rower", 4, "10-12", 75),
        ExerciseItem(2, "Overhead Press", "figure.strengthtraining.traditional", 3, "8-10", 90),
        ExerciseItem(3, "Cable Face Pull", "figure.mind.and.body", 3, "15", 60),
        ExerciseItem(4, "Tricep Dips", "figure.arms.open", 3, "12-15", 60)
    )
)

// ---------- Flow Controller ----------

@Composable
fun WorkoutScreen(modifier: Modifier = Modifier) {
    var phase by remember { mutableStateOf<WorkoutPhase>(WorkoutPhase.Read) }
    var completedExercises by remember { mutableStateOf<Set<Int>>(emptySet()) }
    var totalElapsed by remember { mutableIntStateOf(0) }
    var showExerciseDetail by remember { mutableStateOf<String?>(null) }

    Box(modifier = modifier.fillMaxSize()) {
        when (phase) {
            is WorkoutPhase.Read -> WorkoutReadScreen(
                modifier = modifier,
                workout = todayWorkoutData,
                completedExercises = completedExercises,
                onSelectExercise = { index ->
                    phase = WorkoutPhase.Active(index)
                },
                onDismiss = { /* tab dismiss handled by nav */ },
                onExerciseDetail = { showExerciseDetail = it }
            )
            is WorkoutPhase.Active -> {
                val index = (phase as WorkoutPhase.Active).exerciseIndex
                ActiveWorkoutScreen(
                    modifier = modifier,
                    workout = todayWorkoutData,
                    startingExerciseIndex = index,
                    onExerciseDone = { elapsed ->
                        totalElapsed += elapsed
                        completedExercises = completedExercises + index
                        phase = if (completedExercises.size == todayWorkoutData.exercises.size) {
                            WorkoutPhase.Summary(totalElapsed)
                        } else {
                            WorkoutPhase.Read
                        }
                    },
                    onAbandon = { phase = WorkoutPhase.Read }
                )
            }
            is WorkoutPhase.Summary -> {
                val elapsed = (phase as WorkoutPhase.Summary).durationSeconds
                WorkoutSummaryScreen(
                    modifier = modifier,
                    workout = todayWorkoutData,
                    durationSeconds = elapsed,
                    onDone = {
                        completedExercises = emptySet()
                        totalElapsed = 0
                        phase = WorkoutPhase.Read
                    }
                )
            }
        }

        showExerciseDetail?.let { name ->
            ExerciseDetailScreen(exerciseName = name, onDismiss = { showExerciseDetail = null })
        }
    }
}

private sealed class WorkoutPhase {
    data object Read : WorkoutPhase()
    data class Active(val exerciseIndex: Int) : WorkoutPhase()
    data class Summary(val durationSeconds: Int) : WorkoutPhase()
}
