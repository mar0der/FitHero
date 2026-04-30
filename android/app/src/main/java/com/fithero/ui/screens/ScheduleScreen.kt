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
import androidx.compose.material.icons.filled.CalendarToday
import androidx.compose.material.icons.filled.CheckCircle
import androidx.compose.material.icons.filled.LocationOn
import androidx.compose.material.icons.filled.Schedule
import androidx.compose.material.icons.filled.Timer
import androidx.compose.material.icons.filled.Videocam
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
import androidx.compose.ui.hapticfeedback.HapticFeedbackType
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.platform.LocalHapticFeedback
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import android.content.Intent
import android.provider.CalendarContract
import java.text.SimpleDateFormat
import java.util.Locale
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
import com.fithero.ui.theme.Warning

// ---------- Data ----------

private data class TrainingSession(
    val id: Int,
    val weekday: String,
    val day: String,
    val month: String,
    val time: String,
    val type: SessionType,
    val trainerName: String,
    val durationMinutes: Int,
    val location: String? = null
)

private enum class SessionType(val label: String, val iconColor: androidx.compose.ui.graphics.Color) {
    InPerson("In-person", Accent),
    Video("Video Call", Primary),
    CheckIn("Check-in", Success)
}

private val upcomingSessions = listOf(
    TrainingSession(1, "TUE", "22", "Apr", "09:00", SessionType.InPerson, "Maya", 60, "FitStudio Downtown"),
    TrainingSession(2, "THU", "24", "Apr", "18:30", SessionType.Video, "Maya", 30),
    TrainingSession(3, "SAT", "26", "Apr", "10:00", SessionType.CheckIn, "Maya", 15)
)

// ---------- Screen ----------

@Composable
fun ScheduleScreen(modifier: Modifier = Modifier) {
    var selectedSession by remember { mutableStateOf<TrainingSession?>(null) }
    var showReschedule by remember { mutableStateOf(false) }
    val context = LocalContext.current
    val haptic = LocalHapticFeedback.current

    Box(modifier = modifier.fillMaxSize().background(Bg)) {
        Column(
            modifier = Modifier
                .fillMaxSize()
                .verticalScroll(rememberScrollState())
                .padding(16.dp)
        ) {
            Text("Schedule", fontSize = 28.sp, fontWeight = FontWeight.Bold, color = Text)
            Text("Upcoming sessions", fontSize = 14.sp, color = TextMuted)
            Spacer(modifier = Modifier.height(20.dp))

            upcomingSessions.forEachIndexed { idx, session ->
                SessionCard(
                    session = session,
                    isNext = idx == 0,
                    onTap = { selectedSession = session },
                    onAddToCalendar = {
                        haptic.performHapticFeedback(HapticFeedbackType.LongPress)
                        addToCalendar(context, session)
                    },
                    onReschedule = {
                        selectedSession = session
                        showReschedule = true
                    }
                )
                Spacer(modifier = Modifier.height(12.dp))
            }

            // Past sessions
            Column(
                modifier = Modifier
                    .fillMaxWidth()
                    .clip(RoundedCornerShape(16.dp))
                    .background(Surface)
                    .padding(16.dp)
            ) {
                Text("PAST SESSIONS", fontSize = 12.sp, fontWeight = FontWeight.SemiBold, color = TextSubtle, letterSpacing = 1.2.sp)
                Spacer(modifier = Modifier.height(12.dp))
                listOf(
                    "In-person with Maya" to "3 days ago",
                    "Video call with Maya" to "7 days ago",
                    "In-person with Maya" to "11 days ago"
                ).forEachIndexed { idx, pair ->
                    Row(
                        modifier = Modifier.fillMaxWidth().padding(vertical = 8.dp),
                        horizontalArrangement = Arrangement.SpaceBetween,
                        verticalAlignment = Alignment.CenterVertically
                    ) {
                        Column {
                            Text(pair.first, fontSize = 14.sp, fontWeight = FontWeight.Medium, color = TextMuted)
                            Text(pair.second, fontSize = 12.sp, color = TextSubtle)
                        }
                        Icon(Icons.Default.CheckCircle, contentDescription = null, tint = Success, modifier = Modifier.size(18.dp))
                    }
                    if (idx < 2) Spacer(modifier = Modifier.height(1.dp).fillMaxWidth().background(Border))
                }
            }

            Spacer(modifier = Modifier.height(32.dp))
        }

        // Detail sheet overlay
        val currentSession = selectedSession
        if (currentSession != null && !showReschedule) {
            SessionDetailSheet(
                session = currentSession,
                onDismiss = { selectedSession = null },
                onAddToCalendar = {
                    haptic.performHapticFeedback(HapticFeedbackType.LongPress)
                    addToCalendar(context, currentSession)
                },
                onReschedule = { showReschedule = true }
            )
        }

        // Reschedule sheet overlay
        if (showReschedule && selectedSession != null) {
            RescheduleSheet(
                session = selectedSession!!,
                onDismiss = {
                    showReschedule = false
                    selectedSession = null
                }
            )
        }
    }
}

@Composable
private fun SessionCard(
    session: TrainingSession,
    isNext: Boolean,
    onTap: () -> Unit,
    onAddToCalendar: () -> Unit,
    onReschedule: () -> Unit
) {
    val borderColor = if (isNext) Primary.copy(alpha = 0.3f) else Border

    Row(
        modifier = Modifier
            .fillMaxWidth()
            .clip(RoundedCornerShape(16.dp))
            .background(Surface)
            .border(1.dp, borderColor, RoundedCornerShape(16.dp))
            .clickable { onTap() }
            .padding(16.dp),
        verticalAlignment = Alignment.CenterVertically
    ) {
        // Date column
        Column(horizontalAlignment = Alignment.CenterHorizontally, modifier = Modifier.width(50.dp)) {
            Text(session.weekday, fontSize = 11.sp, fontWeight = FontWeight.SemiBold, color = TextSubtle, letterSpacing = 0.5.sp)
            Text(session.day, fontSize = 24.sp, fontWeight = FontWeight.Bold, color = if (isNext) Primary else Text)
            Text(session.month, fontSize = 12.sp, color = TextMuted)
        }

        Spacer(modifier = Modifier.width(12.dp))

        Box(
            modifier = Modifier
                .width(2.dp)
                .height(60.dp)
                .clip(RoundedCornerShape(1.dp))
                .background(if (isNext) Primary else Border)
        )

        Spacer(modifier = Modifier.width(12.dp))

        Column(modifier = Modifier.weight(1f), verticalArrangement = Arrangement.spacedBy(6.dp)) {
            Row(verticalAlignment = Alignment.CenterVertically) {
                Box(
                    modifier = Modifier
                        .size(32.dp)
                        .clip(RoundedCornerShape(8.dp))
                        .background(session.type.iconColor.copy(alpha = 0.15f)),
                    contentAlignment = Alignment.Center
                ) {
                    val icon = when (session.type) {
                        SessionType.InPerson -> Icons.Default.LocationOn
                        SessionType.Video -> Icons.Default.Videocam
                        SessionType.CheckIn -> Icons.Default.CheckCircle
                    }
                    Icon(icon, contentDescription = null, tint = session.type.iconColor, modifier = Modifier.size(14.dp))
                }
                Spacer(modifier = Modifier.width(8.dp))
                Column {
                    Text(session.type.label, fontSize = 15.sp, fontWeight = FontWeight.SemiBold, color = Text)
                    Text("with ${session.trainerName}", fontSize = 13.sp, color = TextMuted)
                }
            }

            Row(horizontalArrangement = Arrangement.spacedBy(16.dp)) {
                Row(verticalAlignment = Alignment.CenterVertically) {
                    Icon(Icons.Default.Schedule, contentDescription = null, tint = TextMuted, modifier = Modifier.size(11.dp))
                    Spacer(modifier = Modifier.width(4.dp))
                    Text(session.time, fontSize = 13.sp, color = TextMuted)
                }
                Row(verticalAlignment = Alignment.CenterVertically) {
                    Icon(Icons.Default.Timer, contentDescription = null, tint = TextMuted, modifier = Modifier.size(11.dp))
                    Spacer(modifier = Modifier.width(4.dp))
                    Text("${session.durationMinutes} min", fontSize = 13.sp, color = TextMuted)
                }
            }

            session.location?.let {
                Row(verticalAlignment = Alignment.CenterVertically) {
                    Icon(Icons.Default.LocationOn, contentDescription = null, tint = TextSubtle, modifier = Modifier.size(11.dp))
                    Spacer(modifier = Modifier.width(4.dp))
                    Text(it, fontSize = 13.sp, color = TextSubtle)
                }
            }

            if (isNext) {
                Spacer(modifier = Modifier.height(4.dp))
                Row(horizontalArrangement = Arrangement.spacedBy(8.dp)) {
                    Box(
                        modifier = Modifier
                            .clip(CircleShape)
                            .background(Primary.copy(alpha = 0.1f))
                            .clickable { onAddToCalendar() }
                            .padding(horizontal = 10.dp, vertical = 6.dp)
                    ) {
                        Row(verticalAlignment = Alignment.CenterVertically) {
                            Icon(Icons.Default.CalendarToday, contentDescription = null, tint = Primary, modifier = Modifier.size(12.dp))
                            Spacer(modifier = Modifier.width(4.dp))
                            Text("Add to Calendar", fontSize = 12.sp, fontWeight = FontWeight.Medium, color = Primary)
                        }
                    }
                    Box(
                        modifier = Modifier
                            .clip(CircleShape)
                            .background(Surface2)
                            .clickable { onReschedule() }
                            .padding(horizontal = 10.dp, vertical = 6.dp)
                    ) {
                        Row(verticalAlignment = Alignment.CenterVertically) {
                            Icon(Icons.Default.Schedule, contentDescription = null, tint = TextMuted, modifier = Modifier.size(12.dp))
                            Spacer(modifier = Modifier.width(4.dp))
                            Text("Reschedule", fontSize = 12.sp, fontWeight = FontWeight.Medium, color = TextMuted)
                        }
                    }
                }
            }
        }
    }
}

// ---------- Detail Sheet ----------

@Composable
private fun SessionDetailSheet(
    session: TrainingSession,
    onDismiss: () -> Unit,
    onAddToCalendar: () -> Unit,
    onReschedule: () -> Unit
) {
    Box(
        modifier = Modifier
            .fillMaxSize()
            .background(Bg.copy(alpha = 0.95f))
            .clickable(onClick = onDismiss),
        contentAlignment = Alignment.Center
    ) {
        Column(
            modifier = Modifier
                .fillMaxWidth(0.9f)
                .clip(RoundedCornerShape(20.dp))
                .background(Surface)
                .clickable(enabled = false) { }
                .padding(20.dp)
                .verticalScroll(rememberScrollState()),
            horizontalAlignment = Alignment.CenterHorizontally
        ) {
            // Dismiss hint
            Box(modifier = Modifier.fillMaxWidth(), contentAlignment = Alignment.TopEnd) {
                Text("✕", fontSize = 20.sp, color = TextSubtle, modifier = Modifier.clickable { onDismiss() })
            }

            // Date header
            Column(horizontalAlignment = Alignment.CenterHorizontally, modifier = Modifier.fillMaxWidth()) {
                Text(session.weekday, fontSize = 14.sp, fontWeight = FontWeight.SemiBold, color = TextMuted)
                Text(session.day, fontSize = 56.sp, fontWeight = FontWeight.Bold, color = Text)
                Text("${session.month} 2026", fontSize = 16.sp, color = TextMuted)
                Text(session.time, fontSize = 20.sp, fontWeight = FontWeight.SemiBold, color = Primary)
            }

            Spacer(modifier = Modifier.height(20.dp))

            // Info rows
            Column(
                modifier = Modifier
                    .fillMaxWidth()
                    .clip(RoundedCornerShape(16.dp))
                    .background(Surface2)
                    .padding(16.dp)
            ) {
                DetailRow("Type", session.type.label, session.type.iconColor)
                Spacer(modifier = Modifier.height(1.dp).fillMaxWidth().background(Border))
                DetailRow("Trainer", session.trainerName, Accent)
                Spacer(modifier = Modifier.height(1.dp).fillMaxWidth().background(Border))
                DetailRow("Duration", "${session.durationMinutes} minutes", Warning)
                session.location?.let {
                    Spacer(modifier = Modifier.height(1.dp).fillMaxWidth().background(Border))
                    DetailRow("Location", it, Success)
                }
            }

            Spacer(modifier = Modifier.height(16.dp))

            // Actions
            Button(
                onClick = onAddToCalendar,
                modifier = Modifier.fillMaxWidth(),
                colors = ButtonDefaults.buttonColors(containerColor = Primary.copy(alpha = 0.1f), contentColor = Primary),
                shape = RoundedCornerShape(12.dp)
            ) {
                Row(modifier = Modifier.fillMaxWidth(), horizontalArrangement = Arrangement.SpaceBetween, verticalAlignment = Alignment.CenterVertically) {
                    Row(verticalAlignment = Alignment.CenterVertically) {
                        Icon(Icons.Default.CalendarToday, contentDescription = null, modifier = Modifier.size(16.dp))
                        Spacer(modifier = Modifier.width(8.dp))
                        Text("Add to Calendar", fontSize = 16.sp, fontWeight = FontWeight.SemiBold)
                    }
                    Icon(Icons.Default.LocationOn, contentDescription = null, tint = TextSubtle, modifier = Modifier.size(14.dp))
                }
            }

            Spacer(modifier = Modifier.height(8.dp))

            Button(
                onClick = onReschedule,
                modifier = Modifier.fillMaxWidth(),
                colors = ButtonDefaults.buttonColors(containerColor = Surface2, contentColor = Text),
                shape = RoundedCornerShape(12.dp)
            ) {
                Row(modifier = Modifier.fillMaxWidth(), horizontalArrangement = Arrangement.SpaceBetween, verticalAlignment = Alignment.CenterVertically) {
                    Row(verticalAlignment = Alignment.CenterVertically) {
                        Icon(Icons.Default.Schedule, contentDescription = null, modifier = Modifier.size(16.dp))
                        Spacer(modifier = Modifier.width(8.dp))
                        Text("Reschedule", fontSize = 16.sp, fontWeight = FontWeight.SemiBold)
                    }
                    Icon(Icons.AutoMirrored.Filled.KeyboardArrowRight, contentDescription = null, tint = TextSubtle, modifier = Modifier.size(14.dp))
                }
            }
        }
    }
}

@Composable
private fun DetailRow(label: String, value: String, color: androidx.compose.ui.graphics.Color) {
    Row(
        modifier = Modifier.fillMaxWidth().padding(vertical = 10.dp),
        verticalAlignment = Alignment.CenterVertically
    ) {
        Box(
            modifier = Modifier
                .size(36.dp)
                .clip(RoundedCornerShape(8.dp))
                .background(color.copy(alpha = 0.12f)),
            contentAlignment = Alignment.Center
        ) {
            Box(modifier = Modifier.size(8.dp).clip(CircleShape).background(color))
        }
        Spacer(modifier = Modifier.width(12.dp))
        Column {
            Text(label, fontSize = 12.sp, color = TextSubtle)
            Text(value, fontSize = 15.sp, fontWeight = FontWeight.SemiBold, color = Text)
        }
    }
}

// ---------- Reschedule Sheet ----------

@Composable
private fun RescheduleSheet(session: TrainingSession, onDismiss: () -> Unit) {
    var selectedDuration by remember { mutableStateOf(session.durationMinutes) }
    val durations = listOf(15, 30, 45, 60, 90)

    Box(
        modifier = Modifier
            .fillMaxSize()
            .background(Bg.copy(alpha = 0.95f))
            .clickable(onClick = onDismiss),
        contentAlignment = Alignment.Center
    ) {
        Column(
            modifier = Modifier
                .fillMaxWidth(0.9f)
                .clip(RoundedCornerShape(20.dp))
                .background(Surface)
                .clickable(enabled = false) { }
                .padding(20.dp)
                .verticalScroll(rememberScrollState())
        ) {
            Box(modifier = Modifier.fillMaxWidth(), contentAlignment = Alignment.TopEnd) {
                Text("✕", fontSize = 20.sp, color = TextSubtle, modifier = Modifier.clickable { onDismiss() })
            }
            Text("Reschedule", fontSize = 20.sp, fontWeight = FontWeight.Bold, color = Text)
            Spacer(modifier = Modifier.height(16.dp))

            // Current session
            Column(
                modifier = Modifier
                    .fillMaxWidth()
                    .clip(RoundedCornerShape(16.dp))
                    .background(Surface2)
                    .padding(16.dp)
            ) {
                Text("CURRENT SESSION", fontSize = 12.sp, fontWeight = FontWeight.SemiBold, color = TextSubtle, letterSpacing = 1.2.sp)
                Spacer(modifier = Modifier.height(8.dp))
                Row(verticalAlignment = Alignment.CenterVertically) {
                    Column(modifier = Modifier.weight(1f)) {
                        Text(session.type.label, fontSize = 16.sp, fontWeight = FontWeight.SemiBold, color = Text)
                        Text("${session.weekday}, ${session.day} ${session.month} at ${session.time}", fontSize = 14.sp, color = TextMuted)
                    }
                    Text("${session.durationMinutes} min", fontSize = 14.sp, fontWeight = FontWeight.Medium, color = TextSubtle)
                }
            }

            Spacer(modifier = Modifier.height(16.dp))

            // Duration chips
            Text("DURATION", fontSize = 12.sp, fontWeight = FontWeight.SemiBold, color = TextSubtle, letterSpacing = 1.2.sp)
            Spacer(modifier = Modifier.height(8.dp))
            Row(horizontalArrangement = Arrangement.spacedBy(8.dp)) {
                durations.forEach { mins ->
                    val selected = selectedDuration == mins
                    Box(
                        modifier = Modifier
                            .weight(1f)
                            .clip(RoundedCornerShape(10.dp))
                            .background(if (selected) Primary else Surface2)
                            .clickable { selectedDuration = mins }
                            .padding(vertical = 10.dp),
                        contentAlignment = Alignment.Center
                    ) {
                        Text(
                            "${mins}m",
                            fontSize = 14.sp,
                            fontWeight = if (selected) FontWeight.SemiBold else FontWeight.Medium,
                            color = if (selected) PrimaryInk else TextMuted
                        )
                    }
                }
            }

            Spacer(modifier = Modifier.height(24.dp))

            Button(
                onClick = onDismiss,
                modifier = Modifier.fillMaxWidth(),
                colors = ButtonDefaults.buttonColors(containerColor = Primary, contentColor = PrimaryInk),
                shape = RoundedCornerShape(12.dp)
            ) {
                Text("Send Reschedule Request", fontSize = 16.sp, fontWeight = FontWeight.SemiBold, modifier = Modifier.padding(vertical = 4.dp))
            }
        }
    }
}

private fun addToCalendar(context: android.content.Context, session: TrainingSession) {
    val sdf = SimpleDateFormat("dd MMM yyyy HH:mm", Locale.ENGLISH)
    val dateStr = "${session.day} ${session.month} 2026 ${session.time}"
    val startTime = sdf.parse(dateStr)?.time ?: return
    val endTime = startTime + session.durationMinutes * 60 * 1000

    val intent = Intent(Intent.ACTION_INSERT).apply {
        data = CalendarContract.Events.CONTENT_URI
        putExtra(CalendarContract.Events.TITLE, "${session.type.label} with ${session.trainerName}")
        putExtra(CalendarContract.Events.EVENT_LOCATION, session.location ?: "")
        putExtra(CalendarContract.Events.DESCRIPTION, "FitHero training session")
        putExtra(CalendarContract.EXTRA_EVENT_BEGIN_TIME, startTime)
        putExtra(CalendarContract.EXTRA_EVENT_END_TIME, endTime)
        putExtra(CalendarContract.Events.ALL_DAY, false)
    }

    if (intent.resolveActivity(context.packageManager) != null) {
        context.startActivity(intent)
    }
}
