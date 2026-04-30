package com.fithero.ui.screens.trainer

import androidx.compose.foundation.background
import androidx.compose.foundation.border
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.foundation.text.BasicTextField
import androidx.compose.foundation.verticalScroll
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.fithero.ui.theme.Bg
import com.fithero.ui.theme.Border
import com.fithero.ui.theme.Primary
import com.fithero.ui.theme.PrimaryInk
import com.fithero.ui.theme.Surface
import com.fithero.ui.theme.Surface2
import com.fithero.ui.theme.Text
import com.fithero.ui.theme.TextMuted
import com.fithero.ui.theme.TextSubtle

@Composable
fun NewWorkoutSheet(
    onCreate: (Workout) -> Unit,
    onDismiss: () -> Unit
) {
    var name by remember { mutableStateOf("") }
    var category by remember { mutableStateOf("") }
    var duration by remember { mutableStateOf("45") }
    var selectedExercises by remember { mutableStateOf<List<Exercise>>(emptyList()) }
    var showPicker by remember { mutableStateOf(false) }

    Column(
        modifier = Modifier
            .fillMaxSize()
            .background(Bg)
            .padding(16.dp)
    ) {
        Row(
            modifier = Modifier.fillMaxWidth(),
            horizontalArrangement = Arrangement.SpaceBetween,
            verticalAlignment = Alignment.CenterVertically
        ) {
            Box(
                modifier = Modifier
                    .width(38.dp)
                    .height(5.dp)
                    .clip(RoundedCornerShape(100.dp))
                    .background(Color.White.copy(alpha = 0.2f))
            )
            TextButton(onClick = onDismiss) {
                Text("Cancel", fontSize = 15.sp, color = TextMuted)
            }
        }

        Spacer(modifier = Modifier.height(8.dp))

        Text("New Workout", fontSize = 24.sp, fontWeight = FontWeight.Bold, color = Text)

        Spacer(modifier = Modifier.height(24.dp))

        Column(
            modifier = Modifier
                .fillMaxWidth()
                .weight(1f)
                .verticalScroll(rememberScrollState()),
            verticalArrangement = Arrangement.spacedBy(20.dp)
        ) {
            InputField("Workout Name", name, { name = it }, "e.g. Upper Body Power")
            InputField("Category", category, { category = it }, "e.g. Push / Pull / Legs")
            InputField("Duration (min)", duration, { duration = it }, "45")

            // Selected exercises
            Column(verticalArrangement = Arrangement.spacedBy(12.dp)) {
                Row(verticalAlignment = Alignment.CenterVertically) {
                    Text("EXERCISES", fontSize = 12.sp, fontWeight = FontWeight.SemiBold, color = TextSubtle, letterSpacing = 1.2.sp)
                    Spacer(modifier = Modifier.weight(1f))
                    Text("${selectedExercises.size}", fontSize = 13.sp, fontWeight = FontWeight.Medium, color = TextMuted)
                }

                if (selectedExercises.isEmpty()) {
                    Box(
                        modifier = Modifier
                            .fillMaxWidth()
                            .clip(RoundedCornerShape(16.dp))
                            .background(Surface)
                            .border(1.dp, Primary.copy(alpha = 0.3f), RoundedCornerShape(16.dp))
                            .clickable { showPicker = true }
                            .padding(20.dp),
                        contentAlignment = Alignment.Center
                    ) {
                        Row(verticalAlignment = Alignment.CenterVertically, horizontalArrangement = Arrangement.spacedBy(8.dp)) {
                            Text("➕", fontSize = 18.sp)
                            Text("Add exercises from library", fontSize = 15.sp, fontWeight = FontWeight.Medium, color = Primary)
                        }
                    }
                } else {
                    Column(verticalArrangement = Arrangement.spacedBy(8.dp)) {
                        selectedExercises.forEach { exercise ->
                            Row(
                                modifier = Modifier
                                    .fillMaxWidth()
                                    .clip(RoundedCornerShape(12.dp))
                                    .background(Surface2)
                                    .padding(16.dp),
                                verticalAlignment = Alignment.CenterVertically,
                                horizontalArrangement = Arrangement.spacedBy(12.dp)
                            ) {
                                Text("🏋️", fontSize = 14.sp)
                                Text(exercise.name, fontSize = 14.sp, color = Text, modifier = Modifier.weight(1f))
                                Text("${exercise.targetSets}×${exercise.targetReps}", fontSize = 12.sp, color = TextMuted)
                            }
                        }
                        TextButton(onClick = { showPicker = true }) {
                            Text("➕ Add more", fontSize = 14.sp, fontWeight = FontWeight.Medium, color = Primary)
                        }
                    }
                }
            }

            Spacer(modifier = Modifier.height(8.dp))
        }

        Button(
            onClick = {
                val workout = Workout(
                    name = name.ifBlank { "New Workout" },
                    category = category.ifBlank { "Uncategorized" },
                    estimatedMinutes = duration.toIntOrNull() ?: 45,
                    exercises = selectedExercises
                )
                onCreate(workout)
            },
            modifier = Modifier
                .fillMaxWidth()
                .height(52.dp),
            shape = RoundedCornerShape(12.dp),
            colors = ButtonDefaults.buttonColors(containerColor = Primary, contentColor = PrimaryInk)
        ) {
            Text("Create Workout", fontSize = 16.sp, fontWeight = FontWeight.SemiBold)
        }

        Spacer(modifier = Modifier.height(16.dp))
    }

    if (showPicker) {
        Box(modifier = Modifier.fillMaxSize().background(Bg)) {
            ExercisePickerSheet(
                selectedExercises = selectedExercises,
                onToggle = { exercise ->
                    selectedExercises = if (selectedExercises.any { it.id == exercise.id }) {
                        selectedExercises.filter { it.id != exercise.id }
                    } else {
                        selectedExercises + exercise
                    }
                },
                onDismiss = { showPicker = false },
                onPreviewExercise = { /* Could show exercise detail */ }
            )
        }
    }
}

@Composable
private fun InputField(
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
