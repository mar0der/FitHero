package com.fithero

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
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.automirrored.filled.Chat
import androidx.compose.material.icons.automirrored.filled.List
import androidx.compose.material.icons.automirrored.filled.Message
import androidx.compose.material.icons.filled.CalendarToday
import androidx.compose.material.icons.filled.DateRange
import androidx.compose.material.icons.filled.FitnessCenter
import androidx.compose.material.icons.filled.Home
import androidx.compose.material.icons.filled.Notifications
import androidx.compose.material.icons.filled.People
import androidx.compose.material.icons.filled.Settings
import androidx.compose.material.icons.filled.ShowChart
import androidx.compose.material3.Button
import androidx.compose.material3.ButtonDefaults
import androidx.compose.material3.Icon
import androidx.compose.material3.NavigationBar
import androidx.compose.material3.NavigationBarItem
import androidx.compose.material3.Scaffold
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableIntStateOf
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.saveable.rememberSaveable
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.vector.ImageVector
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.fithero.ui.screens.HomeScreen
import com.fithero.ui.screens.MessagesScreen
import com.fithero.ui.screens.ProgressScreen
import com.fithero.ui.screens.ScheduleScreen
import com.fithero.ui.screens.WorkoutScreen
import com.fithero.ui.screens.trainer.TrainerClientsScreen
import com.fithero.ui.screens.trainer.TrainerLibraryScreen
import com.fithero.ui.screens.trainer.TrainerMessagesScreen
import com.fithero.ui.screens.trainer.TrainerSettingsScreen
import com.fithero.ui.screens.trainer.TrainerTodayScreen
import com.fithero.ui.theme.Bg
import com.fithero.ui.theme.Border
import com.fithero.ui.theme.Primary
import com.fithero.ui.theme.PrimaryInk
import com.fithero.ui.theme.Surface
import com.fithero.ui.theme.Surface2
import com.fithero.ui.theme.Text
import com.fithero.ui.theme.TextMuted
import com.fithero.ui.theme.TextSubtle

enum class Role { Trainer, Client }

@Composable
fun FitHeroApp() {
    var role by rememberSaveable { mutableStateOf<Role?>(null) }

    when (role) {
        null -> RolePickerScreen(onPick = { role = it })
        Role.Client -> ClientApp(onSwitchRole = { role = null })
        Role.Trainer -> TrainerApp(onSwitchRole = { role = null })
    }
}

// ---------- Role Picker (1:1 with iOS) ----------

@Composable
private fun RolePickerScreen(onPick: (Role) -> Unit) {
    Column(
        modifier = Modifier
            .fillMaxSize()
            .background(Bg)
            .padding(24.dp),
        verticalArrangement = Arrangement.Center,
        horizontalAlignment = Alignment.CenterHorizontally
    ) {
        Spacer(modifier = Modifier.weight(1f))

        // FH Logo
        Column(horizontalAlignment = Alignment.CenterHorizontally) {
            Box(
                modifier = Modifier
                    .size(64.dp)
                    .clip(RoundedCornerShape(16.dp))
                    .background(Primary),
                contentAlignment = Alignment.Center
            ) {
                Text("FH", fontSize = 22.sp, fontWeight = FontWeight.Black, color = PrimaryInk)
            }
            Spacer(modifier = Modifier.height(16.dp))
            Text("FitHero", fontSize = 36.sp, fontWeight = FontWeight.Bold, color = Text, letterSpacing = (-1).sp)
        }

        Spacer(modifier = Modifier.weight(1f))

        // Buttons
        Column(
            modifier = Modifier.fillMaxWidth(),
            verticalArrangement = Arrangement.spacedBy(10.dp)
        ) {
            Button(
                onClick = { onPick(Role.Trainer) },
                modifier = Modifier.fillMaxWidth(),
                colors = ButtonDefaults.buttonColors(containerColor = Primary, contentColor = PrimaryInk),
                shape = RoundedCornerShape(12.dp)
            ) {
                Text("Trainer", fontSize = 16.sp, fontWeight = FontWeight.SemiBold, modifier = Modifier.padding(vertical = 6.dp))
            }

            Button(
                onClick = { onPick(Role.Client) },
                modifier = Modifier.fillMaxWidth(),
                colors = ButtonDefaults.buttonColors(containerColor = Surface2, contentColor = TextMuted),
                shape = RoundedCornerShape(12.dp)
            ) {
                Text("Hero", fontSize = 16.sp, fontWeight = FontWeight.SemiBold, modifier = Modifier.padding(vertical = 6.dp))
            }

            Text(
                "DEMO · NO AUTH",
                fontSize = 11.sp,
                color = TextSubtle,
                letterSpacing = 1.2.sp,
                modifier = Modifier.align(Alignment.CenterHorizontally).padding(top = 8.dp)
            )
        }
    }
}

// ---------- Floating Role Badge ----------

@Composable
private fun AppSessionBadge(role: Role, onExit: () -> Unit, modifier: Modifier = Modifier) {
    Box(
        modifier = modifier
            .padding(top = 12.dp, end = 16.dp)
    ) {
        Row(
            modifier = Modifier
                .clip(RoundedCornerShape(999.dp))
                .background(Surface)
                .border(1.dp, Border, RoundedCornerShape(999.dp))
                .clickable(onClick = onExit)
                .padding(horizontal = 12.dp, vertical = 8.dp),
            verticalAlignment = Alignment.CenterVertically,
            horizontalArrangement = Arrangement.spacedBy(6.dp)
        ) {
            Text(
                if (role == Role.Trainer) "Trainer" else "Hero",
                fontSize = 12.sp,
                fontWeight = FontWeight.SemiBold,
                color = TextMuted
            )
            Text("⇄", fontSize = 12.sp, fontWeight = FontWeight.Bold, color = Primary)
        }
    }
}

// ---------- Client App ----------

private val clientScreens = listOf(
    Screen("home", "Home", Icons.Filled.Home),
    Screen("workout", "Workout", Icons.Filled.FitnessCenter),
    Screen("progress", "Progress", Icons.Filled.ShowChart),
    Screen("schedule", "Schedule", Icons.Filled.CalendarToday),
    Screen("messages", "Messages", Icons.AutoMirrored.Filled.Message)
)

@Composable
private fun ClientApp(onSwitchRole: () -> Unit) {
    var selectedIndex by rememberSaveable { mutableIntStateOf(0) }

    Box(modifier = Modifier.fillMaxSize()) {
        Scaffold(
            bottomBar = {
                NavigationBar(containerColor = Surface2) {
                    clientScreens.forEachIndexed { index, screen ->
                        NavigationBarItem(
                            icon = { Icon(screen.icon, contentDescription = screen.label) },
                            label = { Text(screen.label) },
                            selected = selectedIndex == index,
                            onClick = { selectedIndex = index },
                            alwaysShowLabel = true,
                            colors = androidx.compose.material3.NavigationBarItemDefaults.colors(
                                selectedIconColor = Primary,
                                selectedTextColor = Primary,
                                unselectedIconColor = TextMuted,
                                unselectedTextColor = TextMuted,
                                indicatorColor = androidx.compose.ui.graphics.Color.Transparent
                            )
                        )
                    }
                }
            }
        ) { innerPadding ->
            when (selectedIndex) {
                0 -> HomeScreen(modifier = Modifier.padding(innerPadding), onStartWorkout = { selectedIndex = 1 }, onSignOut = onSwitchRole)
                1 -> WorkoutScreen(modifier = Modifier.padding(innerPadding))
                2 -> ProgressScreen(modifier = Modifier.padding(innerPadding))
                3 -> ScheduleScreen(modifier = Modifier.padding(innerPadding))
                4 -> MessagesScreen(modifier = Modifier.padding(innerPadding))
            }
        }

    }
}

// ---------- Trainer App ----------

private val trainerScreens = listOf(
    Screen("today", "Today", Icons.Filled.DateRange),
    Screen("clients", "Clients", Icons.Filled.People),
    Screen("library", "Library", Icons.AutoMirrored.Filled.List),
    Screen("messages", "Messages", Icons.AutoMirrored.Filled.Message),
    Screen("settings", "Settings", Icons.Filled.Settings)
)

@Composable
private fun TrainerApp(onSwitchRole: () -> Unit) {
    var selectedIndex by rememberSaveable { mutableIntStateOf(0) }

    Box(modifier = Modifier.fillMaxSize()) {
        Scaffold(
            bottomBar = {
                NavigationBar(containerColor = Surface2) {
                    trainerScreens.forEachIndexed { index, screen ->
                        NavigationBarItem(
                            icon = { Icon(screen.icon, contentDescription = screen.label) },
                            label = { Text(screen.label) },
                            selected = selectedIndex == index,
                            onClick = { selectedIndex = index },
                            alwaysShowLabel = true,
                            colors = androidx.compose.material3.NavigationBarItemDefaults.colors(
                                selectedIconColor = Primary,
                                selectedTextColor = Primary,
                                unselectedIconColor = TextMuted,
                                unselectedTextColor = TextMuted,
                                indicatorColor = androidx.compose.ui.graphics.Color.Transparent
                            )
                        )
                    }
                }
            }
        ) { innerPadding ->
            when (selectedIndex) {
                0 -> TrainerTodayScreen(modifier = Modifier.padding(innerPadding))
                1 -> TrainerClientsScreen(modifier = Modifier.padding(innerPadding))
                2 -> TrainerLibraryScreen(modifier = Modifier.padding(innerPadding))
                3 -> TrainerMessagesScreen(modifier = Modifier.padding(innerPadding))
                4 -> TrainerSettingsScreen(modifier = Modifier.padding(innerPadding), onSignOut = onSwitchRole)
            }
        }

    }
}

private data class Screen(val route: String, val label: String, val icon: ImageVector)
