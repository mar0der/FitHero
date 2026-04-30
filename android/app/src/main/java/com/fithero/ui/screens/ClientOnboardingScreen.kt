@file:OptIn(ExperimentalLayoutApi::class)
package com.fithero.ui.screens

import androidx.compose.foundation.layout.FlowRow
import androidx.compose.animation.*
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.foundation.verticalScroll
import androidx.compose.material.icons.Icons
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.focus.FocusManager
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.platform.LocalFocusManager
import androidx.compose.ui.platform.LocalSoftwareKeyboardController
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp

// ------------------------------------------------------------------
// Screen
// ------------------------------------------------------------------

private class OnboardingState {
    val goals = mutableStateListOf<String>()
    var experience by mutableStateOf("")
    var frequency by mutableStateOf("")
    val workoutTypes = mutableStateListOf<String>()
    val equipment = mutableStateListOf<String>()
    var bio by mutableStateOf("")
}

@Composable
fun ClientOnboardingScreen(onComplete: () -> Unit) {
    var step by remember { mutableIntStateOf(0) }
    val state = remember { OnboardingState() }
    val bg = Color(0xFF0B0D10)
    val voltGreen = Color(0xFFC6FF3D)
    val surface = Color(0xFF14181D)

    val totalSteps = 7
    val progress = (step + 1).toFloat() / totalSteps

    Box(modifier = Modifier.fillMaxSize().background(bg)) {
        Column(modifier = Modifier.fillMaxSize().imePadding()) {
            // Progress bar
            if (step > 0) {
                LinearProgressIndicator(
                    progress = { progress },
                    modifier = Modifier.fillMaxWidth().height(3.dp),
                    color = voltGreen,
                    trackColor = Color(0xFF2A2F35),
                )
            }
            // Content
            AnimatedContent(
                targetState = step,
                transitionSpec = {
                    (slideInHorizontally { it } + fadeIn()).togetherWith(
                        slideOutHorizontally { -it } + fadeOut()
                    )
                },
                modifier = Modifier.weight(1f)
            ) { currentStep ->
                when (currentStep) {
                    0 -> WelcomeStep(bg, voltGreen) { step = 1 }
                    1 -> GoalsStep(state, surface, voltGreen)
                    2 -> ExperienceStep(state, surface, voltGreen)
                    3 -> FrequencyStep(state, surface, voltGreen)
                    4 -> WorkoutTypesStep(state, surface, voltGreen)
                    5 -> EquipmentStep(state, surface, voltGreen)
                    6 -> ProfileStep(state, surface, voltGreen)
                }
            }
            // Bottom button
            if (step > 0) {
                val focusManager = LocalFocusManager.current
                val keyboardController = LocalSoftwareKeyboardController.current
                Button(
                    onClick = {
                        focusManager.clearFocus()
                        keyboardController?.hide()
                        if (step < totalSteps - 1) step++ else onComplete()
                    },
                    colors = ButtonDefaults.buttonColors(containerColor = voltGreen, contentColor = Color.Black),
                    shape = RoundedCornerShape(10.dp),
                    modifier = Modifier.fillMaxWidth().padding(16.dp)
                ) {
                    Text(if (step == totalSteps - 1) "Finish" else "Continue", fontSize = 16.sp, modifier = Modifier.padding(vertical = 4.dp))
                }
            }
        }
    }
}

// ------------------------------------------------------------------
// Step 0: Welcome
// ------------------------------------------------------------------

@Composable
private fun WelcomeStep(bg: Color, voltGreen: Color, onStart: () -> Unit) {
    Column(
        modifier = Modifier.fillMaxSize().padding(32.dp),
        verticalArrangement = Arrangement.Center,
        horizontalAlignment = Alignment.CenterHorizontally
    ) {
        Box(
            modifier = Modifier.size(80.dp).clip(CircleShape).background(voltGreen),
            contentAlignment = Alignment.Center
        ) {
            Text("F", color = Color.Black, fontSize = 36.sp, fontWeight = FontWeight.ExtraBold)
        }
        Spacer(Modifier.height(24.dp))
        Text("Welcome to FitHero", color = Color.White, fontSize = 28.sp, fontWeight = FontWeight.Bold, textAlign = TextAlign.Center)
        Spacer(Modifier.height(12.dp))
        Text("Let's personalize your fitness journey. A few quick questions and you'll be ready to crush your goals.",
            color = Color.Gray, fontSize = 14.sp, textAlign = TextAlign.Center, lineHeight = 20.sp)
        Spacer(Modifier.height(32.dp))
        Button(
            onClick = onStart,
            colors = ButtonDefaults.buttonColors(containerColor = voltGreen, contentColor = Color.Black),
            shape = RoundedCornerShape(10.dp),
            modifier = Modifier.fillMaxWidth()
        ) {
            Text("Get Started", fontSize = 16.sp, modifier = Modifier.padding(vertical = 4.dp))
        }
    }
}

// ------------------------------------------------------------------
// Step 1: Goals
// ------------------------------------------------------------------

@Composable
private fun GoalsStep(state: OnboardingState, surface: Color, voltGreen: Color) {
    val options = listOf("Lose Weight", "Build Muscle", "Improve Endurance", "Increase Strength", "General Fitness", "Athletic Performance")
    StepContainer("What are your fitness goals?", "Select all that apply") {
        FlowRow(horizontalArrangement = Arrangement.spacedBy(8.dp), verticalArrangement = Arrangement.spacedBy(8.dp)) {
            options.forEach { opt ->
                val selected = opt in state.goals
                FilterChip(
                    selected = selected,
                    onClick = {
                        if (selected) state.goals.remove(opt) else state.goals.add(opt)
                    },
                    label = { Text(opt, fontSize = 13.sp) },
                    colors = FilterChipDefaults.filterChipColors(
                        selectedContainerColor = voltGreen,
                        selectedLabelColor = Color.Black,
                        containerColor = surface,
                        labelColor = Color.LightGray
                    ),
                    shape = RoundedCornerShape(8.dp)
                )
            }
        }
    }
}

// ------------------------------------------------------------------
// Step 2: Experience
// ------------------------------------------------------------------

@Composable
private fun ExperienceStep(state: OnboardingState, surface: Color, voltGreen: Color) {
    val options = listOf(
        "Beginner" to "New to training, learning the basics",
        "Intermediate" to "Some experience, consistent for 6-12 months",
        "Advanced" to "Years of training, comfortable with complex movements"
    )
    StepContainer("What's your experience level?", "Select one") {
        Column(verticalArrangement = Arrangement.spacedBy(10.dp)) {
            options.forEach { (title, desc) ->
                val selected = state.experience == title
                Surface(
                    onClick = { state.experience = title },
                    color = if (selected) Color(0xFF1A3D1A) else surface,
                    shape = RoundedCornerShape(12.dp),
                    modifier = Modifier.fillMaxWidth()
                ) {
                    Column(modifier = Modifier.padding(16.dp)) {
                        Text(title, color = if (selected) voltGreen else Color.White, fontSize = 15.sp, fontWeight = FontWeight.SemiBold)
                        Text(desc, color = Color.Gray, fontSize = 12.sp)
                    }
                }
            }
        }
    }
}

// ------------------------------------------------------------------
// Step 3: Frequency
// ------------------------------------------------------------------

@Composable
private fun FrequencyStep(state: OnboardingState, surface: Color, voltGreen: Color) {
    val options = listOf("1-2 days/week", "3-4 days/week", "5-6 days/week", "Daily")
    StepContainer("How often do you want to train?", "Select one") {
        Column(verticalArrangement = Arrangement.spacedBy(10.dp)) {
            options.forEach { opt ->
                val selected = state.frequency == opt
                Surface(
                    onClick = { state.frequency = opt },
                    color = if (selected) Color(0xFF1A3D1A) else surface,
                    shape = RoundedCornerShape(12.dp),
                    modifier = Modifier.fillMaxWidth()
                ) {
                    Row(
                        modifier = Modifier.padding(16.dp),
                        horizontalArrangement = Arrangement.SpaceBetween,
                        verticalAlignment = Alignment.CenterVertically
                    ) {
                        Text(opt, color = if (selected) voltGreen else Color.White, fontSize = 15.sp, fontWeight = FontWeight.SemiBold)
                        if (selected) Text("✓", color = voltGreen, fontSize = 18.sp, fontWeight = FontWeight.Bold)
                    }
                }
            }
        }
    }
}

// ------------------------------------------------------------------
// Step 4: Workout Types
// ------------------------------------------------------------------

@Composable
private fun WorkoutTypesStep(state: OnboardingState, surface: Color, voltGreen: Color) {
    val options = listOf("Strength Training", "HIIT / Cardio", "Yoga / Mobility", "Calisthenics", "Sports / CrossFit", "Mixed")
    StepContainer("What workout types do you prefer?", "Select all that apply") {
        FlowRow(horizontalArrangement = Arrangement.spacedBy(8.dp), verticalArrangement = Arrangement.spacedBy(8.dp)) {
            options.forEach { opt ->
                val selected = opt in state.workoutTypes
                FilterChip(
                    selected = selected,
                    onClick = {
                        if (selected) state.workoutTypes.remove(opt) else state.workoutTypes.add(opt)
                    },
                    label = { Text(opt, fontSize = 13.sp) },
                    colors = FilterChipDefaults.filterChipColors(
                        selectedContainerColor = voltGreen,
                        selectedLabelColor = Color.Black,
                        containerColor = surface,
                        labelColor = Color.LightGray
                    ),
                    shape = RoundedCornerShape(8.dp)
                )
            }
        }
    }
}

// ------------------------------------------------------------------
// Step 5: Equipment
// ------------------------------------------------------------------

@Composable
private fun EquipmentStep(state: OnboardingState, surface: Color, voltGreen: Color) {
    val options = listOf("Full Gym", "Dumbbells Only", "Bodyweight", "Resistance Bands", "Kettlebells", "Home Gym (Basic)")
    StepContainer("What equipment do you have access to?", "Select all that apply") {
        FlowRow(horizontalArrangement = Arrangement.spacedBy(8.dp), verticalArrangement = Arrangement.spacedBy(8.dp)) {
            options.forEach { opt ->
                val selected = opt in state.equipment
                FilterChip(
                    selected = selected,
                    onClick = {
                        if (selected) state.equipment.remove(opt) else state.equipment.add(opt)
                    },
                    label = { Text(opt, fontSize = 13.sp) },
                    colors = FilterChipDefaults.filterChipColors(
                        selectedContainerColor = voltGreen,
                        selectedLabelColor = Color.Black,
                        containerColor = surface,
                        labelColor = Color.LightGray
                    ),
                    shape = RoundedCornerShape(8.dp)
                )
            }
        }
    }
}

// ------------------------------------------------------------------
// Step 6: Profile
// ------------------------------------------------------------------

@OptIn(ExperimentalMaterial3Api::class)
@Composable
private fun ProfileStep(state: OnboardingState, surface: Color, voltGreen: Color) {
    val focusManager = LocalFocusManager.current
    val keyboardController = LocalSoftwareKeyboardController.current
    StepContainer("Almost done!", "Add a quick bio (optional)") {
        OutlinedTextField(
            value = state.bio,
            onValueChange = { state.bio = it },
            label = { Text("Tell us about yourself") },
            minLines = 3,
            maxLines = 5,
            keyboardOptions = androidx.compose.foundation.text.KeyboardOptions(imeAction = androidx.compose.ui.text.input.ImeAction.Done),
            keyboardActions = androidx.compose.foundation.text.KeyboardActions(
                onDone = {
                    focusManager.clearFocus()
                    keyboardController?.hide()
                }
            ),
            colors = OutlinedTextFieldDefaults.colors(
                focusedBorderColor = voltGreen,
                unfocusedBorderColor = Color(0xFF2A2F35),
                focusedLabelColor = voltGreen,
                unfocusedLabelColor = Color.Gray,
                focusedTextColor = Color.White,
                unfocusedTextColor = Color.White,
                cursorColor = voltGreen,
                focusedContainerColor = Color(0xFF0B0D10),
                unfocusedContainerColor = Color(0xFF0B0D10),
            ),
            modifier = Modifier.fillMaxWidth()
        )
        Spacer(Modifier.height(12.dp))
        Text("This helps your trainer understand your background.", color = Color.Gray, fontSize = 12.sp)
    }
}

// ------------------------------------------------------------------
// Shared
// ------------------------------------------------------------------

@Composable
private fun StepContainer(title: String, subtitle: String, content: @Composable ColumnScope.() -> Unit) {
    Column(
        modifier = Modifier
            .fillMaxSize()
            .verticalScroll(rememberScrollState())
            .padding(20.dp)
    ) {
        Text(title, color = Color.White, fontSize = 22.sp, fontWeight = FontWeight.Bold)
        Spacer(Modifier.height(4.dp))
        Text(subtitle, color = Color.Gray, fontSize = 14.sp)
        Spacer(Modifier.height(20.dp))
        content()
    }
}


