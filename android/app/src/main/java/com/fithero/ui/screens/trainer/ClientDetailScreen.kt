package com.fithero.ui.screens.trainer

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
import androidx.compose.foundation.layout.ColumnScope
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.automirrored.filled.Chat
import androidx.compose.material.icons.automirrored.filled.Message
import androidx.compose.material.icons.filled.AddCircle
import androidx.compose.material.icons.filled.ArrowDownward
import androidx.compose.material.icons.filled.Assignment
import androidx.compose.material.icons.filled.AttachMoney
import androidx.compose.material.icons.filled.CalendarToday
import androidx.compose.material.icons.filled.CheckCircle
import androidx.compose.material.icons.filled.Close
import androidx.compose.material.icons.filled.DirectionsWalk
import androidx.compose.material.icons.filled.Favorite
import androidx.compose.material.icons.filled.FitnessCenter
import androidx.compose.material.icons.filled.Refresh
import androidx.compose.material.icons.filled.Sync
import androidx.compose.material3.Button
import androidx.compose.material3.ButtonDefaults
import androidx.compose.material3.Icon
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableIntStateOf
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.saveable.rememberSaveable
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.vector.ImageVector
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
import com.fithero.ui.theme.Warning
import com.fithero.ui.screens.MessagesScreen

data class ClientItem(
    val name: String,
    val plan: String,
    val status: String,
    val lastActive: String,
    val initials: String
) {
    val isActive: Boolean get() = status == "Active"
    val firstName: String get() = name.substringBefore(" ")

    val statusColor: Color
        get() = when (status) {
            "Active" -> Accent
            "Pending" -> Warning
            else -> TextSubtle
        }
}

@Composable
fun ClientDetailScreen(client: ClientItem, onDismiss: () -> Unit) {
    var selectedTab by rememberSaveable { mutableIntStateOf(0) }
    var showChat by remember { mutableStateOf(false) }
    var showScheduleSheet by remember { mutableStateOf(false) }
    var showAssignSheet by remember { mutableStateOf(false) }
    val tabs = listOf("Overview", "Programs", "Progress", "Notes")

    Box(modifier = Modifier.fillMaxSize().background(Bg)) {
        Column(
            modifier = Modifier
                .fillMaxSize()
                .verticalScroll(rememberScrollState())
                .padding(horizontal = 16.dp)
                .padding(bottom = 40.dp)
        ) {
            // Header
            HeaderSection(client = client, onDismiss = onDismiss)

            Spacer(modifier = Modifier.height(16.dp))

            // Action buttons
            ActionButtons(
                onMessage = { showChat = true },
                onSchedule = { showScheduleSheet = true },
                onAssign = { showAssignSheet = true }
            )

            Spacer(modifier = Modifier.height(16.dp))

            // Segmented control
            SegmentedControl(tabs = tabs, selectedTab = selectedTab, onSelect = { selectedTab = it })

            Spacer(modifier = Modifier.height(16.dp))

            when (selectedTab) {
                0 -> OverviewTab(client = client)
                1 -> ProgramsTab()
                2 -> ProgressTab()
                3 -> NotesTab()
            }
        }

        // Chat overlay
        if (showChat) {
            MessagesScreen(
                partnerName = client.name,
                partnerInitial = client.initials,
                isTrainerContext = true,
                onBack = { showChat = false }
            )
        }

        // Schedule sheet overlay
        if (showScheduleSheet) {
            ScheduleSessionSheet(
                clientName = client.firstName,
                onConfirm = { showScheduleSheet = false },
                onDismiss = { showScheduleSheet = false }
            )
        }

        // Assign sheet overlay
        if (showAssignSheet) {
            AssignProgramSheet(
                clientName = client.firstName,
                onConfirm = { showAssignSheet = false },
                onDismiss = { showAssignSheet = false }
            )
        }
    }
}

@Composable
private fun HeaderSection(client: ClientItem, onDismiss: () -> Unit) {
    Row(
        modifier = Modifier
            .fillMaxWidth()
            .padding(top = 20.dp),
        verticalAlignment = Alignment.CenterVertically,
        horizontalArrangement = Arrangement.spacedBy(12.dp)
    ) {
        Box(
            modifier = Modifier
                .size(64.dp)
                .clip(CircleShape)
                .background(client.statusColor.copy(alpha = 0.15f)),
            contentAlignment = Alignment.Center
        ) {
            Text(client.initials, fontSize = 22.sp, fontWeight = FontWeight.Bold, color = client.statusColor)
        }

        Column(modifier = Modifier.weight(1f)) {
            Text(client.name, fontSize = 22.sp, fontWeight = FontWeight.Bold, color = Text)
            Row(verticalAlignment = Alignment.CenterVertically, horizontalArrangement = Arrangement.spacedBy(8.dp)) {
                StatusPill(status = client.status)
                Text(client.plan, fontSize = 13.sp, color = TextMuted)
            }
        }

        Box(
            modifier = Modifier
                .size(34.dp)
                .clip(CircleShape)
                .background(Surface2)
                .clickable { onDismiss() },
            contentAlignment = Alignment.Center
        ) {
            Icon(Icons.Default.Close, contentDescription = null, tint = TextMuted, modifier = Modifier.size(18.dp))
        }
    }
}

@Composable
private fun StatusPill(status: String) {
    val color = when (status) {
        "Active" -> Success
        "Pending" -> Warning
        else -> TextSubtle
    }
    Text(
        status,
        fontSize = 11.sp,
        fontWeight = FontWeight.SemiBold,
        color = color,
        modifier = Modifier
            .clip(CircleShape)
            .background(color.copy(alpha = 0.12f))
            .padding(horizontal = 8.dp, vertical = 3.dp)
    )
}

@Composable
private fun ActionButtons(
    onMessage: () -> Unit,
    onSchedule: () -> Unit,
    onAssign: () -> Unit
) {
    Row(modifier = Modifier.fillMaxWidth(), horizontalArrangement = Arrangement.spacedBy(8.dp)) {
        ActionButton(icon = Icons.AutoMirrored.Filled.Chat, label = "Message", color = Accent, modifier = Modifier.weight(1f), onClick = onMessage)
        ActionButton(icon = Icons.Default.CalendarToday, label = "Schedule", color = Primary, modifier = Modifier.weight(1f), onClick = onSchedule)
        ActionButton(icon = Icons.Default.Assignment, label = "Assign", color = Warning, modifier = Modifier.weight(1f), onClick = onAssign)
    }
}

@Composable
private fun ActionButton(icon: ImageVector, label: String, color: Color, modifier: Modifier = Modifier, onClick: () -> Unit) {
    Column(
        modifier = modifier
            .clip(RoundedCornerShape(12.dp))
            .clickable { onClick() }
            .padding(vertical = 12.dp),
        horizontalAlignment = Alignment.CenterHorizontally,
        verticalArrangement = Arrangement.spacedBy(6.dp)
    ) {
        Box(
            modifier = Modifier
                .size(48.dp)
                .clip(RoundedCornerShape(10.dp))
                .background(color.copy(alpha = 0.12f)),
            contentAlignment = Alignment.Center
        ) {
            Icon(icon, contentDescription = null, tint = color, modifier = Modifier.size(20.dp))
        }
        Text(label, fontSize = 11.sp, fontWeight = FontWeight.Medium, color = TextMuted)
    }
}

@Composable
private fun SegmentedControl(tabs: List<String>, selectedTab: Int, onSelect: (Int) -> Unit) {
    Row(
        modifier = Modifier
            .fillMaxWidth()
            .clip(RoundedCornerShape(12.dp))
            .background(Surface)
            .padding(4.dp),
        horizontalArrangement = Arrangement.spacedBy(4.dp)
    ) {
        tabs.forEachIndexed { index, title ->
            val selected = selectedTab == index
            Box(
                modifier = Modifier
                    .weight(1f)
                    .clip(RoundedCornerShape(10.dp))
                    .background(if (selected) Primary else Color.Transparent)
                    .clickable { onSelect(index) }
                    .padding(vertical = 10.dp),
                contentAlignment = Alignment.Center
            ) {
                Text(
                    title,
                    fontSize = 13.sp,
                    fontWeight = if (selected) FontWeight.SemiBold else FontWeight.Medium,
                    color = if (selected) PrimaryInk else TextMuted
                )
            }
        }
    }
}

@Composable
private fun OverviewTab(client: ClientItem) {
    Column(verticalArrangement = Arrangement.spacedBy(16.dp)) {
        // Goals
        CardColumn {
            SectionTitle("GOALS")
            Spacer(modifier = Modifier.height(12.dp))
            GoalRow(icon = Icons.Default.CheckCircle, text = "Lose 6 kg, build lean muscle")
            GoalRow(icon = Icons.Default.DirectionsWalk, text = "Train 4× per week consistently")
            GoalRow(icon = Icons.Default.Favorite, text = "Improve cardiovascular health")
        }

        // Quick Stats
        Row(modifier = Modifier.fillMaxWidth(), horizontalArrangement = Arrangement.spacedBy(8.dp)) {
            StatTile(value = "12", label = "Workouts done", icon = Icons.Default.FitnessCenter, accent = false, modifier = Modifier.weight(1f))
            StatTile(value = "3", label = "Sessions this week", icon = Icons.Default.CalendarToday, accent = true, modifier = Modifier.weight(1f))
            StatTile(value = "2.5 kg", label = "Weight change", icon = Icons.Default.ArrowDownward, accent = false, modifier = Modifier.weight(1f))
        }

        // Next Session
        CardColumn {
            SectionTitle("NEXT SESSION")
            Spacer(modifier = Modifier.height(12.dp))
            Row(verticalAlignment = Alignment.CenterVertically, horizontalArrangement = Arrangement.spacedBy(12.dp)) {
                Box(
                    modifier = Modifier
                        .size(44.dp)
                        .clip(RoundedCornerShape(10.dp))
                        .background(Accent.copy(alpha = 0.15f)),
                    contentAlignment = Alignment.Center
                ) {
                    Icon(Icons.Default.DirectionsWalk, contentDescription = null, tint = Accent, modifier = Modifier.size(20.dp))
                }
                Column {
                    Text("In-person with ${client.firstName}", fontSize = 15.sp, fontWeight = FontWeight.SemiBold, color = Text)
                    Text("Tomorrow · 09:00 · 60 min", fontSize = 13.sp, color = TextMuted)
                    Text("FitStudio Downtown", fontSize = 12.sp, color = TextSubtle)
                }
            }
        }

        // Recent Activity
        CardColumn {
            SectionTitle("RECENT ACTIVITY")
            Spacer(modifier = Modifier.height(12.dp))
            ActivityRow(icon = Icons.Default.CheckCircle, text = "Completed Upper Body Strength", time = "2h ago", color = Success)
            Divider(color = Border)
            ActivityRow(icon = Icons.AutoMirrored.Filled.Message, text = "Sent check-in reminder", time = "5h ago", color = Accent)
            Divider(color = Border)
            ActivityRow(icon = Icons.Default.AttachMoney, text = "Paid \$320 for April", time = "1d ago", color = Primary)
        }
    }
}

@Composable
private fun GoalRow(icon: ImageVector, text: String) {
    Row(verticalAlignment = Alignment.CenterVertically, horizontalArrangement = Arrangement.spacedBy(8.dp)) {
        Icon(icon, contentDescription = null, tint = Primary, modifier = Modifier.size(18.dp))
        Text(text, fontSize = 14.sp, color = Text)
    }
}

@Composable
private fun ActivityRow(icon: ImageVector, text: String, time: String, color: Color) {
    Row(
        modifier = Modifier
            .fillMaxWidth()
            .padding(vertical = 10.dp),
        verticalAlignment = Alignment.CenterVertically,
        horizontalArrangement = Arrangement.spacedBy(12.dp)
    ) {
        Icon(icon, contentDescription = null, tint = color, modifier = Modifier.size(18.dp))
        Column(modifier = Modifier.weight(1f)) {
            Text(text, fontSize = 14.sp, color = Text)
            Text(time, fontSize = 12.sp, color = TextSubtle)
        }
    }
}

@Composable
private fun ProgramsTab() {
    Column(verticalArrangement = Arrangement.spacedBy(16.dp)) {
        CardColumn {
            SectionTitle("ACTIVE PROGRAM")
            Spacer(modifier = Modifier.height(12.dp))
            Text("12-Week Strength Builder", fontSize = 18.sp, fontWeight = FontWeight.Bold, color = Text)
            Text("Week 3 of 12 · Push/Pull/Legs split", fontSize = 14.sp, color = TextMuted)
            Spacer(modifier = Modifier.height(8.dp))
            Row(horizontalArrangement = Arrangement.spacedBy(8.dp)) {
                StatPill("3 days/week")
                StatPill("45–60 min")
            }
            Spacer(modifier = Modifier.height(12.dp))
            Button(
                onClick = { },
                modifier = Modifier.fillMaxWidth(),
                colors = ButtonDefaults.buttonColors(containerColor = Surface2, contentColor = Text),
                shape = RoundedCornerShape(10.dp)
            ) {
                Row(verticalAlignment = Alignment.CenterVertically, horizontalArrangement = Arrangement.spacedBy(8.dp)) {
                    Icon(Icons.Default.Sync, contentDescription = null, tint = Text, modifier = Modifier.size(16.dp))
                    Text("Change Program", fontSize = 15.sp, fontWeight = FontWeight.Medium)
                }
            }
        }

        CardColumn {
            SectionTitle("PROGRAM HISTORY")
            Spacer(modifier = Modifier.height(12.dp))
            HistoryRow(name = "Foundation Phase", dates = "Jan 15 – Mar 15", status = "Completed")
            Divider(color = Border)
            HistoryRow(name = "Hypertrophy Block", dates = "Nov 1 – Jan 14", status = "Completed")
        }
    }
}

@Composable
private fun HistoryRow(name: String, dates: String, status: String) {
    Row(
        modifier = Modifier
            .fillMaxWidth()
            .padding(vertical = 10.dp),
        verticalAlignment = Alignment.CenterVertically
    ) {
        Column(modifier = Modifier.weight(1f)) {
            Text(name, fontSize = 15.sp, fontWeight = FontWeight.SemiBold, color = Text)
            Text(dates, fontSize = 13.sp, color = TextMuted)
        }
        Text(
            status,
            fontSize = 11.sp,
            fontWeight = FontWeight.SemiBold,
            color = Success,
            modifier = Modifier
                .clip(CircleShape)
                .background(Success.copy(alpha = 0.12f))
                .padding(horizontal = 10.dp, vertical = 4.dp)
        )
    }
}

@Composable
private fun ProgressTab() {
    Column(verticalArrangement = Arrangement.spacedBy(16.dp)) {
        Row(modifier = Modifier.fillMaxWidth(), horizontalArrangement = Arrangement.spacedBy(8.dp)) {
            StatTile(value = "79.8", label = "Current kg", icon = Icons.Default.FitnessCenter, accent = false, modifier = Modifier.weight(1f))
            StatTile(value = "82.3", label = "Start kg", icon = Icons.Default.Refresh, accent = false, modifier = Modifier.weight(1f))
            StatTile(value = "−2.5", label = "Change", icon = Icons.Default.ArrowDownward, accent = true, modifier = Modifier.weight(1f))
        }

        CardColumn {
            SectionTitle("BODY MEASUREMENTS")
            Spacer(modifier = Modifier.height(12.dp))
            MeasurementRow(name = "Chest", value = "98.5", unit = "cm", change = "−0.7")
            Divider(color = Border)
            MeasurementRow(name = "Waist", value = "82.0", unit = "cm", change = "−2.5")
            Divider(color = Border)
            MeasurementRow(name = "Hips", value = "96.0", unit = "cm", change = "−0.8")
            Divider(color = Border)
            MeasurementRow(name = "Left Arm", value = "36.5", unit = "cm", change = "+0.7")
        }

        CardColumn {
            SectionTitle("PERSONAL RECORDS")
            Spacer(modifier = Modifier.height(12.dp))
            PRRow(exercise = "Bench Press", value = "100 kg", date = "3 days ago")
            Spacer(modifier = Modifier.height(8.dp))
            PRRow(exercise = "Back Squat", value = "140 kg", date = "10 days ago")
            Spacer(modifier = Modifier.height(8.dp))
            PRRow(exercise = "Deadlift", value = "180 kg", date = "14 days ago")
        }
    }
}

@Composable
private fun MeasurementRow(name: String, value: String, unit: String, change: String) {
    Row(
        modifier = Modifier
            .fillMaxWidth()
            .padding(vertical = 10.dp),
        verticalAlignment = Alignment.CenterVertically
    ) {
        Text(name, fontSize = 15.sp, fontWeight = FontWeight.Medium, color = Text, modifier = Modifier.weight(1f))
        Text("$value $unit", fontSize = 16.sp, fontWeight = FontWeight.SemiBold, color = Text)
        Spacer(modifier = Modifier.width(8.dp))
        val changeColor = when {
            change.startsWith("−") -> Success
            change.startsWith("+") -> Warning
            else -> TextSubtle
        }
        Text(change, fontSize = 13.sp, fontWeight = FontWeight.Medium, color = changeColor, modifier = Modifier.width(50.dp))
    }
}

@Composable
private fun PRRow(exercise: String, value: String, date: String) {
    Row(
        modifier = Modifier
            .fillMaxWidth()
            .clip(RoundedCornerShape(12.dp))
            .background(Surface.copy(alpha = 0.5f))
            .padding(14.dp),
        verticalAlignment = Alignment.CenterVertically,
        horizontalArrangement = Arrangement.spacedBy(12.dp)
    ) {
        Box(
            modifier = Modifier
                .size(40.dp)
                .clip(RoundedCornerShape(10.dp))
                .background(Warning.copy(alpha = 0.12f)),
            contentAlignment = Alignment.Center
        ) {
            Icon(Icons.Default.FitnessCenter, contentDescription = null, tint = Warning, modifier = Modifier.size(18.dp))
        }
        Column(modifier = Modifier.weight(1f)) {
            Text(exercise, fontSize = 15.sp, fontWeight = FontWeight.SemiBold, color = Text)
            Text(date, fontSize = 12.sp, color = TextSubtle)
        }
        Text(value, fontSize = 18.sp, fontWeight = FontWeight.Bold, color = Primary)
    }
}

@Composable
private fun NotesTab() {
    Column(verticalArrangement = Arrangement.spacedBy(16.dp)) {
        Button(
            onClick = { },
            modifier = Modifier.fillMaxWidth(),
            colors = ButtonDefaults.buttonColors(containerColor = Primary, contentColor = PrimaryInk),
            shape = RoundedCornerShape(12.dp)
        ) {
            Row(verticalAlignment = Alignment.CenterVertically, horizontalArrangement = Arrangement.spacedBy(8.dp)) {
                Icon(Icons.Default.AddCircle, contentDescription = null, tint = PrimaryInk, modifier = Modifier.size(20.dp))
                Text("Add Session Note", fontSize = 16.sp, fontWeight = FontWeight.SemiBold)
            }
        }

        Column(verticalArrangement = Arrangement.spacedBy(8.dp)) {
            SectionTitle("RECENT NOTES")
            NoteCard(date = "Apr 20", text = "Great energy today. Pushed weight up on bench and handled it well. Keep protein high this week.")
            NoteCard(date = "Apr 18", text = "Mentioned left shoulder tightness during warm-up. Monitored throughout session, no pain at working weight. Recommend foam rolling before next push day.")
            NoteCard(date = "Apr 15", text = "Check-in call: down 0.8 kg, sleep improving, stress lower. Nutrition adherence at 90%.")
        }
    }
}

@Composable
private fun NoteCard(date: String, text: String) {
    Column(
        modifier = Modifier
            .fillMaxWidth()
            .clip(RoundedCornerShape(12.dp))
            .background(Surface)
            .border(1.dp, Border, RoundedCornerShape(12.dp))
            .padding(14.dp),
        verticalArrangement = Arrangement.spacedBy(6.dp)
    ) {
        Text(date, fontSize = 12.sp, fontWeight = FontWeight.SemiBold, color = Primary)
        Text(text, fontSize = 14.sp, color = Text, lineHeight = 20.sp)
    }
}

@Composable
private fun CardColumn(content: @Composable ColumnScope.() -> Unit) {
    Column(
        modifier = Modifier
            .fillMaxWidth()
            .clip(RoundedCornerShape(12.dp))
            .background(Surface)
            .border(1.dp, Border, RoundedCornerShape(12.dp))
            .padding(16.dp),
        content = content
    )
}

@Composable
private fun SectionTitle(text: String) {
    Text(
        text = text,
        fontSize = 12.sp,
        fontWeight = FontWeight.SemiBold,
        color = TextSubtle,
        letterSpacing = 1.2.sp
    )
}

@Composable
private fun StatTile(value: String, label: String, icon: ImageVector, accent: Boolean, modifier: Modifier = Modifier) {
    Column(
        modifier = modifier
            .clip(RoundedCornerShape(10.dp))
            .background(Surface.copy(alpha = 0.5f))
            .border(1.dp, if (accent) Primary.copy(alpha = 0.3f) else Border, RoundedCornerShape(10.dp))
            .padding(12.dp),
        horizontalAlignment = Alignment.CenterHorizontally,
        verticalArrangement = Arrangement.spacedBy(6.dp)
    ) {
        Icon(icon, contentDescription = null, tint = if (accent) Primary else TextMuted, modifier = Modifier.size(18.dp))
        Text(value, fontSize = 20.sp, fontWeight = FontWeight.Bold, color = if (accent) Primary else Text)
        Text(label.uppercase(), fontSize = 9.sp, fontWeight = FontWeight.Medium, color = TextSubtle, letterSpacing = 0.6.sp)
    }
}

@Composable
private fun StatPill(text: String) {
    Text(
        text = text,
        fontSize = 11.sp,
        fontWeight = FontWeight.Medium,
        color = TextMuted,
        modifier = Modifier
            .clip(CircleShape)
            .background(Surface2)
            .padding(horizontal = 10.dp, vertical = 5.dp)
    )
}

@Composable
private fun Divider(color: Color) {
    Spacer(
        modifier = Modifier
            .fillMaxWidth()
            .height(1.dp)
            .background(color)
    )
}


// ---------- Schedule Session Sheet ----------

@Composable
private fun ScheduleSessionSheet(
    clientName: String,
    onConfirm: () -> Unit,
    onDismiss: () -> Unit
) {
    var selectedType by remember { mutableIntStateOf(0) }
    var selectedDuration by remember { mutableIntStateOf(60) }
    val types = listOf("In-person", "Video call", "Check-in")
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

            Text("Schedule with $clientName", fontSize = 22.sp, fontWeight = FontWeight.Bold, color = Text)
            Spacer(modifier = Modifier.height(20.dp))

            SectionTitle("SESSION TYPE")
            Spacer(modifier = Modifier.height(8.dp))
            Row(horizontalArrangement = Arrangement.spacedBy(8.dp)) {
                types.forEachIndexed { index, type ->
                    val selected = selectedType == index
                    Box(
                        modifier = Modifier
                            .clip(RoundedCornerShape(999.dp))
                            .background(if (selected) Primary else Surface2)
                            .clickable { selectedType = index }
                            .padding(horizontal = 14.dp, vertical = 8.dp)
                    ) {
                        Text(
                            type,
                            fontSize = 14.sp,
                            fontWeight = if (selected) FontWeight.SemiBold else FontWeight.Medium,
                            color = if (selected) PrimaryInk else TextMuted
                        )
                    }
                }
            }

            Spacer(modifier = Modifier.height(20.dp))

            SectionTitle("DURATION")
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

            Box(
                modifier = Modifier
                    .fillMaxWidth()
                    .height(48.dp)
                    .clip(RoundedCornerShape(12.dp))
                    .background(Primary)
                    .clickable { onConfirm() },
                contentAlignment = Alignment.Center
            ) {
                Text("Schedule Session", fontSize = 16.sp, fontWeight = FontWeight.SemiBold, color = PrimaryInk)
            }
        }
    }
}

// ---------- Assign Program Sheet ----------

private data class WorkoutItem(val name: String, val exercises: String, val minutes: Int)

private val workoutLibrary = listOf(
    WorkoutItem("Upper Body Strength", "5 exercises", 45),
    WorkoutItem("Lower Body Power", "6 exercises", 55),
    WorkoutItem("Full Body HIIT", "8 exercises", 35),
    WorkoutItem("Push Day", "6 exercises", 50),
    WorkoutItem("Pull Day", "5 exercises", 45)
)

@Composable
private fun AssignProgramSheet(
    clientName: String,
    onConfirm: () -> Unit,
    onDismiss: () -> Unit
) {
    var selectedWorkout by remember { mutableStateOf<WorkoutItem?>(null) }

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

            Text("Assign to $clientName", fontSize = 22.sp, fontWeight = FontWeight.Bold, color = Text)
            Spacer(modifier = Modifier.height(4.dp))
            Text("Choose a workout from your library", fontSize = 15.sp, color = TextMuted)
            Spacer(modifier = Modifier.height(16.dp))

            workoutLibrary.forEach { workout ->
                val isSelected = selectedWorkout == workout
                Row(
                    modifier = Modifier
                        .fillMaxWidth()
                        .clip(RoundedCornerShape(12.dp))
                        .background(if (isSelected) Surface2 else Surface)
                        .border(1.dp, if (isSelected) Primary.copy(alpha = 0.4f) else Border, RoundedCornerShape(12.dp))
                        .clickable { selectedWorkout = workout }
                        .padding(14.dp),
                    verticalAlignment = Alignment.CenterVertically
                ) {
                    Box(
                        modifier = Modifier
                            .size(44.dp)
                            .clip(RoundedCornerShape(10.dp))
                            .background(Primary.copy(alpha = 0.12f)),
                        contentAlignment = Alignment.Center
                    ) {
                        Icon(Icons.Default.FitnessCenter, contentDescription = null, tint = Primary, modifier = Modifier.size(18.dp))
                    }
                    Spacer(modifier = Modifier.width(12.dp))
                    Column(modifier = Modifier.weight(1f)) {
                        Text(workout.name, fontSize = 15.sp, fontWeight = FontWeight.SemiBold, color = Text)
                        Text("${workout.exercises} · ${workout.minutes} min", fontSize = 13.sp, color = TextMuted)
                    }
                    if (isSelected) {
                        Icon(Icons.Default.CheckCircle, contentDescription = null, tint = Success, modifier = Modifier.size(22.dp))
                    }
                }
                Spacer(modifier = Modifier.height(8.dp))
            }

            Spacer(modifier = Modifier.height(16.dp))

            Box(
                modifier = Modifier
                    .fillMaxWidth()
                    .height(48.dp)
                    .clip(RoundedCornerShape(12.dp))
                    .background(if (selectedWorkout != null) Primary else Primary.copy(alpha = 0.3f))
                    .clickable(enabled = selectedWorkout != null) { onConfirm() },
                contentAlignment = Alignment.Center
            ) {
                val workoutName = selectedWorkout?.name
                Text(
                    if (workoutName != null) "Assign $workoutName" else "Select a workout",
                    fontSize = 16.sp,
                    fontWeight = FontWeight.SemiBold,
                    color = PrimaryInk
                )
            }
        }
    }
}
