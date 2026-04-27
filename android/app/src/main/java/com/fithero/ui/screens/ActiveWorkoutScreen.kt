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
import androidx.compose.material3.Button
import androidx.compose.material3.ButtonDefaults
import androidx.compose.material3.Divider
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableIntStateOf
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
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
import kotlinx.coroutines.delay

private data class SetEntry(val setNumber: Int, val targetReps: String, val targetWeight: Int, var isCompleted: Boolean = false, var actualReps: Int? = null, var actualWeight: Int? = null)

@Composable
internal fun ActiveWorkoutScreen(
    modifier: Modifier = Modifier,
    workout: WorkoutData,
    startingExerciseIndex: Int = 0,
    onExerciseDone: (Int) -> Unit,
    onAbandon: () -> Unit
) {
    val currentExercise = workout.exercises[startingExerciseIndex]
    var sets by remember { mutableStateOf(List(currentExercise.targetSets) { SetEntry(it + 1, currentExercise.targetReps, 80) }) }
    var isResting by remember { mutableStateOf(false) }
    var restTimeRemaining by remember { mutableIntStateOf(currentExercise.restSeconds) }
    var weightInput by remember { mutableStateOf("80") }
    var repsInput by remember { mutableStateOf("10") }
    var elapsedSeconds by remember { mutableIntStateOf(0) }
    var timerActive by remember { mutableStateOf(true) }

    LaunchedEffect(timerActive, isResting) {
        while (timerActive) {
            delay(1000)
            elapsedSeconds++
            if (isResting && restTimeRemaining > 0) {
                restTimeRemaining--
                if (restTimeRemaining == 0) isResting = false
            }
        }
    }

    val activeSetIndex = sets.indexOfFirst { !it.isCompleted }
    val elapsedFormatted = String.format("%d:%02d", elapsedSeconds / 60, elapsedSeconds % 60)

    Column(modifier = modifier.fillMaxSize().background(Bg)) {
        // Nav bar
        Row(
            modifier = Modifier.fillMaxWidth().padding(horizontal = 8.dp, vertical = 12.dp),
            verticalAlignment = Alignment.CenterVertically
        ) {
            Box(
                modifier = Modifier.clickable { onAbandon() }.padding(8.dp),
                contentAlignment = Alignment.Center
            ) {
                Text("‹ List", fontSize = 14.sp, color = TextMuted)
            }
            Spacer(modifier = Modifier.weight(1f))
            Column(horizontalAlignment = Alignment.CenterHorizontally) {
                Text("Exercise ${startingExerciseIndex + 1} of ${workout.exercises.size}", fontSize = 12.sp, color = TextMuted)
                Spacer(modifier = Modifier.height(4.dp))
                Row(horizontalArrangement = Arrangement.spacedBy(5.dp)) {
                    workout.exercises.forEachIndexed { i, _ ->
                        Box(
                            modifier = Modifier
                                .clip(RoundedCornerShape(999.dp))
                                .background(if (i == startingExerciseIndex) Primary else Surface2)
                                .width(if (i == startingExerciseIndex) 18.dp else 6.dp)
                                .height(6.dp)
                        )
                    }
                }
            }
            Spacer(modifier = Modifier.weight(1f))
            Text(elapsedFormatted, fontSize = 13.sp, fontWeight = FontWeight.SemiBold, color = TextSubtle)
        }

        Divider(color = Border, thickness = 1.dp)

        Column(
            modifier = Modifier
                .fillMaxWidth()
                .weight(1f)
                .verticalScroll(rememberScrollState())
                .padding(16.dp)
        ) {
            // Exercise header
            Row(verticalAlignment = Alignment.CenterVertically) {
                Box(
                    modifier = Modifier.size(44.dp).clip(RoundedCornerShape(12.dp)).background(Primary.copy(alpha = 0.1f)),
                    contentAlignment = Alignment.Center
                ) {
                    Text("${startingExerciseIndex + 1}", fontSize = 18.sp, fontWeight = FontWeight.Bold, color = Primary)
                }
                Spacer(modifier = Modifier.width(12.dp))
                Column(modifier = Modifier.weight(1f)) {
                    Text(currentExercise.name, fontSize = 18.sp, fontWeight = FontWeight.Bold, color = Text)
                    Row(horizontalArrangement = Arrangement.spacedBy(6.dp)) {
                        Chip("${currentExercise.targetSets} sets")
                        Chip(currentExercise.targetReps + " reps")
                        Chip("${currentExercise.restSeconds}s rest")
                    }
                }
            }

            Spacer(modifier = Modifier.height(20.dp))

            // Set table
            Column(
                modifier = Modifier
                    .fillMaxWidth()
                    .clip(RoundedCornerShape(16.dp))
                    .background(Surface)
                    .border(1.dp, Border, RoundedCornerShape(16.dp))
                    .padding(12.dp)
            ) {
                // Header
                Row(modifier = Modifier.fillMaxWidth().padding(horizontal = 8.dp, vertical = 6.dp)) {
                    Text("SET", fontSize = 10.sp, fontWeight = FontWeight.SemiBold, color = TextSubtle, modifier = Modifier.width(32.dp))
                    Text("TARGET", fontSize = 10.sp, fontWeight = FontWeight.SemiBold, color = TextSubtle, modifier = Modifier.weight(1f))
                    Text("KG", fontSize = 10.sp, fontWeight = FontWeight.SemiBold, color = TextSubtle, modifier = Modifier.width(48.dp))
                    Text("REPS", fontSize = 10.sp, fontWeight = FontWeight.SemiBold, color = TextSubtle, modifier = Modifier.width(44.dp))
                    Spacer(modifier = Modifier.width(24.dp))
                }
                Spacer(modifier = Modifier.height(4.dp))
                sets.forEachIndexed { idx, setEntry ->
                    SetRow(setEntry, idx, activeSetIndex == idx)
                }
            }

            Spacer(modifier = Modifier.height(16.dp))
        }

        // Bottom panel
        Column(
            modifier = Modifier
                .fillMaxWidth()
                .background(Bg)
                .padding(16.dp)
        ) {
            if (isResting) {
                RestBar(currentExercise.restSeconds, restTimeRemaining, onSkip = { isResting = false }, onAdjust = { delta -> restTimeRemaining = (restTimeRemaining + delta).coerceIn(0, 300) })
            } else {
                // Weight / Reps steppers
                Row(horizontalArrangement = Arrangement.spacedBy(8.dp)) {
                    Stepper("KG", weightInput, onDec = { weightInput = adjustNum(weightInput, -2.5f) }, onInc = { weightInput = adjustNum(weightInput, 2.5f) }, Modifier.weight(1f))
                    Stepper("REPS", repsInput, onDec = { repsInput = adjustInt(repsInput, -1) }, onInc = { repsInput = adjustInt(repsInput, 1) }, Modifier.weight(1f))
                }
                Spacer(modifier = Modifier.height(12.dp))
                Button(
                    onClick = {
                        val idx = activeSetIndex ?: return@Button
                        sets = sets.toMutableList().apply {
                            this[idx] = this[idx].copy(
                                isCompleted = true,
                                actualReps = repsInput.toIntOrNull() ?: this[idx].targetReps.toIntOrNull() ?: 8,
                                actualWeight = weightInput.toIntOrNull() ?: this[idx].targetWeight
                            )
                        }
                        if (sets.all { it.isCompleted }) {
                            timerActive = false
                            onExerciseDone(elapsedSeconds)
                        } else {
                            isResting = true
                            restTimeRemaining = currentExercise.restSeconds
                        }
                    },
                    modifier = Modifier.fillMaxWidth(),
                    colors = ButtonDefaults.buttonColors(containerColor = Primary, contentColor = PrimaryInk),
                    shape = RoundedCornerShape(12.dp),
                    enabled = activeSetIndex != null
                ) {
                    Text("Log Set ${(activeSetIndex ?: 0) + 1}", fontSize = 16.sp, fontWeight = FontWeight.Bold, modifier = Modifier.padding(vertical = 4.dp))
                }
            }
        }
    }
}

@Composable
private fun Chip(text: String) {
    Box(
        modifier = Modifier
            .clip(RoundedCornerShape(999.dp))
            .background(Surface2)
            .padding(horizontal = 8.dp, vertical = 3.dp)
    ) {
        Text(text, fontSize = 11.sp, fontWeight = FontWeight.Medium, color = TextMuted)
    }
}

@Composable
private fun SetRow(setEntry: SetEntry, index: Int, isActive: Boolean) {
    val numColor = when {
        setEntry.isCompleted -> Success
        isActive -> Primary
        else -> TextSubtle
    }
    Row(
        modifier = Modifier
            .fillMaxWidth()
            .clip(RoundedCornerShape(8.dp))
            .background(if (isActive) Primary.copy(alpha = 0.05f) else androidx.compose.ui.graphics.Color.Transparent)
            .padding(horizontal = 8.dp, vertical = 9.dp),
        verticalAlignment = Alignment.CenterVertically
    ) {
        Text("${setEntry.setNumber}", fontSize = 14.sp, fontWeight = FontWeight.Bold, color = numColor, modifier = Modifier.width(32.dp))
        Text("${setEntry.targetReps} × ${setEntry.targetWeight} kg", fontSize = 13.sp, color = if (setEntry.isCompleted) TextSubtle else TextMuted, modifier = Modifier.weight(1f))
        if (setEntry.isCompleted) {
            Text("${setEntry.actualWeight}", fontSize = 14.sp, fontWeight = FontWeight.SemiBold, color = Text, modifier = Modifier.width(48.dp))
            Text("${setEntry.actualReps}", fontSize = 14.sp, fontWeight = FontWeight.SemiBold, color = Text, modifier = Modifier.width(44.dp))
        } else {
            Text("—", fontSize = 14.sp, color = TextSubtle, modifier = Modifier.width(48.dp))
            Text("—", fontSize = 14.sp, color = TextSubtle, modifier = Modifier.width(44.dp))
        }
        Box(modifier = Modifier.width(24.dp), contentAlignment = Alignment.Center) {
            Box(
                modifier = Modifier
                    .size(22.dp)
                    .clip(CircleShape)
                    .background(if (setEntry.isCompleted) Success else if (isActive) Primary.copy(alpha = 0.15f) else Surface2),
                contentAlignment = Alignment.Center
            ) {
                if (setEntry.isCompleted) {
                    Text("✓", fontSize = 10.sp, fontWeight = FontWeight.Bold, color = androidx.compose.ui.graphics.Color.White)
                }
            }
        }
    }
}

@Composable
private fun Stepper(label: String, value: String, onDec: () -> Unit, onInc: () -> Unit, modifier: Modifier = Modifier) {
    Row(
        modifier = modifier
            .clip(RoundedCornerShape(12.dp))
            .background(Surface)
            .border(1.dp, Border, RoundedCornerShape(12.dp)),
        horizontalArrangement = Arrangement.SpaceBetween,
        verticalAlignment = Alignment.CenterVertically
    ) {
        Box(modifier = Modifier.clickable { onDec() }.padding(14.dp)) {
            Text("−", fontSize = 16.sp, fontWeight = FontWeight.SemiBold, color = Text)
        }
        Column(horizontalAlignment = Alignment.CenterHorizontally) {
            Text(value, fontSize = 22.sp, fontWeight = FontWeight.Bold, color = Primary)
            Text(label, fontSize = 9.sp, fontWeight = FontWeight.SemiBold, color = TextSubtle, letterSpacing = 1.sp)
        }
        Box(modifier = Modifier.clickable { onInc() }.padding(14.dp)) {
            Text("+", fontSize = 16.sp, fontWeight = FontWeight.SemiBold, color = Text)
        }
    }
}

@Composable
private fun RestBar(totalRest: Int, remaining: Int, onSkip: () -> Unit, onAdjust: (Int) -> Unit) {
    val progress = if (totalRest > 0) remaining.toFloat() / totalRest else 0f
    Row(
        modifier = Modifier
            .fillMaxWidth()
            .clip(RoundedCornerShape(16.dp))
            .background(Surface)
            .border(1.dp, Primary.copy(alpha = 0.25f), RoundedCornerShape(16.dp))
            .padding(14.dp),
        verticalAlignment = Alignment.CenterVertically
    ) {
        // Circle progress
        Box(modifier = Modifier.size(56.dp), contentAlignment = Alignment.Center) {
            androidx.compose.foundation.Canvas(modifier = Modifier.fillMaxSize()) {
                drawCircle(color = Surface2, style = androidx.compose.ui.graphics.drawscope.Stroke(width = 4f))
                drawArc(
                    color = Primary,
                    startAngle = -90f,
                    sweepAngle = 360f * progress,
                    useCenter = false,
                    style = androidx.compose.ui.graphics.drawscope.Stroke(width = 4f, cap = androidx.compose.ui.graphics.StrokeCap.Round)
                )
            }
            Text("$remaining", fontSize = 18.sp, fontWeight = FontWeight.Bold, color = Primary)
        }
        Spacer(modifier = Modifier.width(12.dp))
        Column(modifier = Modifier.weight(1f)) {
            Text("Rest", fontSize = 13.sp, fontWeight = FontWeight.SemiBold, color = Text)
            Text("Next set coming up", fontSize = 12.sp, color = TextMuted)
        }
        Row(horizontalArrangement = Arrangement.spacedBy(6.dp)) {
            Box(modifier = Modifier.clip(RoundedCornerShape(8.dp)).background(Surface2).clickable { onAdjust(-15) }.padding(horizontal = 10.dp, vertical = 8.dp)) {
                Text("−15", fontSize = 12.sp, fontWeight = FontWeight.SemiBold, color = TextMuted)
            }
            Box(modifier = Modifier.clip(RoundedCornerShape(8.dp)).background(Primary).clickable { onSkip() }.padding(horizontal = 12.dp, vertical = 8.dp)) {
                Text("Skip", fontSize = 13.sp, fontWeight = FontWeight.Bold, color = PrimaryInk)
            }
            Box(modifier = Modifier.clip(RoundedCornerShape(8.dp)).background(Surface2).clickable { onAdjust(15) }.padding(horizontal = 10.dp, vertical = 8.dp)) {
                Text("+15", fontSize = 12.sp, fontWeight = FontWeight.SemiBold, color = TextMuted)
            }
        }
    }
}

private fun adjustNum(current: String, delta: Float): String {
    val v = (current.toFloatOrNull() ?: 0f) + delta
    return if (v % 1 == 0f) "${v.toInt()}" else "%.1f".format(v)
}

private fun adjustInt(current: String, delta: Int): String {
    return ((current.toIntOrNull() ?: 0) + delta).coerceAtLeast(0).toString()
}
