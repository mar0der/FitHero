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
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.CalendarToday
import androidx.compose.material.icons.filled.CheckCircle
import androidx.compose.material.icons.filled.Notifications
import androidx.compose.material.icons.filled.Person
import androidx.compose.material.icons.filled.Videocam
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
import com.fithero.ui.theme.Warning
import com.fithero.ui.theme.Surface
import com.fithero.ui.theme.Surface2
import com.fithero.ui.theme.Text
import com.fithero.ui.theme.TextMuted
import com.fithero.ui.theme.TextSubtle

@Composable
fun TrainerTodayScreen(modifier: Modifier = Modifier) {
    var showNotifications by remember { mutableStateOf(false) }
    val unreadCount = 3

    Box(modifier = modifier.fillMaxSize().background(Bg)) {
        Column(
            modifier = Modifier
                .fillMaxSize()
                .verticalScroll(rememberScrollState())
                .padding(16.dp)
        ) {
            // Header
            Row(
                modifier = Modifier.fillMaxWidth(),
                horizontalArrangement = Arrangement.SpaceBetween,
                verticalAlignment = Alignment.Top
            ) {
                Column {
                    Text("Today", fontSize = 28.sp, fontWeight = FontWeight.Bold, color = Text)
                    Text("Tuesday, 22 April", fontSize = 15.sp, color = TextMuted)
                }

                Box(
                    modifier = Modifier
                        .size(44.dp)
                        .clip(CircleShape)
                        .background(Surface2)
                        .clickable { showNotifications = true },
                    contentAlignment = Alignment.Center
                ) {
                    Icon(Icons.Default.Notifications, contentDescription = null, tint = TextMuted, modifier = Modifier.size(18.dp))
                    if (unreadCount > 0) {
                        Box(
                            modifier = Modifier
                                .size(18.dp)
                                .clip(CircleShape)
                                .background(Primary)
                                .align(Alignment.TopEnd),
                            contentAlignment = Alignment.Center
                        ) {
                            Text("$unreadCount", fontSize = 10.sp, fontWeight = FontWeight.Bold, color = PrimaryInk)
                        }
                    }
                }
            }

            Spacer(modifier = Modifier.height(24.dp))

            // Sessions
            Column(
                modifier = Modifier
                    .fillMaxWidth()
                    .clip(RoundedCornerShape(16.dp))
                    .background(Surface)
                    .padding(16.dp)
            ) {
                Row(modifier = Modifier.fillMaxWidth(), horizontalArrangement = Arrangement.SpaceBetween) {
                    Text("SESSIONS", fontSize = 12.sp, fontWeight = FontWeight.SemiBold, color = TextSubtle, letterSpacing = 1.2.sp)
                    Text("3 scheduled", fontSize = 13.sp, fontWeight = FontWeight.Medium, color = TextMuted)
                }
                Spacer(modifier = Modifier.height(12.dp))

                SessionRow("Alex Johnson", "09:00", "In-person", "60 min", "FitStudio Downtown", Accent, true)
                Spacer(modifier = Modifier.height(8.dp))
                SessionRow("Marco Rossi", "11:30", "Video call", "30 min", null, Primary, false)
                Spacer(modifier = Modifier.height(8.dp))
                SessionRow("Erika Szabo", "16:00", "Check-in", "15 min", null, Success, false)
            }

            Spacer(modifier = Modifier.height(20.dp))

            // Quick stats
            Column(
                modifier = Modifier
                    .fillMaxWidth()
                    .clip(RoundedCornerShape(16.dp))
                    .background(Surface)
                    .padding(16.dp)
            ) {
                Text("QUICK STATS", fontSize = 12.sp, fontWeight = FontWeight.SemiBold, color = TextSubtle, letterSpacing = 1.2.sp)
                Spacer(modifier = Modifier.height(12.dp))
                Row(horizontalArrangement = Arrangement.spacedBy(8.dp)) {
                    StatTile("18", "Active clients", Icons.Default.Person, false, Modifier.weight(1f))
                    StatTile("3", "Today", Icons.Default.CalendarToday, true, Modifier.weight(1f))
                    StatTile("$2,340", "This week", Icons.Default.CheckCircle, false, Modifier.weight(1f))
                }
            }

            Spacer(modifier = Modifier.height(32.dp))
        }

        if (showNotifications) {
            NotificationsSheet(onDismiss = { showNotifications = false })
        }
    }
}

@Composable
private fun SessionRow(
    name: String,
    time: String,
    type: String,
    duration: String,
    location: String?,
    iconColor: androidx.compose.ui.graphics.Color,
    isNext: Boolean
) {
    Row(
        modifier = Modifier
            .fillMaxWidth()
            .clip(RoundedCornerShape(12.dp))
            .background(Surface2)
            .border(1.dp, if (isNext) Primary.copy(alpha = 0.35f) else Border, RoundedCornerShape(12.dp))
            .padding(12.dp),
        verticalAlignment = Alignment.CenterVertically
    ) {
        Box(
            modifier = Modifier
                .size(44.dp)
                .clip(RoundedCornerShape(10.dp))
                .background(iconColor.copy(alpha = 0.15f)),
            contentAlignment = Alignment.Center
        ) {
            val icon = when (type) {
                "In-person" -> Icons.Default.Person
                "Video call" -> Icons.Default.Videocam
                else -> Icons.Default.CheckCircle
            }
            Icon(icon, contentDescription = null, tint = iconColor, modifier = Modifier.size(18.dp))
        }
        Spacer(modifier = Modifier.width(12.dp))
        Column(modifier = Modifier.weight(1f)) {
            Text(name, fontSize = 15.sp, fontWeight = FontWeight.SemiBold, color = Text)
            Row {
                Text("$time · $type · $duration", fontSize = 13.sp, color = TextMuted)
            }
            location?.let { Text(it, fontSize = 12.sp, color = TextSubtle) }
        }
        if (isNext) {
            Box(
                modifier = Modifier
                    .clip(CircleShape)
                    .background(Primary)
                    .padding(horizontal = 10.dp, vertical = 4.dp)
            ) {
                Text("Next", fontSize = 11.sp, fontWeight = FontWeight.Bold, color = PrimaryInk)
            }
        }
    }
}

@Composable
private fun StatTile(value: String, label: String, icon: androidx.compose.ui.graphics.vector.ImageVector, accent: Boolean, modifier: Modifier = Modifier) {
    Column(
        modifier = modifier
            .clip(RoundedCornerShape(12.dp))
            .background(Surface2)
            .border(1.dp, if (accent) Primary.copy(alpha = 0.3f) else Border, RoundedCornerShape(12.dp))
            .padding(12.dp),
        horizontalAlignment = Alignment.CenterHorizontally
    ) {
        Icon(icon, contentDescription = null, tint = if (accent) Primary else TextMuted, modifier = Modifier.size(16.dp))
        Spacer(modifier = Modifier.height(6.dp))
        Text(value, fontSize = 20.sp, fontWeight = FontWeight.Bold, color = if (accent) Primary else Text)
        Text(label.uppercase(), fontSize = 9.sp, fontWeight = FontWeight.Medium, color = TextSubtle, letterSpacing = 0.6.sp)
    }
}

private data class NotifItem(val title: String, val detail: String, val time: String, val iconLabel: String, val color: androidx.compose.ui.graphics.Color)

@Composable
private fun NotificationsSheet(onDismiss: () -> Unit) {
    val notifications = listOf(
        NotifItem("Workout completed", "Alex finished Upper Body Strength", "10m ago", "✓", Success),
        NotifItem("Payment received", "Marco paid $320 for April sessions", "1h ago", "$", Primary),
        NotifItem("New message", "Erika: 'Hit a new PR on deadlifts'", "3h ago", "✉", Accent),
        NotifItem("Session reminder", "Alex in-person at 09:00 tomorrow", "5h ago", "⏰", Warning),
        NotifItem("Client paused", "Sam paused their subscription", "2d ago", "⏸", TextSubtle)
    )

    Box(
        modifier = Modifier
            .fillMaxSize()
            .background(Bg.copy(alpha = 0.95f))
            .clickable(onClick = onDismiss),
        contentAlignment = Alignment.TopCenter
    ) {
        Column(
            modifier = Modifier
                .fillMaxWidth(0.92f)
                .fillMaxSize()
                .clickable(enabled = false) { }
                .verticalScroll(rememberScrollState())
                .padding(top = 16.dp, bottom = 32.dp)
        ) {
            // Handle
            Box(modifier = Modifier.fillMaxWidth(), contentAlignment = Alignment.Center) {
                Box(modifier = Modifier.width(38.dp).height(5.dp).clip(RoundedCornerShape(100.dp)).background(Text.copy(alpha = 0.2f)))
            }
            Spacer(modifier = Modifier.height(12.dp))

            Row(modifier = Modifier.fillMaxWidth(), horizontalArrangement = Arrangement.SpaceBetween, verticalAlignment = Alignment.CenterVertically) {
                Column {
                    Text("Notifications", fontSize = 24.sp, fontWeight = FontWeight.Bold, color = Text)
                    Text("${notifications.size} recent", fontSize = 14.sp, color = TextMuted)
                }
                Text("Mark all read", fontSize = 13.sp, fontWeight = FontWeight.Medium, color = Primary, modifier = Modifier.clickable { })
            }
            Spacer(modifier = Modifier.height(20.dp))

            Column(
                modifier = Modifier
                    .fillMaxWidth()
                    .clip(RoundedCornerShape(16.dp))
                    .background(Surface)
                    .padding(vertical = 4.dp)
            ) {
                notifications.forEachIndexed { idx, notif ->
                    Row(
                        modifier = Modifier
                            .fillMaxWidth()
                            .padding(14.dp),
                        verticalAlignment = Alignment.CenterVertically
                    ) {
                        Box(
                            modifier = Modifier
                                .size(40.dp)
                                .clip(RoundedCornerShape(10.dp))
                                .background(notif.color.copy(alpha = 0.15f)),
                            contentAlignment = Alignment.Center
                        ) {
                            Text(notif.iconLabel, fontSize = 16.sp, color = notif.color)
                        }
                        Spacer(modifier = Modifier.width(12.dp))
                        Column(modifier = Modifier.weight(1f)) {
                            Row(modifier = Modifier.fillMaxWidth(), horizontalArrangement = Arrangement.SpaceBetween) {
                                Text(notif.title, fontSize = 15.sp, fontWeight = FontWeight.SemiBold, color = Text)
                                Text(notif.time, fontSize = 12.sp, color = TextSubtle)
                            }
                            Text(notif.detail, fontSize = 13.sp, color = TextMuted, maxLines = 2)
                        }
                    }
                    if (idx < notifications.size - 1) {
                        Spacer(modifier = Modifier.height(1.dp).fillMaxWidth().padding(start = 60.dp).background(Border))
                    }
                }
            }
        }
    }
}
