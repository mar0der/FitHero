package com.fithero.ui.screens.trainer

import androidx.compose.animation.core.animateFloatAsState
import androidx.compose.foundation.background
import androidx.compose.foundation.border
import androidx.compose.foundation.clickable
import androidx.compose.foundation.gestures.detectVerticalDragGestures
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.itemsIndexed
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.foundation.text.BasicTextField
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.graphicsLayer
import androidx.compose.ui.input.pointer.pointerInput
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.compose.ui.zIndex
import com.fithero.ui.theme.Bg
import com.fithero.ui.theme.Border
import com.fithero.ui.theme.Primary
import com.fithero.ui.theme.PrimaryInk
import com.fithero.ui.theme.Surface
import com.fithero.ui.theme.Surface2
import com.fithero.ui.theme.Text
import com.fithero.ui.theme.TextMuted
import com.fithero.ui.theme.TextSubtle

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun EditWorkoutSheet(
    workout: Workout,
    onSave: (Workout) -> Unit,
    onDismiss: () -> Unit,
    onPreviewExercise: (Exercise) -> Unit
) {
    var name by remember { mutableStateOf(workout.name) }
    var category by remember { mutableStateOf(workout.category) }
    var duration by remember { mutableStateOf(workout.estimatedMinutes.toString()) }
    var exercises by remember { mutableStateOf(workout.exercises) }
    var showPicker by remember { mutableStateOf(false) }

    val hasChanges = name != workout.name
            || category != workout.category
            || duration != workout.estimatedMinutes.toString()
            || exercises.size != workout.exercises.size
            || exercises.map { it.id } != workout.exercises.map { it.id }

    Scaffold(
        topBar = {
            TopAppBar(
                title = { Text("Edit Workout", color = Color.White, fontSize = 17.sp, fontWeight = FontWeight.SemiBold) },
                navigationIcon = {
                    TextButton(onClick = onDismiss) {
                        Text("Cancel", fontSize = 15.sp, color = TextMuted)
                    }
                },
                actions = {
                    TextButton(
                        onClick = {
                            val updated = workout.copy(
                                name = name,
                                category = category,
                                estimatedMinutes = duration.toIntOrNull() ?: workout.estimatedMinutes,
                                exercises = exercises
                            )
                            onSave(updated)
                        },
                        enabled = hasChanges
                    ) {
                        Text("Save", fontSize = 15.sp, fontWeight = FontWeight.SemiBold, color = if (hasChanges) Primary else TextSubtle)
                    }
                },
                colors = TopAppBarDefaults.topAppBarColors(containerColor = Bg)
            )
        },
        containerColor = Bg
    ) { pad ->
        if (showPicker) {
            ExercisePickerSheet(
                selectedExercises = exercises,
                onToggle = { exercise ->
                    exercises = if (exercises.any { it.id == exercise.id }) {
                        exercises.filter { it.id != exercise.id }
                    } else {
                        exercises + exercise
                    }
                },
                onDismiss = { showPicker = false },
                onPreviewExercise = onPreviewExercise
            )
        } else {
            Column(
                modifier = Modifier
                    .padding(pad)
                    .fillMaxSize()
                    .padding(16.dp),
                verticalArrangement = Arrangement.spacedBy(24.dp)
            ) {
                // Fields
                EditField("Workout Name", name, { name = it }, "e.g. Upper Body Power")
                EditField("Category", category, { category = it }, "e.g. Push / Pull / Legs")
                EditField("Duration (min)", duration, { duration = it }, "45")

                // Exercise list header
                Row(verticalAlignment = Alignment.CenterVertically) {
                    Text("EXERCISES", fontSize = 12.sp, fontWeight = FontWeight.SemiBold, color = TextSubtle, letterSpacing = 1.2.sp)
                    Spacer(modifier = Modifier.weight(1f))
                    Text("${exercises.size}", fontSize = 13.sp, fontWeight = FontWeight.Medium, color = TextMuted)
                }

                // Reorderable list
                ReorderableExerciseList(
                    exercises = exercises,
                    onReorder = { exercises = it },
                    onDelete = { idx -> exercises = exercises.toMutableList().apply { removeAt(idx) } }
                )

                // Add exercise button
                Box(
                    modifier = Modifier
                        .fillMaxWidth()
                        .clip(RoundedCornerShape(16.dp))
                        .background(Surface)
                        .border(1.dp, Primary.copy(alpha = 0.3f), RoundedCornerShape(16.dp))
                        .clickable { showPicker = true }
                        .padding(vertical = 16.dp),
                    contentAlignment = Alignment.Center
                ) {
                    Row(verticalAlignment = Alignment.CenterVertically, horizontalArrangement = Arrangement.spacedBy(6.dp)) {
                        Text("➕", fontSize = 18.sp)
                        Text("Add Exercise", fontSize = 15.sp, fontWeight = FontWeight.SemiBold, color = Primary)
                    }
                }

                Spacer(modifier = Modifier.height(32.dp))
            }
        }
    }
}

@Composable
private fun ReorderableExerciseList(
    exercises: List<Exercise>,
    onReorder: (List<Exercise>) -> Unit,
    onDelete: (Int) -> Unit
) {
    var draggedIndex by remember { mutableStateOf<Int?>(null) }
    var dragOffset by remember { mutableFloatStateOf(0f) }
    val estimatedItemHeight = 76f // dp, approximate row height

    LazyColumn(
        modifier = Modifier.fillMaxWidth(),
        verticalArrangement = Arrangement.spacedBy(8.dp)
    ) {
        itemsIndexed(exercises, key = { _, item -> item.id }) { index, exercise ->
            val isDragging = draggedIndex == index
            val animatedOffset by animateFloatAsState(
                targetValue = if (isDragging) dragOffset else 0f,
                label = "drag"
            )
            val scale by animateFloatAsState(
                targetValue = if (isDragging) 1.02f else 1f,
                label = "scale"
            )
            val elevation by animateFloatAsState(
                targetValue = if (isDragging) 8f else 0f,
                label = "elevation"
            )

            Box(
                modifier = Modifier
                    .fillMaxWidth()
                    .zIndex(if (isDragging) 1f else 0f)
                    .graphicsLayer {
                        translationY = animatedOffset
                        scaleX = scale
                        scaleY = scale
                        shadowElevation = elevation
                    }
            ) {
                ExerciseEditRow(
                    exercise = exercise,
                    index = index,
                    onDelete = { onDelete(index) },
                    dragHandleModifier = Modifier.pointerInput(index) {
                        detectVerticalDragGestures(
                            onDragStart = {
                                draggedIndex = index
                                dragOffset = 0f
                            },
                            onVerticalDrag = { change, dragAmount ->
                                change.consume()
                                dragOffset += dragAmount

                                // Swap when dragged past half an item height
                                val itemsMoved = (dragOffset / estimatedItemHeight).toInt()
                                if (itemsMoved != 0) {
                                    val newIndex = (draggedIndex ?: index) + itemsMoved
                                    if (newIndex in exercises.indices && newIndex != draggedIndex) {
                                        val currentList = exercises.toMutableList()
                                        val from = draggedIndex ?: index
                                        val to = newIndex
                                        val item = currentList.removeAt(from)
                                        currentList.add(to, item)
                                        onReorder(currentList)
                                        draggedIndex = to
                                        // Reset offset relative to new position
                                        dragOffset -= itemsMoved * estimatedItemHeight
                                    }
                                }
                            },
                            onDragEnd = {
                                draggedIndex = null
                                dragOffset = 0f
                            },
                            onDragCancel = {
                                draggedIndex = null
                                dragOffset = 0f
                            }
                        )
                    }
                )
            }
        }
    }
}

@Composable
private fun ExerciseEditRow(
    exercise: Exercise,
    index: Int,
    onDelete: () -> Unit,
    dragHandleModifier: Modifier
) {
    Row(
        modifier = Modifier
            .fillMaxWidth()
            .clip(RoundedCornerShape(16.dp))
            .background(Surface)
            .border(1.dp, Border, RoundedCornerShape(16.dp))
            .padding(16.dp),
        verticalAlignment = Alignment.CenterVertically,
        horizontalArrangement = Arrangement.spacedBy(16.dp)
    ) {
        // Drag handle (burger)
        Box(
            modifier = dragHandleModifier
                .padding(4.dp),
            contentAlignment = Alignment.Center
        ) {
            Text("☰", fontSize = 16.sp, color = TextSubtle)
        }

        Box(
            modifier = Modifier
                .size(36.dp)
                .clip(RoundedCornerShape(10.dp))
                .background(Primary.copy(alpha = 0.1f)),
            contentAlignment = Alignment.Center
        ) {
            Text("${index + 1}", fontSize = 14.sp, fontWeight = FontWeight.Bold, color = Primary)
        }

        Column(modifier = Modifier.weight(1f), verticalArrangement = Arrangement.spacedBy(2.dp)) {
            Text(exercise.name, fontSize = 15.sp, fontWeight = FontWeight.SemiBold, color = Text)
            Text("${exercise.targetSets}×${exercise.targetReps} · ${exercise.restSeconds}s rest", fontSize = 12.sp, color = TextMuted)
        }

        TextButton(onClick = onDelete) {
            Text("🗑️", fontSize = 16.sp)
        }
    }
}

@Composable
private fun EditField(
    label: String,
    value: String,
    onValueChange: (String) -> Unit,
    placeholder: String,
    modifier: Modifier = Modifier
) {
    Column(modifier = modifier, verticalArrangement = Arrangement.spacedBy(8.dp)) {
        Text(label.uppercase(), fontSize = 12.sp, fontWeight = FontWeight.SemiBold, color = TextSubtle, letterSpacing = 1.2.sp)
        BasicTextField(
            value = value,
            onValueChange = onValueChange,
            modifier = Modifier
                .fillMaxWidth()
                .clip(RoundedCornerShape(10.dp))
                .background(Surface)
                .border(1.dp, Border, RoundedCornerShape(10.dp))
                .padding(horizontal = 16.dp, vertical = 12.dp),
            textStyle = androidx.compose.ui.text.TextStyle(fontSize = 15.sp, color = Text),
            decorationBox = { innerTextField ->
                if (value.isEmpty()) {
                    Text(placeholder, fontSize = 15.sp, color = TextSubtle)
                }
                innerTextField()
            }
        )
    }
}
