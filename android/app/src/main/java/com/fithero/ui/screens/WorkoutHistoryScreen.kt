package com.fithero.ui.screens

import androidx.compose.foundation.background
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.foundation.verticalScroll
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.automirrored.filled.ArrowBack
import androidx.compose.material3.*
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp

// ------------------------------------------------------------------
// Models
// ------------------------------------------------------------------

private data class CompletedWorkout(
    val workoutName: String,
    val category: String,
    val dateLabel: String,
    val durationSeconds: Int,
    val exerciseCount: Int,
    val rpe: Int,
    val notes: String?
)

private val workoutHistory = listOf(
    CompletedWorkout("Upper Body Strength", "Push / Pull", "3 days ago", 2580, 5, 8, "Felt strong on bench. Pushed weight up on rows."),
    CompletedWorkout("Leg Day A", "Legs", "5 days ago", 3120, 4, 9, "Squats were tough. Needed extra rest between sets."),
    CompletedWorkout("Core & Mobility", "Core / Mobility", "7 days ago", 1740, 4, 6, null),
    CompletedWorkout("Upper Body Strength", "Push / Pull", "10 days ago", 2700, 5, 7, null),
    CompletedWorkout("Full Body A", "Full Body", "14 days ago", 3300, 5, 8, "Good overall session. Deadlifts felt smooth."),
    CompletedWorkout("HIIT Conditioning", "Cardio", "18 days ago", 1560, 2, 9, "Sprints were brutal. HR peaked at 185."),
    CompletedWorkout("Leg Day A", "Legs", "21 days ago", 3000, 4, 7, null),
    CompletedWorkout("Upper Body Strength", "Push / Pull", "24 days ago", 2640, 5, 7, null),
)

// ------------------------------------------------------------------
// Screen
// ------------------------------------------------------------------

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun WorkoutHistoryScreen(onDismiss: () -> Unit) {
    val bg = Color(0xFF0B0D10)
    val surface = Color(0xFF14181D)
    val voltGreen = Color(0xFFC6FF3D)

    Scaffold(
        topBar = {
            TopAppBar(
                title = { Text("Workout History", color = Color.White) },
                navigationIcon = {
                    IconButton(onClick = onDismiss) {
                        Icon(Icons.AutoMirrored.Filled.ArrowBack, "Back", tint = Color.White)
                    }
                },
                colors = TopAppBarDefaults.topAppBarColors(containerColor = bg)
            )
        },
        containerColor = bg
    ) { pad ->
        Column(
            modifier = Modifier
                .padding(pad)
                .verticalScroll(rememberScrollState())
                .padding(16.dp)
        ) {
            workoutHistory.forEach { w ->
                CompletedWorkoutCard(w, surface, voltGreen)
                Spacer(Modifier.height(12.dp))
            }
        }
    }
}

@Composable
private fun CompletedWorkoutCard(
    w: CompletedWorkout,
    surface: Color,
    voltGreen: Color
) {
    val minutes = w.durationSeconds / 60
    Surface(color = surface, shape = RoundedCornerShape(12.dp), modifier = Modifier.fillMaxWidth()) {
        Column(modifier = Modifier.padding(16.dp)) {
            Row(
                modifier = Modifier.fillMaxWidth(),
                horizontalArrangement = Arrangement.SpaceBetween
            ) {
                Column {
                    Text(w.workoutName, color = Color.White, fontSize = 16.sp, fontWeight = FontWeight.SemiBold)
                    Text(w.category, color = Color.Gray, fontSize = 12.sp)
                }
                Text(w.dateLabel, color = voltGreen, fontSize = 12.sp)
            }
            Spacer(Modifier.height(8.dp))
            Row(horizontalArrangement = Arrangement.spacedBy(16.dp)) {
                StatBadge("$minutes min")
                StatBadge("${w.exerciseCount} exercises")
                StatBadge("RPE ${w.rpe}")
            }
            w.notes?.let {
                Spacer(Modifier.height(8.dp))
                Text(it, color = Color.Gray, fontSize = 12.sp)
            }
        }
    }
}

@Composable
private fun StatBadge(text: String) {
    Surface(color = Color(0xFF1E2329), shape = RoundedCornerShape(6.dp)) {
        Text(text, color = Color.LightGray, fontSize = 12.sp, modifier = Modifier.padding(horizontal = 8.dp, vertical = 4.dp))
    }
}
