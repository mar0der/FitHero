package com.fithero.ui.screens

import androidx.compose.foundation.background
import androidx.compose.foundation.border
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.layout.width
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.foundation.verticalScroll
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.automirrored.filled.KeyboardArrowRight
import androidx.compose.material.icons.filled.Check
import androidx.compose.material3.Icon
import androidx.compose.material3.LinearProgressIndicator
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.fithero.ui.theme.Bg
import com.fithero.ui.theme.Border
import com.fithero.ui.theme.Primary
import com.fithero.ui.theme.PrimaryInk
import com.fithero.ui.theme.Success
import com.fithero.ui.theme.Surface
import com.fithero.ui.theme.Surface2
import com.fithero.ui.theme.Text
import com.fithero.ui.theme.TextMuted
import com.fithero.ui.theme.TextSubtle

@Composable
internal fun WorkoutReadScreen(
    modifier: Modifier = Modifier,
    workout: WorkoutData,
    completedExercises: Set<Int>,
    onSelectExercise: (Int) -> Unit,
    onDismiss: () -> Unit
) {
    val doneCount = completedExercises.size
    val totalCount = workout.exercises.size
    val progress = if (totalCount > 0) doneCount.toFloat() / totalCount else 0f
    val nextIndex = (0 until totalCount).firstOrNull { it !in completedExercises }

    Box(modifier = modifier.fillMaxSize().background(Bg)) {
        Column(
            modifier = Modifier
                .fillMaxSize()
                .verticalScroll(rememberScrollState())
                .padding(16.dp)
                .padding(bottom = 100.dp)
        ) {
            // Top bar
            Row(modifier = Modifier.fillMaxWidth(), horizontalArrangement = Arrangement.SpaceBetween, verticalAlignment = Alignment.CenterVertically) {
                Box(modifier = Modifier.size(34.dp).clip(CircleShape).background(Surface2).clickable { onDismiss() }, contentAlignment = Alignment.Center) {
                    Text("✕", fontSize = 14.sp, color = TextMuted)
                }
                Column(horizontalAlignment = Alignment.CenterHorizontally) {
                    Text(workout.category.uppercase(), fontSize = 10.sp, fontWeight = FontWeight.SemiBold, color = TextSubtle, letterSpacing = 1.4.sp)
                    Text("TODAY", fontSize = 11.sp, fontWeight = FontWeight.Bold, color = Primary, letterSpacing = 1.5.sp)
                }
                Box(modifier = Modifier.size(34.dp))
            }

            Spacer(modifier = Modifier.height(20.dp))

            // Title + count
            Row(modifier = Modifier.fillMaxWidth(), verticalAlignment = Alignment.Bottom) {
                Text(workout.name, fontSize = 28.sp, fontWeight = FontWeight.Bold, color = Text, modifier = Modifier.weight(1f))
                Row(verticalAlignment = Alignment.Bottom) {
                    Text("$doneCount", fontSize = 22.sp, fontWeight = FontWeight.Bold, color = if (doneCount > 0) Primary else TextSubtle)
                    Text("/$totalCount", fontSize = 16.sp, fontWeight = FontWeight.Medium, color = TextSubtle)
                }
            }

            Spacer(modifier = Modifier.height(12.dp))

            // Progress bar
            LinearProgressIndicator(
                progress = { progress },
                modifier = Modifier.fillMaxWidth().height(6.dp).clip(RoundedCornerShape(3.dp)),
                color = Primary,
                trackColor = Surface2
            )

            Spacer(modifier = Modifier.height(12.dp))

            // Stat pills
            Row(horizontalArrangement = Arrangement.spacedBy(8.dp)) {
                StatPill("${workout.estimatedMinutes} min")
                val totalSets = workout.exercises.sumOf { it.targetSets }
                StatPill("$totalSets sets total")
                if (doneCount > 0) StatPill("$doneCount done", accent = true)
            }

            Spacer(modifier = Modifier.height(24.dp))

            // Exercise list header
            Row(modifier = Modifier.fillMaxWidth(), horizontalArrangement = Arrangement.SpaceBetween) {
                Text("EXERCISES", fontSize = 11.sp, fontWeight = FontWeight.SemiBold, color = TextSubtle, letterSpacing = 1.2.sp)
                Text("Tap any to jump", fontSize = 11.sp, color = TextSubtle)
            }
            Spacer(modifier = Modifier.height(12.dp))

            // Exercise rows
            workout.exercises.forEachIndexed { index, exercise ->
                val isDone = completedExercises.contains(index)
                val isNext = nextIndex == index
                ExerciseRow(exercise, index, isDone, isNext, onSelectExercise)
                Spacer(modifier = Modifier.height(8.dp))
            }
        }

        // Bottom bar
        Box(
            modifier = Modifier
                .fillMaxWidth()
                .align(Alignment.BottomCenter)
                .background(Bg)
                .padding(16.dp)
        ) {
            Row(verticalAlignment = Alignment.CenterVertically) {
                if (doneCount == totalCount) {
                    Text("All exercises complete 🎉", fontSize = 14.sp, color = TextMuted, modifier = Modifier.weight(1f))
                } else {
                    Column(modifier = Modifier.weight(1f)) {
                        val nextName = nextIndex?.let { workout.exercises[it].name } ?: workout.name
                        Text(nextName, fontSize = 14.sp, fontWeight = FontWeight.SemiBold, color = Text, maxLines = 1)
                        Text(if (doneCount == 0) "Start first exercise" else "${totalCount - doneCount} remaining", fontSize = 12.sp, color = TextMuted)
                    }
                    Box(
                        modifier = Modifier
                            .clip(RoundedCornerShape(999.dp))
                            .background(Primary)
                            .clickable { nextIndex?.let { onSelectExercise(it) } }
                            .padding(horizontal = 22.dp, vertical = 12.dp)
                    ) {
                        Row(verticalAlignment = Alignment.CenterVertically) {
                            Text(if (doneCount == 0) "Start" else "Continue", fontSize = 15.sp, fontWeight = FontWeight.Bold, color = PrimaryInk)
                            Spacer(modifier = Modifier.width(4.dp))
                            Text("▶", fontSize = 10.sp, color = PrimaryInk)
                        }
                    }
                }
            }
        }
    }
}

@Composable
private fun StatPill(text: String, accent: Boolean = false) {
    Box(
        modifier = Modifier
            .clip(RoundedCornerShape(999.dp))
            .background(if (accent) Primary.copy(alpha = 0.1f) else Surface2)
            .border(1.dp, if (accent) Primary.copy(alpha = 0.3f) else androidx.compose.ui.graphics.Color.Transparent, RoundedCornerShape(999.dp))
            .padding(horizontal = 10.dp, vertical = 5.dp)
    ) {
        Text(text, fontSize = 12.sp, fontWeight = FontWeight.Medium, color = if (accent) Primary else TextMuted)
    }
}

@Composable
private fun ExerciseRow(
    exercise: ExerciseItem,
    index: Int,
    isDone: Boolean,
    isNext: Boolean,
    onSelectExercise: (Int) -> Unit
) {
    Row(
        modifier = Modifier
            .fillMaxWidth()
            .clip(RoundedCornerShape(16.dp))
            .background(Surface)
            .border(
                1.dp,
                when {
                    isNext -> Primary.copy(alpha = 0.35f)
                    isDone -> Success.copy(alpha = 0.2f)
                    else -> Border
                },
                RoundedCornerShape(16.dp)
            )
            .clickable { onSelectExercise(index) }
            .padding(14.dp),
        verticalAlignment = Alignment.CenterVertically
    ) {
        // Status icon
        Box(
            modifier = Modifier
                .size(48.dp)
                .clip(RoundedCornerShape(12.dp))
                .background(
                    when {
                        isDone -> Success.copy(alpha = 0.15f)
                        isNext -> Primary.copy(alpha = 0.12f)
                        else -> Surface2
                    }
                ),
            contentAlignment = Alignment.Center
        ) {
            if (isDone) {
                Icon(Icons.Default.Check, contentDescription = null, tint = Success, modifier = Modifier.size(20.dp))
            } else {
                Text("${index + 1}", fontSize = 18.sp, fontWeight = FontWeight.Bold, color = if (isNext) Primary else TextMuted)
            }
        }

        Spacer(modifier = Modifier.width(12.dp))

        Column(modifier = Modifier.weight(1f)) {
            Text(
                exercise.name,
                fontSize = 15.sp,
                fontWeight = FontWeight.SemiBold,
                color = if (isDone) TextMuted else Text
            )
            Spacer(modifier = Modifier.height(2.dp))
            Text(
                "${exercise.targetSets}×${exercise.targetReps} · ${exercise.restSeconds}s rest",
                fontSize = 12.sp,
                color = if (isDone) TextSubtle else TextMuted
            )
        }

        when {
            isDone -> Box(modifier = Modifier.clip(RoundedCornerShape(999.dp)).background(Success.copy(alpha = 0.1f)).padding(horizontal = 10.dp, vertical = 4.dp)) {
                Text("Done", fontSize = 11.sp, fontWeight = FontWeight.SemiBold, color = Success)
            }
            isNext -> Box(modifier = Modifier.clip(RoundedCornerShape(999.dp)).background(Primary).padding(horizontal = 10.dp, vertical = 4.dp)) {
                Row(verticalAlignment = Alignment.CenterVertically) {
                    Text("Next", fontSize = 11.sp, fontWeight = FontWeight.Bold, color = PrimaryInk)
                    Spacer(modifier = Modifier.width(2.dp))
                    Text("→", fontSize = 10.sp, color = PrimaryInk)
                }
            }
            else -> Text("›", fontSize = 18.sp, color = TextSubtle)
        }
    }
}
