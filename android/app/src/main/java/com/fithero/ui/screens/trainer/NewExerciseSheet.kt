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
fun NewExerciseSheet(
    onCreate: (Exercise) -> Unit,
    onDismiss: () -> Unit
) {
    var name by remember { mutableStateOf("") }
    var category by remember { mutableStateOf("Push") }
    var sets by remember { mutableStateOf("3") }
    var reps by remember { mutableStateOf("10") }
    var rest by remember { mutableStateOf("60") }
    var notes by remember { mutableStateOf("") }

    val categories = listOf("Push", "Pull", "Legs", "Core", "Mobility", "Cardio")

    Column(
        modifier = Modifier
            .fillMaxSize()
            .background(Bg)
            .padding(16.dp)
    ) {
        // Sheet handle + dismiss
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

        Text("New Exercise", fontSize = 24.sp, fontWeight = FontWeight.Bold, color = Text)

        Spacer(modifier = Modifier.height(24.dp))

        Column(
            modifier = Modifier
                .fillMaxWidth()
                .weight(1f)
                .verticalScroll(rememberScrollState()),
            verticalArrangement = Arrangement.spacedBy(20.dp)
        ) {
            InputField(label = "Name", value = name, onValueChange = { name = it }, placeholder = "e.g. Incline Dumbbell Press")

            // Category pills
            Column(verticalArrangement = Arrangement.spacedBy(8.dp)) {
                Text("CATEGORY", fontSize = 12.sp, fontWeight = FontWeight.SemiBold, color = TextSubtle, letterSpacing = 1.2.sp)
                Row(horizontalArrangement = Arrangement.spacedBy(8.dp)) {
                    categories.forEach { cat ->
                        val selected = category == cat
                        Box(
                            modifier = Modifier
                                .clip(RoundedCornerShape(16.dp))
                                .background(if (selected) Primary else Surface2)
                                .border(1.dp, if (selected) Primary else Border, RoundedCornerShape(16.dp))
                                .clickable { category = cat }
                                .padding(horizontal = 14.dp, vertical = 8.dp),
                            contentAlignment = Alignment.Center
                        ) {
                            Text(cat, fontSize = 13.sp, fontWeight = if (selected) FontWeight.SemiBold else FontWeight.Medium, color = if (selected) PrimaryInk else TextMuted)
                        }
                    }
                }
            }

            Row(horizontalArrangement = Arrangement.spacedBy(12.dp)) {
                InputField(label = "Sets", value = sets, onValueChange = { sets = it }, placeholder = "3", modifier = Modifier.weight(1f))
                InputField(label = "Reps", value = reps, onValueChange = { reps = it }, placeholder = "10", modifier = Modifier.weight(1f))
                InputField(label = "Rest (s)", value = rest, onValueChange = { rest = it }, placeholder = "60", modifier = Modifier.weight(1f))
            }

            InputField(label = "Notes", value = notes, onValueChange = { notes = it }, placeholder = "Form cues, setup tips...")

            Spacer(modifier = Modifier.height(8.dp))
        }

        Button(
            onClick = {
                val exercise = Exercise(
                    name = name.ifBlank { "New Exercise" },
                    category = category,
                    targetSets = sets.toIntOrNull() ?: 3,
                    targetReps = reps.ifBlank { "10" },
                    restSeconds = rest.toIntOrNull() ?: 60,
                    notes = notes.takeIf { it.isNotBlank() }
                )
                onCreate(exercise)
            },
            modifier = Modifier
                .fillMaxWidth()
                .height(52.dp),
            shape = RoundedCornerShape(12.dp),
            colors = ButtonDefaults.buttonColors(containerColor = Primary, contentColor = PrimaryInk)
        ) {
            Text("Create Exercise", fontSize = 16.sp, fontWeight = FontWeight.SemiBold)
        }

        Spacer(modifier = Modifier.height(16.dp))
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
