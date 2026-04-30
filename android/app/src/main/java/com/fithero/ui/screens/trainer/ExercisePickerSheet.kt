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
fun ExercisePickerSheet(
    selectedExercises: List<Exercise>,
    onToggle: (Exercise) -> Unit,
    onDismiss: () -> Unit,
    onPreviewExercise: (Exercise) -> Unit
) {
    var searchText by remember { mutableStateOf("") }

    val filtered = remember(searchText) {
        if (searchText.isBlank()) sampleExerciseLibrary
        else sampleExerciseLibrary.filter {
            it.name.contains(searchText, ignoreCase = true)
        }
    }

    Column(
        modifier = Modifier
            .fillMaxSize()
            .background(Bg)
            .padding(16.dp)
    ) {
        // Header
        Row(
            modifier = Modifier.fillMaxWidth(),
            verticalAlignment = Alignment.CenterVertically,
            horizontalArrangement = Arrangement.SpaceBetween
        ) {
            Text("Add Exercises", fontSize = 20.sp, fontWeight = FontWeight.Bold, color = Text)
            TextButton(onClick = onDismiss) {
                Text("Done", fontSize = 16.sp, fontWeight = FontWeight.SemiBold, color = Primary)
            }
        }

        Spacer(modifier = Modifier.height(12.dp))

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
                        Text("Search", fontSize = 15.sp, color = TextSubtle)
                    }
                    innerTextField()
                }
            )
        }

        Spacer(modifier = Modifier.height(16.dp))

        // List
        Column(
            modifier = Modifier
                .fillMaxWidth()
                .weight(1f)
                .verticalScroll(rememberScrollState()),
            verticalArrangement = Arrangement.spacedBy(8.dp)
        ) {
            filtered.forEach { exercise ->
                val isSelected = selectedExercises.any { it.id == exercise.id }
                ExercisePickerRow(
                    exercise = exercise,
                    isSelected = isSelected,
                    onToggle = { onToggle(exercise) },
                    onPreview = { onPreviewExercise(exercise) }
                )
            }
        }
    }
}

@Composable
private fun ExercisePickerRow(
    exercise: Exercise,
    isSelected: Boolean,
    onToggle: () -> Unit,
    onPreview: () -> Unit
) {
    Row(
        modifier = Modifier.fillMaxWidth(),
        verticalAlignment = Alignment.CenterVertically,
        horizontalArrangement = Arrangement.spacedBy(8.dp)
    ) {
        Row(
            modifier = Modifier
                .weight(1f)
                .clip(RoundedCornerShape(16.dp))
                .background(if (isSelected) Primary.copy(alpha = 0.05f) else Surface)
                .border(1.dp, if (isSelected) Primary.copy(alpha = 0.35f) else Border, RoundedCornerShape(16.dp))
                .clickable { onToggle() }
                .padding(16.dp),
            verticalAlignment = Alignment.CenterVertically,
            horizontalArrangement = Arrangement.spacedBy(16.dp)
        ) {
            Box(
                modifier = Modifier
                    .size(40.dp)
                    .clip(RoundedCornerShape(10.dp))
                    .background(if (isSelected) Primary.copy(alpha = 0.15f) else Surface2),
                contentAlignment = Alignment.Center
            ) {
                Text("🏋️", fontSize = 16.sp)
            }

            Column(modifier = Modifier.weight(1f), verticalArrangement = Arrangement.spacedBy(2.dp)) {
                Text(exercise.name, fontSize = 15.sp, fontWeight = if (isSelected) FontWeight.SemiBold else FontWeight.Medium, color = if (isSelected) Primary else Text)
                Text("${exercise.targetSets} sets · ${exercise.targetReps} reps", fontSize = 12.sp, color = TextMuted)
            }

            if (isSelected) {
                Text("✅", fontSize = 22.sp)
            } else {
                Box(
                    modifier = Modifier
                        .size(22.dp)
                        .clip(RoundedCornerShape(11.dp))
                        .border(1.5.dp, Border, RoundedCornerShape(11.dp))
                )
            }
        }

        // Info button
        TextButton(onClick = onPreview, modifier = Modifier.size(36.dp, 44.dp)) {
            Text("ℹ️", fontSize = 16.sp)
        }
    }
}
