package com.fithero.ui.screens

import androidx.compose.foundation.background
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.foundation.verticalScroll
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.automirrored.filled.ArrowBack
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.Brush
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp

// ------------------------------------------------------------------
// Models
// ------------------------------------------------------------------

private data class HistorySetEntry(
    val setNumber: Int,
    val targetReps: Int,
    val targetWeight: Double,
    val actualReps: Int,
    val actualWeight: Double,
    val isCompleted: Boolean
)

private data class ExerciseHistoryEntry(
    val dateLabel: String,
    val workoutName: String,
    val sets: List<HistorySetEntry>
)

private data class ExerciseDetail(
    val name: String,
    val category: String,
    val instructions: String,
    val muscleGroups: List<String>,
    val equipment: String,
    val targetSets: Int,
    val targetReps: String,
    val restSeconds: Int,
    val notes: String?
)

// ------------------------------------------------------------------
// Sample data helpers
// ------------------------------------------------------------------

private fun detailFor(name: String): ExerciseDetail = when (name) {
    "Barbell Bench Press" -> ExerciseDetail(
        name = name, category = "Push", targetSets = 4, targetReps = "8-10", restSeconds = 90,
        notes = "Controlled eccentric, full ROM",
        instructions = "Lie flat on a bench with your eyes under the bar. Grip the bar with hands just wider than shoulder-width. Plant your feet firmly on the floor, arch your back slightly, and retract your shoulder blades. Unrack the bar and lower it to your mid-chest with control. Press the bar back up in a slight arc until your arms are locked out.",
        muscleGroups = listOf("Chest", "Triceps", "Front Delts"), equipment = "Barbell, Bench"
    )
    "Back Squat" -> ExerciseDetail(
        name = name, category = "Legs", targetSets = 4, targetReps = "6-8", restSeconds = 120,
        notes = "Break parallel, drive through heels",
        instructions = "Stand with feet shoulder-width apart, bar resting on your upper traps. Brace your core, keep your chest up, and squat down until your hip crease breaks the plane of your knee. Drive through your heels to stand back up.",
        muscleGroups = listOf("Quads", "Glutes", "Hamstrings", "Core"), equipment = "Barbell, Squat Rack"
    )
    else -> ExerciseDetail(
        name = name, category = "Strength", targetSets = 3, targetReps = "10", restSeconds = 60,
        notes = null, instructions = "Perform with controlled form and full range of motion.",
        muscleGroups = listOf("Muscle Group 1", "Muscle Group 2"), equipment = "Dumbbells"
    )
}

private fun historyFor(name: String): List<ExerciseHistoryEntry> = when (name) {
    "Barbell Bench Press" -> listOf(
        ExerciseHistoryEntry("3 days ago", "Upper Body Strength", listOf(
            HistorySetEntry(1, 10, 80.0, 10, 80.0, true), HistorySetEntry(2, 10, 80.0, 10, 82.5, true),
            HistorySetEntry(3, 8, 85.0, 8, 85.0, true), HistorySetEntry(4, 8, 85.0, 7, 85.0, true)
        )),
        ExerciseHistoryEntry("10 days ago", "Upper Body Strength", listOf(
            HistorySetEntry(1, 10, 80.0, 10, 80.0, true), HistorySetEntry(2, 10, 80.0, 10, 80.0, true),
            HistorySetEntry(3, 8, 82.5, 8, 82.5, true), HistorySetEntry(4, 8, 82.5, 8, 82.5, true)
        )),
        ExerciseHistoryEntry("17 days ago", "Full Body A", listOf(
            HistorySetEntry(1, 10, 75.0, 10, 75.0, true), HistorySetEntry(2, 10, 75.0, 10, 77.5, true),
            HistorySetEntry(3, 8, 80.0, 8, 80.0, true)
        ))
    )
    "Back Squat" -> listOf(
        ExerciseHistoryEntry("5 days ago", "Leg Day A", listOf(
            HistorySetEntry(1, 6, 135.0, 6, 135.0, true), HistorySetEntry(2, 6, 135.0, 6, 140.0, true),
            HistorySetEntry(3, 6, 140.0, 5, 140.0, true), HistorySetEntry(4, 6, 140.0, 5, 140.0, true)
        )),
        ExerciseHistoryEntry("12 days ago", "Leg Day A", listOf(
            HistorySetEntry(1, 6, 130.0, 6, 130.0, true), HistorySetEntry(2, 6, 130.0, 6, 130.0, true),
            HistorySetEntry(3, 6, 135.0, 6, 135.0, true), HistorySetEntry(4, 6, 135.0, 5, 135.0, true)
        ))
    )
    else -> emptyList()
}

// ------------------------------------------------------------------
// Screen
// ------------------------------------------------------------------

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun ExerciseDetailScreen(
    exerciseName: String,
    onDismiss: () -> Unit
) {
    val detail = remember { detailFor(exerciseName) }
    val history = remember { historyFor(exerciseName) }
    var selectedTab by remember { mutableIntStateOf(0) }
    val tabs = listOf("Overview", "History")
    val voltGreen = Color(0xFFC6FF3D)
    val bg = Color(0xFF0B0D10)
    val surface = Color(0xFF14181D)

    Scaffold(
        topBar = {
            TopAppBar(
                title = { Text("Exercise Detail", color = Color.White) },
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
        Column(modifier = Modifier.padding(pad)) {
            TabRow(
                selectedTabIndex = selectedTab,
                containerColor = bg,
                contentColor = voltGreen
            ) {
                tabs.forEachIndexed { i, t ->
                    Tab(
                        selected = selectedTab == i,
                        onClick = { selectedTab = i },
                        text = {
                            Text(t, color = if (selectedTab == i) voltGreen else Color.Gray)
                        }
                    )
                }
            }
            when (selectedTab) {
                0 -> OverviewTab(detail, bg, surface, voltGreen)
                1 -> HistoryTab(history, bg, surface, voltGreen)
            }
        }
    }
}

@Composable
private fun OverviewTab(
    detail: ExerciseDetail,
    bg: Color,
    surface: Color,
    voltGreen: Color
) {
    Column(
        modifier = Modifier
            .fillMaxSize()
            .verticalScroll(rememberScrollState())
            .padding(16.dp)
    ) {
        Text(detail.name, color = Color.White, fontSize = 24.sp, fontWeight = FontWeight.Bold)
        Spacer(Modifier.height(4.dp))
        Text("${detail.category}  ·  ${detail.targetSets} sets  ·  ${detail.targetReps} reps  ·  ${detail.restSeconds}s rest",
            color = Color.Gray, fontSize = 14.sp)
        Spacer(Modifier.height(16.dp))

        Text("Instructions", color = Color.White, fontSize = 16.sp, fontWeight = FontWeight.SemiBold)
        Spacer(Modifier.height(8.dp))
        Text(detail.instructions, color = Color.LightGray, fontSize = 14.sp, lineHeight = 20.sp)
        Spacer(Modifier.height(16.dp))

        Text("Muscle Groups", color = Color.White, fontSize = 16.sp, fontWeight = FontWeight.SemiBold)
        Spacer(Modifier.height(8.dp))
        Row(horizontalArrangement = Arrangement.spacedBy(8.dp)) {
            detail.muscleGroups.forEach { m ->
                Surface(color = surface, shape = RoundedCornerShape(8.dp)) {
                    Text(m, color = voltGreen, fontSize = 12.sp, modifier = Modifier.padding(horizontal = 12.dp, vertical = 6.dp))
                }
            }
        }
        Spacer(Modifier.height(16.dp))

        Text("Equipment", color = Color.White, fontSize = 16.sp, fontWeight = FontWeight.SemiBold)
        Spacer(Modifier.height(8.dp))
        Surface(color = surface, shape = RoundedCornerShape(8.dp), modifier = Modifier.fillMaxWidth()) {
            Text(detail.equipment, color = Color.LightGray, fontSize = 14.sp, modifier = Modifier.padding(12.dp))
        }

        detail.notes?.let {
            Spacer(Modifier.height(16.dp))
            Text("Notes", color = Color.White, fontSize = 16.sp, fontWeight = FontWeight.SemiBold)
            Spacer(Modifier.height(8.dp))
            Surface(color = surface, shape = RoundedCornerShape(8.dp), modifier = Modifier.fillMaxWidth()) {
                Text(it, color = Color.LightGray, fontSize = 14.sp, modifier = Modifier.padding(12.dp))
            }
        }
    }
}

@Composable
private fun HistoryTab(
    history: List<ExerciseHistoryEntry>,
    bg: Color,
    surface: Color,
    voltGreen: Color
) {
    Column(
        modifier = Modifier
            .fillMaxSize()
            .verticalScroll(rememberScrollState())
            .padding(16.dp)
    ) {
        if (history.isEmpty()) {
            Box(modifier = Modifier.fillMaxSize(), contentAlignment = Alignment.Center) {
                Text("No history yet", color = Color.Gray)
            }
            return
        }
        history.forEach { entry ->
            Surface(color = surface, shape = RoundedCornerShape(12.dp), modifier = Modifier.fillMaxWidth()) {
                Column(modifier = Modifier.padding(12.dp)) {
                    Text(entry.dateLabel, color = voltGreen, fontSize = 14.sp, fontWeight = FontWeight.SemiBold)
                    Text(entry.workoutName, color = Color.Gray, fontSize = 12.sp)
                    Spacer(Modifier.height(8.dp))
                    entry.sets.forEach { set ->
                        Row(
                            modifier = Modifier.fillMaxWidth(),
                            horizontalArrangement = Arrangement.SpaceBetween
                        ) {
                            Text("Set ${set.setNumber}", color = Color.LightGray, fontSize = 13.sp)
                            Text("${set.actualReps} reps @ ${set.actualWeight}kg", color = Color.White, fontSize = 13.sp)
                        }
                    }
                }
            }
            Spacer(Modifier.height(12.dp))
        }
    }
}
