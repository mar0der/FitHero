package com.fithero.ui.screens

import androidx.compose.foundation.background
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
import androidx.compose.material.icons.filled.Person
import androidx.compose.material3.Button
import androidx.compose.material3.ButtonDefaults
import androidx.compose.material3.Icon
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.fithero.ui.theme.Accent
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
import java.util.Calendar

// ---------- Sample Data ----------

private data class Exercise(val name: String, val sfSymbol: String)
private data class WorkoutInfo(val name: String, val category: String, val estimatedMinutes: Int, val exercises: List<Exercise>)
private data class SessionInfo(val type: String, val trainerName: String, val weekday: String, val time: String, val location: String?)
private data class ChatMsg(val senderName: String, val text: String)

private val todayWorkout = WorkoutInfo(
    name = "Upper Body Strength",
    category = "Push / Pull",
    estimatedMinutes = 45,
    exercises = listOf(
        Exercise("Bench Press", "dumbbell"),
        Exercise("Dumbbell Row", "figure.rower"),
        Exercise("Overhead Press", "figure.strengthtraining.traditional"),
        Exercise("Cable Face Pull", "figure.mind.and.body"),
        Exercise("Tricep Dips", "figure.arms.open")
    )
)

private val nextSession = SessionInfo("In-person", "Maya", "Tuesday", "09:00", "FitStudio Downtown")

private val weekActivity = listOf<Boolean?>(true, true, false, true, false, false, null)
private val dayLabels = listOf("M", "T", "W", "T", "F", "S", "S")

private val messages = listOf(
    ChatMsg("Maya", "Great session yesterday! Your bench press form was on point."),
    ChatMsg("Maya", "Let's aim for 82.5 kg today. You've got this.")
)

private const val clientName = "Alex"
private const val clientAvatar = "A"

@Composable
fun HomeScreen(modifier: Modifier = Modifier, onStartWorkout: () -> Unit = {}, onSignOut: () -> Unit = {}) {
    var showProfile by remember { mutableStateOf(false) }
    var showPayments by remember { mutableStateOf(false) }
    var showWorkoutHistory by remember { mutableStateOf(false) }

    Box(modifier = modifier.fillMaxSize()) {
        Column(
            modifier = Modifier
                .fillMaxSize()
                .background(Bg)
                .verticalScroll(rememberScrollState())
                .padding(16.dp)
        ) {
            HeaderSection(onAvatarClick = { showProfile = true })
            Spacer(modifier = Modifier.height(24.dp))
            TodayWorkoutCard(onStartWorkout = onStartWorkout)
            Spacer(modifier = Modifier.height(20.dp))
            WeeklyActivityCard()
            Spacer(modifier = Modifier.height(20.dp))
            NextSessionCard()
            Spacer(modifier = Modifier.height(20.dp))
            MessagePreviewCard()
            Spacer(modifier = Modifier.height(40.dp))
        }

        if (showProfile) {
            ProfileSheet(
                onDismiss = { showProfile = false },
                onSignOut = onSignOut,
                onPayments = { showPayments = true },
                onWorkoutHistory = { showWorkoutHistory = true }
            )
        }
        if (showPayments) {
            PaymentsScreen(
                onDismiss = { showPayments = false },
                onAddPayment = { }
            )
        }
        if (showWorkoutHistory) {
            WorkoutHistoryScreen(onDismiss = { showWorkoutHistory = false })
        }
    }
}

// ---------- Header ----------

@Composable
private fun HeaderSection(onAvatarClick: () -> Unit) {
    val greeting = remember {
        val hour = Calendar.getInstance().get(Calendar.HOUR_OF_DAY)
        when {
            hour < 12 -> "Good morning, $clientName"
            hour < 17 -> "Good afternoon, $clientName"
            else -> "Good evening, $clientName"
        }
    }
    val dateStr = remember {
        val cal = Calendar.getInstance()
        val weekday = listOf("Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday")[cal.get(Calendar.DAY_OF_WEEK)-1]
        val month = listOf("January","February","March","April","May","June","July","August","September","October","November","December")[cal.get(Calendar.MONTH)]
        "$weekday, $month ${cal.get(Calendar.DAY_OF_MONTH)}"
    }

    Row(
        modifier = Modifier.fillMaxWidth(),
        horizontalArrangement = Arrangement.SpaceBetween,
        verticalAlignment = Alignment.Top
    ) {
        Column {
            Text(greeting, fontSize = 28.sp, fontWeight = FontWeight.Bold, color = Text)
            Text(dateStr, fontSize = 15.sp, color = TextMuted)
        }
        Box(
            modifier = Modifier
                .size(48.dp)
                .clip(CircleShape)
                .background(Primary.copy(alpha = 0.15f))
                .clickable(onClick = onAvatarClick),
            contentAlignment = Alignment.Center
        ) {
            Text(clientAvatar, fontSize = 18.sp, fontWeight = FontWeight.SemiBold, color = Primary)
        }
    }
}

// ---------- Today's Workout ----------

@Composable
private fun TodayWorkoutCard(onStartWorkout: () -> Unit) {
    Column(
        modifier = Modifier
            .fillMaxWidth()
            .clip(RoundedCornerShape(16.dp))
            .background(Surface)
            .padding(16.dp)
    ) {
        Row(modifier = Modifier.fillMaxWidth(), horizontalArrangement = Arrangement.SpaceBetween) {
            Text("TODAY'S WORKOUT", fontSize = 12.sp, fontWeight = FontWeight.SemiBold, color = Primary, letterSpacing = 1.2.sp)
            Text("${todayWorkout.estimatedMinutes} min", fontSize = 13.sp, fontWeight = FontWeight.Medium, color = TextMuted)
        }
        Spacer(modifier = Modifier.height(8.dp))
        Text(todayWorkout.name, fontSize = 22.sp, fontWeight = FontWeight.Bold, color = Text)
        Text("${todayWorkout.exercises.size} exercises  ·  ${todayWorkout.category}", fontSize = 14.sp, color = TextMuted)
        Spacer(modifier = Modifier.height(12.dp))

        // Exercise pills — scrollable row
        Row(horizontalArrangement = Arrangement.spacedBy(8.dp)) {
            todayWorkout.exercises.take(4).forEach { exercise ->
                ExercisePill(exercise.name)
            }
        }

        Spacer(modifier = Modifier.height(16.dp))
        Button(
            onClick = onStartWorkout,
            modifier = Modifier.fillMaxWidth(),
            colors = ButtonDefaults.buttonColors(containerColor = Primary, contentColor = PrimaryInk),
            shape = RoundedCornerShape(10.dp)
        ) {
            Text("Start Workout", fontSize = 16.sp, fontWeight = FontWeight.SemiBold)
        }
    }
}

@Composable
private fun ExercisePill(name: String) {
    Box(
        modifier = Modifier
            .clip(RoundedCornerShape(999.dp))
            .background(Surface2)
            .padding(horizontal = 10.dp, vertical = 6.dp)
    ) {
        Text(name, fontSize = 12.sp, fontWeight = FontWeight.Medium, color = TextMuted)
    }
}

// ---------- Weekly Activity ----------

@Composable
private fun WeeklyActivityCard() {
    Column(
        modifier = Modifier
            .fillMaxWidth()
            .clip(RoundedCornerShape(16.dp))
            .background(Surface)
            .padding(16.dp)
    ) {
        Row(modifier = Modifier.fillMaxWidth(), horizontalArrangement = Arrangement.SpaceBetween) {
            Text("THIS WEEK", fontSize = 12.sp, fontWeight = FontWeight.SemiBold, color = TextSubtle, letterSpacing = 1.2.sp)
            Text("3 of 5 workouts", fontSize = 13.sp, color = TextMuted)
        }
        Spacer(modifier = Modifier.height(16.dp))
        Row(modifier = Modifier.fillMaxWidth(), horizontalArrangement = Arrangement.SpaceEvenly) {
            dayLabels.forEachIndexed { index, day ->
                DayDot(day, weekActivity[index])
            }
        }
    }
}

@Composable
private fun DayDot(label: String, status: Boolean?) {
    Column(horizontalAlignment = Alignment.CenterHorizontally) {
        val bgColor = when (status) {
            true -> Primary
            false -> Surface2
            null -> Surface2
        }
        Box(
            modifier = Modifier
                .size(28.dp)
                .clip(CircleShape)
                .background(bgColor),
            contentAlignment = Alignment.Center
        ) {
            when (status) {
                true -> Text("✓", fontSize = 11.sp, fontWeight = FontWeight.Bold, color = PrimaryInk)
                false -> Box(modifier = Modifier.size(10.dp).clip(CircleShape).background(Primary.copy(alpha = 0.4f)))
                null -> Box(modifier = Modifier.size(6.dp).clip(CircleShape).background(TextSubtle))
            }
        }
        Spacer(modifier = Modifier.height(4.dp))
        Text(label, fontSize = 11.sp, color = TextSubtle)
    }
}

// ---------- Next Session ----------

@Composable
private fun NextSessionCard() {
    Column(
        modifier = Modifier
            .fillMaxWidth()
            .clip(RoundedCornerShape(16.dp))
            .background(Surface)
            .padding(16.dp)
    ) {
        Text("NEXT SESSION", fontSize = 12.sp, fontWeight = FontWeight.SemiBold, color = TextSubtle, letterSpacing = 1.2.sp)
        Spacer(modifier = Modifier.height(12.dp))
        Row(verticalAlignment = Alignment.CenterVertically) {
            Box(
                modifier = Modifier
                    .size(44.dp)
                    .clip(RoundedCornerShape(12.dp))
                    .background(Accent.copy(alpha = 0.15f)),
                contentAlignment = Alignment.Center
            ) {
                Icon(Icons.Default.Person, contentDescription = null, tint = Accent, modifier = Modifier.size(20.dp))
            }
            Spacer(modifier = Modifier.width(12.dp))
            Column(modifier = Modifier.weight(1f)) {
                Text("${nextSession.type} with ${nextSession.trainerName}", fontSize = 15.sp, fontWeight = FontWeight.SemiBold, color = Text)
                Text("${nextSession.weekday} · ${nextSession.time}", fontSize = 13.sp, color = TextMuted)
                nextSession.location?.let { Text(it, fontSize = 12.sp, color = TextSubtle) }
            }
            Text("›", fontSize = 18.sp, color = TextSubtle)
        }
    }
}

// ---------- Message Preview ----------

@Composable
private fun MessagePreviewCard() {
    val latest = messages.lastOrNull()
    Column(
        modifier = Modifier
            .fillMaxWidth()
            .clip(RoundedCornerShape(16.dp))
            .background(Surface)
            .padding(16.dp)
    ) {
        Row(modifier = Modifier.fillMaxWidth(), horizontalArrangement = Arrangement.SpaceBetween) {
            Text("MESSAGES", fontSize = 12.sp, fontWeight = FontWeight.SemiBold, color = TextSubtle, letterSpacing = 1.2.sp)
            Box(modifier = Modifier.size(20.dp).clip(CircleShape).background(Primary), contentAlignment = Alignment.Center) {
                Text("1", fontSize = 11.sp, fontWeight = FontWeight.Bold, color = PrimaryInk)
            }
        }
        Spacer(modifier = Modifier.height(12.dp))
        if (latest != null) {
            Row(verticalAlignment = Alignment.CenterVertically) {
                Box(
                    modifier = Modifier.size(40.dp).clip(CircleShape).background(Accent.copy(alpha = 0.15f)),
                    contentAlignment = Alignment.Center
                ) {
                    Text("M", fontSize = 15.sp, fontWeight = FontWeight.SemiBold, color = Accent)
                }
                Spacer(modifier = Modifier.width(12.dp))
                Column(modifier = Modifier.weight(1f)) {
                    Text(latest.senderName, fontSize = 14.sp, fontWeight = FontWeight.SemiBold, color = Text)
                    Text(latest.text, fontSize = 13.sp, color = TextMuted, maxLines = 2)
                }
                Text("5m", fontSize = 12.sp, color = TextSubtle)
            }
        }
    }
}
