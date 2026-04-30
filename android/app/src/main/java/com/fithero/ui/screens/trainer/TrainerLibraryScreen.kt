package com.fithero.ui.screens.trainer

import androidx.compose.animation.Crossfade
import androidx.compose.foundation.background
import androidx.compose.foundation.border
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.foundation.horizontalScroll
import androidx.compose.foundation.text.BasicTextField
import androidx.compose.foundation.verticalScroll
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.automirrored.filled.ArrowBack
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.fithero.ui.screens.ExerciseDetailScreen
import com.fithero.ui.theme.Bg
import com.fithero.ui.theme.Border
import com.fithero.ui.theme.Danger
import com.fithero.ui.theme.Primary
import com.fithero.ui.theme.PrimaryInk
import com.fithero.ui.theme.Surface
import com.fithero.ui.theme.Surface2
import com.fithero.ui.theme.Text
import com.fithero.ui.theme.TextMuted
import com.fithero.ui.theme.TextSubtle

private val exerciseCategories = listOf("All", "Push", "Pull", "Legs", "Core", "Mobility", "Cardio")

@Composable
fun TrainerLibraryScreen(modifier: Modifier = Modifier) {
    var selectedTab by remember { mutableIntStateOf(0) }

    // Navigation state
    var showWorkoutDetail by remember { mutableStateOf<Workout?>(null) }
    var showExerciseDetail by remember { mutableStateOf<Exercise?>(null) }
    var showEditWorkout by remember { mutableStateOf<Workout?>(null) }
    var showNewWorkout by remember { mutableStateOf(false) }
    var showNewExercise by remember { mutableStateOf(false) }

    // Mutable workout list
    var workouts by remember { mutableStateOf(sampleWorkoutLibrary.toMutableList()) }

    Box(modifier = modifier.fillMaxSize()) {
        Column(
            modifier = Modifier
                .fillMaxSize()
                .background(Bg)
        ) {
            // Header
            Text("Library", fontSize = 28.sp, fontWeight = FontWeight.Bold, color = Text, modifier = Modifier.padding(16.dp))

            // Segmented control
            Row(
                modifier = Modifier
                    .fillMaxWidth()
                    .padding(horizontal = 16.dp)
                    .clip(RoundedCornerShape(12.dp))
                    .background(Surface)
                    .padding(4.dp),
                horizontalArrangement = Arrangement.spacedBy(4.dp)
            ) {
                listOf("Exercises", "Workouts").forEachIndexed { index, title ->
                    val selected = selectedTab == index
                    Box(
                        modifier = Modifier
                            .weight(1f)
                            .clip(RoundedCornerShape(10.dp))
                            .background(if (selected) Primary else Color.Transparent)
                            .clickable { selectedTab = index }
                            .padding(vertical = 10.dp),
                        contentAlignment = Alignment.Center
                    ) {
                        Text(
                            title,
                            fontSize = 14.sp,
                            fontWeight = if (selected) FontWeight.SemiBold else FontWeight.Medium,
                            color = if (selected) PrimaryInk else TextMuted
                        )
                    }
                }
            }

            Spacer(modifier = Modifier.height(16.dp))

            Crossfade(targetState = selectedTab, label = "library_tab") { tab ->
                when (tab) {
                    0 -> ExercisesTab(
                        onSelectExercise = { showExerciseDetail = it }
                    )
                    1 -> WorkoutsTab(
                        workouts = workouts,
                        onSelectWorkout = { showWorkoutDetail = it },
                        onSelectExercise = { showExerciseDetail = it },
                        onEditWorkout = { showEditWorkout = it },
                        onDuplicateWorkout = { workout ->
                            val copy = workout.copy(
                                id = java.util.UUID.randomUUID().toString(),
                                name = "${workout.name} Copy"
                            )
                            workouts = (workouts + copy).toMutableList()
                        },
                        onDeleteWorkout = { workout ->
                            workouts = workouts.filter { it.id != workout.id }.toMutableList()
                        }
                    )
                }
            }
        }

        // FAB
        val fabOnClick = when (selectedTab) {
            0 -> { { showNewExercise = true } }
            else -> { { showNewWorkout = true } }
        }

        Box(
            modifier = Modifier
                .fillMaxSize()
                .padding(16.dp),
            contentAlignment = Alignment.BottomEnd
        ) {
            Box(
                modifier = Modifier
                    .size(56.dp)
                    .clip(CircleShape)
                    .background(Primary)
                    .clickable { fabOnClick() },
                contentAlignment = Alignment.Center
            ) {
                Text("➕", fontSize = 20.sp, fontWeight = FontWeight.SemiBold, color = PrimaryInk)
            }
        }
    }

    // Overlays
    showExerciseDetail?.let { exercise ->
        ExerciseDetailScreen(exerciseName = exercise.name, onDismiss = { showExerciseDetail = null })
    }

    showWorkoutDetail?.let { workout ->
        WorkoutDetailScreen(
            workout = workout,
            onDismiss = { showWorkoutDetail = null },
            onSelectExercise = { showExerciseDetail = it }
        )
    }

    showEditWorkout?.let { workout ->
        EditWorkoutSheet(
            workout = workout,
            onSave = { updated ->
                val idx = workouts.indexOfFirst { it.id == updated.id }
                if (idx >= 0) {
                    workouts = workouts.toMutableList().apply { set(idx, updated) }
                }
                showEditWorkout = null
            },
            onDismiss = { showEditWorkout = null },
            onPreviewExercise = { showExerciseDetail = it }
        )
    }

    if (showNewWorkout) {
        NewWorkoutSheet(
            onCreate = { workout ->
                workouts = (workouts + workout).toMutableList()
                showNewWorkout = false
            },
            onDismiss = { showNewWorkout = false }
        )
    }

    if (showNewExercise) {
        NewExerciseSheet(
            onCreate = { /* Could add to library */ showNewExercise = false },
            onDismiss = { showNewExercise = false }
        )
    }
}

// ------------------------------------------------------------------
// Exercises Tab
// ------------------------------------------------------------------

@Composable
private fun ExercisesTab(
    onSelectExercise: (Exercise) -> Unit
) {
    var searchText by remember { mutableStateOf("") }
    var selectedCategory by remember { mutableStateOf("All") }

    val filtered = remember(searchText, selectedCategory) {
        var result = sampleExerciseLibrary
        if (selectedCategory != "All") {
            result = result.filter { it.category == selectedCategory }
        }
        if (searchText.isNotBlank()) {
            result = result.filter { it.name.contains(searchText, ignoreCase = true) }
        }
        result
    }

    Column(
        modifier = Modifier
            .fillMaxSize()
            .verticalScroll(rememberScrollState())
            .padding(horizontal = 16.dp)
            .padding(bottom = 80.dp)
    ) {
        // Search
        Row(
            modifier = Modifier
                .fillMaxWidth()
                .clip(RoundedCornerShape(24.dp))
                .background(Surface)
                .border(1.dp, Border, RoundedCornerShape(24.dp))
                .padding(horizontal = 16.dp, vertical = 10.dp),
            verticalAlignment = Alignment.CenterVertically,
            horizontalArrangement = Arrangement.spacedBy(8.dp)
        ) {
            Text("🔍", fontSize = 14.sp)
            BasicTextField(
                value = searchText,
                onValueChange = { searchText = it },
                modifier = Modifier.weight(1f),
                textStyle = androidx.compose.ui.text.TextStyle(fontSize = 15.sp, color = Text),
                decorationBox = { innerTextField ->
                    if (searchText.isEmpty()) {
                        Text("Search exercises", fontSize = 15.sp, color = TextSubtle)
                    }
                    innerTextField()
                }
            )
            if (searchText.isNotEmpty()) {
                Text("✕", fontSize = 16.sp, color = TextSubtle, modifier = Modifier.clickable { searchText = "" })
            }
        }

        Spacer(modifier = Modifier.height(16.dp))

        // Category pills
        Row(modifier = Modifier.horizontalScroll(rememberScrollState()), horizontalArrangement = Arrangement.spacedBy(8.dp)) {
            exerciseCategories.forEach { cat ->
                val selected = selectedCategory == cat
                Box(
                    modifier = Modifier
                        .clip(RoundedCornerShape(16.dp))
                        .background(if (selected) Primary else Surface2)
                        .border(1.dp, if (selected) Primary else Border, RoundedCornerShape(16.dp))
                        .clickable { selectedCategory = cat }
                        .padding(horizontal = 14.dp, vertical = 8.dp)
                ) {
                    Text(cat, fontSize = 13.sp, fontWeight = if (selected) FontWeight.SemiBold else FontWeight.Medium, color = if (selected) PrimaryInk else TextMuted)
                }
            }
        }

        Spacer(modifier = Modifier.height(16.dp))

        // List
        if (filtered.isEmpty()) {
            Box(modifier = Modifier.fillMaxWidth().padding(vertical = 64.dp), contentAlignment = Alignment.Center) {
                Column(horizontalAlignment = Alignment.CenterHorizontally, verticalArrangement = Arrangement.spacedBy(12.dp)) {
                    Text("🏋️", fontSize = 32.sp)
                    Text("No exercises found", fontSize = 16.sp, fontWeight = FontWeight.Medium, color = TextMuted)
                }
            }
        } else {
            filtered.forEach { exercise ->
                ExerciseListRow(exercise, onSelectExercise)
                Spacer(modifier = Modifier.height(8.dp))
            }
        }
    }
}

@Composable
private fun ExerciseListRow(exercise: Exercise, onSelect: (Exercise) -> Unit) {
    val catColor = categoryColor(exercise.category)
    Row(
        modifier = Modifier
            .fillMaxWidth()
            .clip(RoundedCornerShape(16.dp))
            .background(Surface)
            .border(1.dp, Border, RoundedCornerShape(16.dp))
            .clickable { onSelect(exercise) }
            .padding(16.dp),
        verticalAlignment = Alignment.CenterVertically,
        horizontalArrangement = Arrangement.spacedBy(16.dp)
    ) {
        Box(
            modifier = Modifier
                .size(48.dp)
                .clip(RoundedCornerShape(12.dp))
                .background(catColor.copy(alpha = 0.15f)),
            contentAlignment = Alignment.Center
        ) {
            Text("🏋️", fontSize = 20.sp)
        }

        Column(modifier = Modifier.weight(1f), verticalArrangement = Arrangement.spacedBy(4.dp)) {
            Text(exercise.name, fontSize = 15.sp, fontWeight = FontWeight.SemiBold, color = Text)
            Row(verticalAlignment = Alignment.CenterVertically, horizontalArrangement = Arrangement.spacedBy(8.dp)) {
                Box(
                    modifier = Modifier
                        .clip(RoundedCornerShape(16.dp))
                        .background(catColor.copy(alpha = 0.12f))
                        .padding(horizontal = 8.dp, vertical = 3.dp)
                ) {
                    Text(exercise.category, fontSize = 11.sp, fontWeight = FontWeight.Medium, color = catColor)
                }
                Text("${exercise.targetSets} sets · ${exercise.targetReps} reps", fontSize = 12.sp, color = TextMuted)
            }
        }

        Text(">", fontSize = 12.sp, fontWeight = FontWeight.Medium, color = TextSubtle)
    }
}

// ------------------------------------------------------------------
// Workouts Tab
// ------------------------------------------------------------------

@Composable
private fun WorkoutsTab(
    workouts: List<Workout>,
    onSelectWorkout: (Workout) -> Unit,
    onSelectExercise: (Exercise) -> Unit,
    onEditWorkout: (Workout) -> Unit,
    onDuplicateWorkout: (Workout) -> Unit,
    onDeleteWorkout: (Workout) -> Unit
) {
    var searchText by remember { mutableStateOf("") }

    val filtered = remember(searchText, workouts) {
        if (searchText.isBlank()) workouts
        else workouts.filter {
            it.name.contains(searchText, ignoreCase = true) || it.category.contains(searchText, ignoreCase = true)
        }
    }

    Column(
        modifier = Modifier
            .fillMaxSize()
            .verticalScroll(rememberScrollState())
            .padding(horizontal = 16.dp)
            .padding(bottom = 80.dp)
    ) {
        // Search
        Row(
            modifier = Modifier
                .fillMaxWidth()
                .clip(RoundedCornerShape(24.dp))
                .background(Surface)
                .border(1.dp, Border, RoundedCornerShape(24.dp))
                .padding(horizontal = 16.dp, vertical = 10.dp),
            verticalAlignment = Alignment.CenterVertically,
            horizontalArrangement = Arrangement.spacedBy(8.dp)
        ) {
            Text("🔍", fontSize = 14.sp)
            BasicTextField(
                value = searchText,
                onValueChange = { searchText = it },
                modifier = Modifier.weight(1f),
                textStyle = androidx.compose.ui.text.TextStyle(fontSize = 15.sp, color = Text),
                decorationBox = { innerTextField ->
                    if (searchText.isEmpty()) {
                        Text("Search workouts", fontSize = 15.sp, color = TextSubtle)
                    }
                    innerTextField()
                }
            )
            if (searchText.isNotEmpty()) {
                Text("✕", fontSize = 16.sp, color = TextSubtle, modifier = Modifier.clickable { searchText = "" })
            }
        }

        Spacer(modifier = Modifier.height(16.dp))

        if (filtered.isEmpty()) {
            Box(modifier = Modifier.fillMaxWidth().padding(vertical = 64.dp), contentAlignment = Alignment.Center) {
                Column(horizontalAlignment = Alignment.CenterHorizontally, verticalArrangement = Arrangement.spacedBy(12.dp)) {
                    Text("📚", fontSize = 32.sp)
                    Text("No workouts found", fontSize = 16.sp, fontWeight = FontWeight.Medium, color = TextMuted)
                }
            }
        } else {
            filtered.forEach { workout ->
                WorkoutCard(
                    workout = workout,
                    onSelectWorkout = onSelectWorkout,
                    onSelectExercise = onSelectExercise,
                    onEdit = onEditWorkout,
                    onDuplicate = onDuplicateWorkout,
                    onDelete = onDeleteWorkout
                )
                Spacer(modifier = Modifier.height(12.dp))
            }
        }
    }
}

@Composable
private fun WorkoutCard(
    workout: Workout,
    onSelectWorkout: (Workout) -> Unit,
    onSelectExercise: (Exercise) -> Unit,
    onEdit: (Workout) -> Unit,
    onDuplicate: (Workout) -> Unit,
    onDelete: (Workout) -> Unit
) {
    Column(
        modifier = Modifier
            .fillMaxWidth()
            .clip(RoundedCornerShape(16.dp))
            .background(Surface)
            .border(1.dp, Border, RoundedCornerShape(16.dp))
            .padding(16.dp)
    ) {
        Row(verticalAlignment = Alignment.Top) {
            Column(modifier = Modifier.weight(1f), verticalArrangement = Arrangement.spacedBy(4.dp)) {
                Text(workout.name, fontSize = 18.sp, fontWeight = FontWeight.Bold, color = Text)
                Text(workout.category, fontSize = 13.sp, color = TextMuted)
            }

            // Menu
            var expanded by remember { mutableStateOf(false) }
            Box {
                Box(
                    modifier = Modifier
                        .size(36.dp)
                        .clip(CircleShape)
                        .background(Surface2)
                        .clickable { expanded = true },
                    contentAlignment = Alignment.Center
                ) {
                    Text("⋮", fontSize = 16.sp, fontWeight = FontWeight.SemiBold, color = TextMuted)
                }
                DropdownMenu(
                    expanded = expanded,
                    onDismissRequest = { expanded = false },
                    modifier = Modifier.background(Surface)
                ) {
                    DropdownMenuItem(
                        text = { Text("View Details", color = Text) },
                        onClick = { expanded = false; onSelectWorkout(workout) }
                    )
                    DropdownMenuItem(
                        text = { Text("Edit", color = Text) },
                        onClick = { expanded = false; onEdit(workout) }
                    )
                    DropdownMenuItem(
                        text = { Text("Duplicate", color = Text) },
                        onClick = { expanded = false; onDuplicate(workout) }
                    )
                    HorizontalDivider(color = Border)
                    DropdownMenuItem(
                        text = { Text("Delete", color = Danger) },
                        onClick = { expanded = false; onDelete(workout) }
                    )
                }
            }
        }

        Spacer(modifier = Modifier.height(12.dp))

        Row(horizontalArrangement = Arrangement.spacedBy(8.dp)) {
            StatPill("🏋️", "${workout.exercises.size} exercises")
            StatPill("⏱️", "${workout.estimatedMinutes} min")
        }

        Spacer(modifier = Modifier.height(12.dp))

        // Exercise preview chips
        Row(modifier = Modifier.horizontalScroll(rememberScrollState()), horizontalArrangement = Arrangement.spacedBy(8.dp)) {
            workout.exercises.take(4).forEach { exercise ->
                Box(
                    modifier = Modifier
                        .clip(RoundedCornerShape(16.dp))
                        .background(Surface2)
                        .clickable { onSelectExercise(exercise) }
                        .padding(horizontal = 10.dp, vertical = 6.dp)
                ) {
                    Row(verticalAlignment = Alignment.CenterVertically, horizontalArrangement = Arrangement.spacedBy(4.dp)) {
                        Text("🏋️", fontSize = 10.sp)
                        Text(exercise.name, fontSize = 11.sp, fontWeight = FontWeight.Medium, color = TextMuted)
                    }
                }
            }
            if (workout.exercises.size > 4) {
                Box(
                    modifier = Modifier
                        .clip(RoundedCornerShape(16.dp))
                        .background(Surface2)
                        .padding(horizontal = 10.dp, vertical = 6.dp)
                ) {
                    Text("+${workout.exercises.size - 4} more", fontSize = 11.sp, fontWeight = FontWeight.Medium, color = TextSubtle)
                }
            }
        }
    }
}

@Composable
private fun StatPill(icon: String, text: String) {
    Row(
        modifier = Modifier
            .clip(RoundedCornerShape(16.dp))
            .background(Surface2)
            .padding(horizontal = 10.dp, vertical = 6.dp),
        verticalAlignment = Alignment.CenterVertically,
        horizontalArrangement = Arrangement.spacedBy(4.dp)
    ) {
        Text(icon, fontSize = 10.sp)
        Text(text, fontSize = 11.sp, fontWeight = FontWeight.Medium, color = TextMuted)
    }
}

private fun categoryColor(category: String): Color = when (category) {
    "Push" -> Color(0xFF4ECDC4)
    "Pull" -> Primary
    "Legs" -> Color(0xFFFFA726)
    "Core" -> Color(0xFF66BB6A)
    "Mobility" -> TextMuted
    "Cardio" -> Danger
    else -> TextMuted
}
