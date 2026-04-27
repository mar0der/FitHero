package com.fithero.ui.screens

import androidx.compose.foundation.background
import androidx.compose.foundation.border
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.PaddingValues
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.aspectRatio
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.width
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.foundation.text.BasicTextField
import androidx.compose.foundation.verticalScroll
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.automirrored.filled.Send
import androidx.compose.material3.Button
import androidx.compose.material3.ButtonDefaults
import androidx.compose.material3.Divider
import androidx.compose.material3.Icon
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableIntStateOf
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.text.TextStyle
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
internal fun WorkoutSummaryScreen(
    modifier: Modifier = Modifier,
    workout: WorkoutData,
    durationSeconds: Int,
    onDone: () -> Unit
) {
    var rpe by remember { mutableIntStateOf(7) }
    var note by remember { mutableStateOf("") }
    var noteFocused by remember { mutableStateOf(false) }

    val totalVolume = workout.exercises.sumOf { it.targetSets * (it.targetReps.toIntOrNull() ?: 8) * 60 }
    val formattedDuration = String.format("%d:%02d", durationSeconds / 60, durationSeconds % 60)

    Box(modifier = modifier.fillMaxSize().background(Bg)) {
        Column(
            modifier = Modifier
                .fillMaxSize()
                .verticalScroll(rememberScrollState())
                .padding(16.dp)
                .padding(bottom = 100.dp)
        ) {
            // Hero
            Column(
                modifier = Modifier.fillMaxWidth().padding(vertical = 24.dp),
                horizontalAlignment = Alignment.CenterHorizontally
            ) {
                Box(
                    modifier = Modifier
                        .size(100.dp)
                        .clip(CircleShape)
                        .background(Primary.copy(alpha = 0.12f))
                        .border(1.5.dp, Primary.copy(alpha = 0.3f), CircleShape),
                    contentAlignment = Alignment.Center
                ) {
                    Text("✓", fontSize = 40.sp, fontWeight = FontWeight.Bold, color = Primary)
                }
                Spacer(modifier = Modifier.height(16.dp))
                Text("Workout Complete", fontSize = 28.sp, fontWeight = FontWeight.Bold, color = Text)
                Text(workout.name, fontSize = 16.sp, color = TextMuted)
            }

            // Stats grid
            Row(horizontalArrangement = Arrangement.spacedBy(8.dp)) {
                SummaryTile(formattedDuration, "Duration", false, Modifier.weight(1f))
                SummaryTile("${workout.exercises.size}", "Exercises", false, Modifier.weight(1f))
                SummaryTile("${totalVolume / 1000}k", "Volume (kg)", true, Modifier.weight(1f))
            }

            Spacer(modifier = Modifier.height(20.dp))

            // RPE
            Column(
                modifier = Modifier
                    .fillMaxWidth()
                    .clip(RoundedCornerShape(16.dp))
                    .background(Surface)
                    .border(1.dp, Border, RoundedCornerShape(16.dp))
                    .padding(16.dp)
            ) {
                Text("HOW HARD WAS IT?", fontSize = 12.sp, fontWeight = FontWeight.SemiBold, color = TextSubtle, letterSpacing = 1.2.sp)
                Spacer(modifier = Modifier.height(4.dp))
                Text(rpeLabel(rpe), fontSize = 17.sp, fontWeight = FontWeight.SemiBold, color = Text)
                Spacer(modifier = Modifier.height(12.dp))

                // RPE grid 1-10
                Row(horizontalArrangement = Arrangement.spacedBy(8.dp)) {
                    (1..5).forEach { level ->
                        RpePill(level, rpe, { rpe = level }, Modifier.weight(1f))
                    }
                }
                Spacer(modifier = Modifier.height(8.dp))
                Row(horizontalArrangement = Arrangement.spacedBy(8.dp)) {
                    (6..10).forEach { level ->
                        RpePill(level, rpe, { rpe = level }, Modifier.weight(1f))
                    }
                }
                Spacer(modifier = Modifier.height(8.dp))
                Text("RPE $rpe/10 · ${rpeDescription(rpe)}", fontSize = 12.sp, color = TextSubtle)
            }

            Spacer(modifier = Modifier.height(20.dp))

            // Note
            Column {
                Text("SESSION NOTE", fontSize = 12.sp, fontWeight = FontWeight.SemiBold, color = TextSubtle, letterSpacing = 1.2.sp)
                Spacer(modifier = Modifier.height(8.dp))
                Box(
                    modifier = Modifier
                        .fillMaxWidth()
                        .clip(RoundedCornerShape(16.dp))
                        .background(Surface)
                        .border(1.dp, if (noteFocused) Primary.copy(alpha = 0.5f) else Border, RoundedCornerShape(16.dp))
                        .padding(16.dp)
                ) {
                    if (note.isEmpty() && !noteFocused) {
                        Text("How did it feel? Any PRs or issues...", fontSize = 14.sp, color = TextSubtle)
                    }
                    BasicTextField(
                        value = note,
                        onValueChange = { note = it },
                        modifier = Modifier.fillMaxWidth().height(80.dp),
                        textStyle = TextStyle(fontSize = 14.sp, color = Text),
                        onTextLayout = { /* no-op */ },
                        decorationBox = { innerTextField ->
                            innerTextField()
                        }
                    )
                }
            }
        }

        // Bottom bar
        Row(
            modifier = Modifier
                .fillMaxWidth()
                .align(Alignment.BottomCenter)
                .background(Bg)
                .padding(16.dp),
            horizontalArrangement = Arrangement.spacedBy(8.dp)
        ) {
            Button(
                onClick = { },
                modifier = Modifier.weight(1f),
                colors = ButtonDefaults.buttonColors(containerColor = Surface2, contentColor = Text),
                shape = RoundedCornerShape(12.dp)
            ) {
                Row(verticalAlignment = Alignment.CenterVertically) {
                    Icon(Icons.AutoMirrored.Filled.Send, contentDescription = null, modifier = Modifier.size(14.dp))
                    Spacer(modifier = Modifier.width(6.dp))
                    Text("Send to coach", fontSize = 14.sp, fontWeight = FontWeight.SemiBold)
                }
            }
            Button(
                onClick = onDone,
                modifier = Modifier.weight(1f),
                colors = ButtonDefaults.buttonColors(containerColor = Primary, contentColor = PrimaryInk),
                shape = RoundedCornerShape(12.dp)
            ) {
                Text("Done", fontSize = 15.sp, fontWeight = FontWeight.Bold)
            }
        }
    }
}

@Composable
private fun SummaryTile(value: String, label: String, accent: Boolean, modifier: Modifier = Modifier) {
    Column(
        modifier = modifier
            .clip(RoundedCornerShape(16.dp))
            .background(Surface)
            .border(1.dp, if (accent) Primary.copy(alpha = 0.3f) else Border, RoundedCornerShape(16.dp))
            .padding(vertical = 16.dp),
        horizontalAlignment = Alignment.CenterHorizontally
    ) {
        Text(value, fontSize = 22.sp, fontWeight = FontWeight.Bold, color = if (accent) Primary else Text)
        Text(label.uppercase(), fontSize = 10.sp, fontWeight = FontWeight.Medium, color = TextSubtle, letterSpacing = 0.6.sp)
    }
}

@Composable
private fun RpePill(level: Int, selected: Int, onSelect: () -> Unit, modifier: Modifier = Modifier) {
    val isSelected = level == selected
    Box(
        modifier = modifier
            .aspectRatio(1f)
            .clip(RoundedCornerShape(12.dp))
            .background(if (isSelected) Primary else Surface2)
            .clickable(onClick = onSelect),
        contentAlignment = Alignment.Center
    ) {
        Text("$level", fontSize = 15.sp, fontWeight = FontWeight.SemiBold, color = if (isSelected) PrimaryInk else Text)
    }
}

private fun rpeLabel(rpe: Int): String = when (rpe) {
    in 1..3 -> "Easy 😌"
    in 4..5 -> "Moderate 💪"
    in 6..7 -> "Hard 🔥"
    in 8..9 -> "Very Hard 😤"
    else -> "Max Effort 🫠"
}

private fun rpeDescription(rpe: Int): String = when (rpe) {
    in 1..3 -> "Light effort, could keep going"
    in 4..5 -> "Challenging but comfortable"
    in 6..7 -> "Pushed through, solid session"
    in 8..9 -> "Near max, tough to finish"
    else -> "Absolutely everything"
}
