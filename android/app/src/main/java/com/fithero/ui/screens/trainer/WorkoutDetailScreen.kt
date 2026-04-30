package com.fithero.ui.screens.trainer

import androidx.compose.foundation.background
import androidx.compose.foundation.border
import androidx.compose.foundation.clickable
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

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun WorkoutDetailScreen(
    workout: Workout,
    onDismiss: () -> Unit,
    onSelectExercise: (Exercise) -> Unit
) {
    Scaffold(
        topBar = {
            TopAppBar(
                title = { Text("Workout Details", color = Color.White, fontSize = 17.sp, fontWeight = FontWeight.SemiBold) },
                navigationIcon = {
                    IconButton(onClick = onDismiss) {
                        Icon(Icons.AutoMirrored.Filled.ArrowBack, "Back", tint = Color.White)
                    }
                },
                colors = TopAppBarDefaults.topAppBarColors(containerColor = Bg)
            )
        },
        containerColor = Bg
    ) { pad ->
        Column(
            modifier = Modifier
                .padding(pad)
                .fillMaxSize()
                .verticalScroll(rememberScrollState())
                .padding(16.dp)
        ) {
            // Header card
            HeaderCard(workout)

            Spacer(modifier = Modifier.height(24.dp))

            // Exercise list
            ExerciseListSection(workout, onSelectExercise)

            Spacer(modifier = Modifier.height(32.dp))
        }
    }
}

@Composable
private fun HeaderCard(workout: Workout) {
    Column(
        modifier = Modifier
            .fillMaxWidth()
            .clip(RoundedCornerShape(16.dp))
            .background(Surface)
            .border(1.dp, Border, RoundedCornerShape(16.dp))
            .padding(20.dp),
        horizontalAlignment = Alignment.CenterHorizontally,
        verticalArrangement = Arrangement.spacedBy(12.dp)
    ) {
        // Icon
        Box(
            modifier = Modifier
                .size(72.dp)
                .clip(RoundedCornerShape(16.dp))
                .background(Primary.copy(alpha = 0.12f)),
            contentAlignment = Alignment.Center
        ) {
            Text("🏋️", fontSize = 32.sp)
        }

        Text(workout.name, fontSize = 22.sp, fontWeight = FontWeight.Bold, color = Text, textAlign = androidx.compose.ui.text.style.TextAlign.Center)

        Text(workout.category.uppercase(), fontSize = 12.sp, fontWeight = FontWeight.SemiBold, color = Primary,
            letterSpacing = 1.2.sp)

        Row(horizontalArrangement = Arrangement.spacedBy(16.dp)) {
            Row(verticalAlignment = Alignment.CenterVertically, horizontalArrangement = Arrangement.spacedBy(4.dp)) {
                Text("💪", fontSize = 12.sp)
                Text("${workout.exercises.size} exercises", fontSize = 13.sp, fontWeight = FontWeight.Medium, color = TextMuted)
            }
            Row(verticalAlignment = Alignment.CenterVertically, horizontalArrangement = Arrangement.spacedBy(4.dp)) {
                Text("⏱️", fontSize = 12.sp)
                Text("${workout.estimatedMinutes} min", fontSize = 13.sp, fontWeight = FontWeight.Medium, color = TextMuted)
            }
        }
    }
}

@Composable
private fun ExerciseListSection(workout: Workout, onSelectExercise: (Exercise) -> Unit) {
    Column(verticalArrangement = Arrangement.spacedBy(12.dp)) {
        Row(verticalAlignment = Alignment.CenterVertically, horizontalArrangement = Arrangement.spacedBy(6.dp)) {
            Text("📋", fontSize = 13.sp)
            Text("EXERCISES", fontSize = 12.sp, fontWeight = FontWeight.SemiBold, color = TextSubtle, letterSpacing = 1.2.sp)
            Spacer(modifier = Modifier.weight(1f))
            Text("${workout.exercises.size}", fontSize = 13.sp, fontWeight = FontWeight.Medium, color = TextMuted)
        }

        workout.exercises.forEachIndexed { index, exercise ->
            ExerciseRow(exercise, index, onSelectExercise)
        }
    }
}

@Composable
private fun ExerciseRow(exercise: Exercise, index: Int, onSelect: (Exercise) -> Unit) {
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
        // Number badge
        Box(
            modifier = Modifier
                .size(36.dp)
                .clip(RoundedCornerShape(10.dp))
                .background(Primary.copy(alpha = 0.12f)),
            contentAlignment = Alignment.Center
        ) {
            Text("${index + 1}", fontSize = 14.sp, fontWeight = FontWeight.Bold, color = Primary)
        }

        Column(modifier = Modifier.weight(1f), verticalArrangement = Arrangement.spacedBy(3.dp)) {
            Text(exercise.name, fontSize = 15.sp, fontWeight = FontWeight.SemiBold, color = Text)
            Row(verticalAlignment = Alignment.CenterVertically, horizontalArrangement = Arrangement.spacedBy(8.dp)) {
                Text("${exercise.targetSets}×${exercise.targetReps}", fontSize = 12.sp, fontWeight = FontWeight.Medium, color = TextMuted)
                Text("·", fontSize = 12.sp, color = TextSubtle)
                Text("${exercise.restSeconds}s rest", fontSize = 12.sp, color = TextMuted)
            }
        }

        Text(">", fontSize = 12.sp, fontWeight = FontWeight.Medium, color = TextSubtle)
    }
}
