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
import androidx.compose.material.icons.automirrored.filled.Send
import androidx.compose.material.icons.filled.AccountCircle
import androidx.compose.material.icons.filled.Call
import androidx.compose.material.icons.filled.Close
import androidx.compose.material.icons.filled.DateRange
import androidx.compose.material.icons.filled.Edit
import androidx.compose.material.icons.filled.Email
import androidx.compose.material.icons.filled.ExitToApp
import androidx.compose.material.icons.filled.Home
import androidx.compose.material.icons.filled.Info
import androidx.compose.material.icons.filled.Notifications
import androidx.compose.material.icons.filled.Person
import androidx.compose.material.icons.filled.Settings
import androidx.compose.material3.Icon
import androidx.compose.material3.Switch
import androidx.compose.material3.SwitchDefaults
import androidx.compose.material3.Text
import androidx.compose.material3.TextField
import androidx.compose.material3.TextFieldDefaults
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.vector.ImageVector
import androidx.compose.ui.hapticfeedback.HapticFeedbackType
import androidx.compose.ui.platform.LocalHapticFeedback
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.fithero.ui.theme.Accent
import com.fithero.ui.theme.Bg
import com.fithero.ui.theme.Border
import com.fithero.ui.theme.Danger
import com.fithero.ui.theme.Primary
import com.fithero.ui.theme.PrimaryInk
import com.fithero.ui.theme.Success
import com.fithero.ui.theme.Surface
import com.fithero.ui.theme.Surface2
import com.fithero.ui.theme.Text
import com.fithero.ui.theme.TextMuted
import com.fithero.ui.theme.TextSubtle
import com.fithero.ui.theme.Warning

@Composable
fun ProfileSheet(
    onDismiss: () -> Unit,
    onSignOut: () -> Unit = {},
    onPayments: () -> Unit = {},
    onWorkoutHistory: () -> Unit = {}
) {
    val haptic = LocalHapticFeedback.current
    var name by remember { mutableStateOf("Alex Johnson") }
    var age by remember { mutableStateOf("28") }
    var height by remember { mutableStateOf("180") }
    var weight by remember { mutableStateOf("79.8") }
    var notifyWorkouts by remember { mutableStateOf(true) }
    var notifyMessages by remember { mutableStateOf(true) }
    var notifyProgress by remember { mutableStateOf(false) }

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
            // Top bar
            Row(
                modifier = Modifier.fillMaxWidth(),
                horizontalArrangement = Arrangement.SpaceBetween,
                verticalAlignment = Alignment.CenterVertically
            ) {
                Text("Profile", fontSize = 20.sp, fontWeight = FontWeight.Bold, color = Text)
                Box(
                    modifier = Modifier
                        .size(32.dp)
                        .clip(CircleShape)
                        .background(Surface2)
                        .clickable { onDismiss() },
                    contentAlignment = Alignment.Center
                ) {
                    Icon(Icons.Default.Close, contentDescription = null, tint = TextSubtle, modifier = Modifier.size(18.dp))
                }
            }

            Spacer(modifier = Modifier.height(20.dp))

            // Avatar header
            Column(
                modifier = Modifier
                    .fillMaxWidth()
                    .clip(RoundedCornerShape(16.dp))
                    .background(Surface)
                    .padding(24.dp),
                horizontalAlignment = Alignment.CenterHorizontally
            ) {
                Box(
                    modifier = Modifier
                        .size(88.dp)
                        .clip(CircleShape)
                        .background(Primary.copy(alpha = 0.15f)),
                    contentAlignment = Alignment.Center
                ) {
                    Text("A", fontSize = 32.sp, fontWeight = FontWeight.Bold, color = Primary)
                }
                Spacer(modifier = Modifier.height(12.dp))
                Text(name, fontSize = 20.sp, fontWeight = FontWeight.Bold, color = Text)
                Text("Starter — 2×/week", fontSize = 14.sp, color = TextMuted)
            }

            Spacer(modifier = Modifier.height(20.dp))

            // Personal info
            SectionTitle("PERSONAL INFO")
            Spacer(modifier = Modifier.height(8.dp))
            Column(verticalArrangement = Arrangement.spacedBy(8.dp)) {
                InfoField(icon = Icons.Default.Person, iconColor = Accent, label = "Name", value = name, onValueChange = { name = it })
                InfoField(icon = Icons.Default.DateRange, iconColor = Primary, label = "Age", value = age, onValueChange = { age = it })
                InfoField(icon = Icons.Default.Edit, iconColor = Warning, label = "Height (cm)", value = height, onValueChange = { height = it })
                InfoField(icon = Icons.Default.Info, iconColor = Success, label = "Weight (kg)", value = weight, onValueChange = { weight = it })
            }

            Spacer(modifier = Modifier.height(20.dp))

            // Account
            SectionTitle("ACCOUNT")
            Spacer(modifier = Modifier.height(8.dp))
            Column(verticalArrangement = Arrangement.spacedBy(8.dp)) {
                NavigationRow(icon = Icons.Default.AccountCircle, label = "Payments", onClick = onPayments)
                NavigationRow(icon = Icons.Default.DateRange, label = "Workout History", onClick = onWorkoutHistory)
            }

            Spacer(modifier = Modifier.height(20.dp))

            // Notifications
            SectionTitle("NOTIFICATIONS")
            Spacer(modifier = Modifier.height(8.dp))
            Column(verticalArrangement = Arrangement.spacedBy(8.dp)) {
                ToggleRow(icon = Icons.Default.Notifications, iconColor = Primary, title = "Workout Reminders", checked = notifyWorkouts, onCheckedChange = { notifyWorkouts = it })
                ToggleRow(icon = Icons.Default.Email, iconColor = Accent, title = "Messages", checked = notifyMessages, onCheckedChange = { notifyMessages = it })
                ToggleRow(icon = Icons.Default.AccountCircle, iconColor = Success, title = "Progress Updates", checked = notifyProgress, onCheckedChange = { notifyProgress = it })
            }

            Spacer(modifier = Modifier.height(20.dp))

            // Support
            SectionTitle("SUPPORT")
            Spacer(modifier = Modifier.height(8.dp))
            Column(verticalArrangement = Arrangement.spacedBy(8.dp)) {
                SupportRow(icon = Icons.Default.Call, label = "Help & Support")
                SupportRow(icon = Icons.Default.Info, label = "Terms & Privacy")
            }

            Spacer(modifier = Modifier.height(20.dp))

            // Sign out
            Row(
                modifier = Modifier
                    .fillMaxWidth()
                    .clip(RoundedCornerShape(16.dp))
                    .background(Surface)
                    .clickable {
                        haptic.performHapticFeedback(HapticFeedbackType.LongPress)
                        onSignOut()
                    }
                    .padding(16.dp),
                verticalAlignment = Alignment.CenterVertically
            ) {
                Icon(Icons.Default.ExitToApp, contentDescription = null, tint = Danger, modifier = Modifier.size(20.dp))
                Spacer(modifier = Modifier.width(12.dp))
                Text("Sign Out", fontSize = 15.sp, fontWeight = FontWeight.Medium, color = Danger)
            }
        }
    }
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
private fun InfoField(
    icon: ImageVector,
    iconColor: Color,
    label: String,
    value: String,
    onValueChange: (String) -> Unit
) {
    Row(
        modifier = Modifier
            .fillMaxWidth()
            .clip(RoundedCornerShape(16.dp))
            .background(Surface)
            .padding(12.dp),
        verticalAlignment = Alignment.CenterVertically
    ) {
        Box(
            modifier = Modifier
                .size(36.dp)
                .clip(RoundedCornerShape(10.dp))
                .background(iconColor.copy(alpha = 0.12f)),
            contentAlignment = Alignment.Center
        ) {
            Icon(icon, contentDescription = null, tint = iconColor, modifier = Modifier.size(16.dp))
        }
        Spacer(modifier = Modifier.width(12.dp))
        Text(label, fontSize = 15.sp, fontWeight = FontWeight.Medium, color = Text, modifier = Modifier.weight(1f))
        TextField(
            value = value,
            onValueChange = onValueChange,
            textStyle = androidx.compose.ui.text.TextStyle(fontSize = 15.sp, fontWeight = FontWeight.SemiBold, color = Primary),
            singleLine = true,
            colors = TextFieldDefaults.colors(
                focusedContainerColor = Color.Transparent,
                unfocusedContainerColor = Color.Transparent,
                focusedIndicatorColor = Color.Transparent,
                unfocusedIndicatorColor = Color.Transparent,
                cursorColor = Primary
            ),
            modifier = Modifier.width(80.dp)
        )
    }
}

@Composable
private fun ToggleRow(
    icon: ImageVector,
    iconColor: Color,
    title: String,
    checked: Boolean,
    onCheckedChange: (Boolean) -> Unit
) {
    Row(
        modifier = Modifier
            .fillMaxWidth()
            .clip(RoundedCornerShape(16.dp))
            .background(Surface)
            .padding(12.dp),
        verticalAlignment = Alignment.CenterVertically
    ) {
        Box(
            modifier = Modifier
                .size(36.dp)
                .clip(RoundedCornerShape(10.dp))
                .background(iconColor.copy(alpha = 0.12f)),
            contentAlignment = Alignment.Center
        ) {
            Icon(icon, contentDescription = null, tint = iconColor, modifier = Modifier.size(16.dp))
        }
        Spacer(modifier = Modifier.width(12.dp))
        Text(title, fontSize = 15.sp, fontWeight = FontWeight.Medium, color = Text, modifier = Modifier.weight(1f))
        Switch(
            checked = checked,
            onCheckedChange = onCheckedChange,
            colors = SwitchDefaults.colors(
                checkedThumbColor = PrimaryInk,
                checkedTrackColor = Primary,
                uncheckedThumbColor = TextMuted,
                uncheckedTrackColor = Surface2
            )
        )
    }
}

@Composable
private fun NavigationRow(icon: ImageVector, label: String, onClick: () -> Unit) {
    Row(
        modifier = Modifier
            .fillMaxWidth()
            .clip(RoundedCornerShape(16.dp))
            .background(Surface)
            .clickable(onClick = onClick)
            .padding(16.dp),
        verticalAlignment = Alignment.CenterVertically
    ) {
        Box(
            modifier = Modifier
                .size(36.dp)
                .clip(RoundedCornerShape(10.dp))
                .background(Primary.copy(alpha = 0.12f)),
            contentAlignment = Alignment.Center
        ) {
            Icon(icon, contentDescription = null, tint = Primary, modifier = Modifier.size(16.dp))
        }
        Spacer(modifier = Modifier.width(12.dp))
        Text(label, fontSize = 15.sp, fontWeight = FontWeight.Medium, color = Text, modifier = Modifier.weight(1f))
        Text("›", fontSize = 18.sp, color = TextSubtle)
    }
}

@Composable
private fun SupportRow(icon: ImageVector, label: String) {
    Row(
        modifier = Modifier
            .fillMaxWidth()
            .clip(RoundedCornerShape(16.dp))
            .background(Surface)
            .padding(16.dp),
        verticalAlignment = Alignment.CenterVertically
    ) {
        Box(
            modifier = Modifier
                .size(36.dp)
                .clip(RoundedCornerShape(10.dp))
                .background(TextMuted.copy(alpha = 0.12f)),
            contentAlignment = Alignment.Center
        ) {
            Icon(icon, contentDescription = null, tint = TextMuted, modifier = Modifier.size(16.dp))
        }
        Spacer(modifier = Modifier.width(12.dp))
        Text(label, fontSize = 15.sp, fontWeight = FontWeight.Medium, color = Text, modifier = Modifier.weight(1f))
        Icon(Icons.AutoMirrored.Filled.Send, contentDescription = null, tint = TextSubtle, modifier = Modifier.size(14.dp))
    }
}
