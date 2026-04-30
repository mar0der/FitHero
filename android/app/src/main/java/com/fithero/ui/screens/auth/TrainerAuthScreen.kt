package com.fithero.ui.screens.auth

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
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.foundation.verticalScroll
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.automirrored.filled.ArrowBack
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
import com.fithero.ui.theme.Primary
import com.fithero.ui.theme.PrimaryInk
import com.fithero.ui.theme.Text
import com.fithero.ui.theme.TextMuted

@Composable
fun TrainerAuthScreen(
    isSignUpModeInitial: Boolean = true,
    onComplete: () -> Unit,
    onBack: () -> Unit,
    onForgotPassword: () -> Unit
) {
    var name by remember { mutableStateOf("") }
    var businessName by remember { mutableStateOf("") }
    var email by remember { mutableStateOf("") }
    var password by remember { mutableStateOf("") }
    var isSignUpMode by remember { mutableStateOf(isSignUpModeInitial) }

    Box(modifier = Modifier.fillMaxSize().background(Bg)) {
        Column(
            modifier = Modifier
                .fillMaxSize()
                .verticalScroll(rememberScrollState())
                .padding(horizontal = 16.dp)
        ) {
            Box(
                modifier = Modifier
                    .padding(top = 16.dp)
                    .size(40.dp)
                    .clip(RoundedCornerShape(10.dp))
                    .clickable { onBack() },
                contentAlignment = Alignment.Center
            ) {
                Icon(Icons.AutoMirrored.Filled.ArrowBack, contentDescription = null, tint = TextMuted)
            }

            Spacer(modifier = Modifier.height(24.dp))

            // Brand header
            Column(horizontalAlignment = Alignment.CenterHorizontally, modifier = Modifier.fillMaxWidth()) {
                Box(
                    modifier = Modifier
                        .size(64.dp)
                        .clip(RoundedCornerShape(16.dp))
                        .background(Primary),
                    contentAlignment = Alignment.Center
                ) {
                    Text("FH", fontSize = 22.sp, fontWeight = FontWeight.Black, color = PrimaryInk)
                }
                Spacer(modifier = Modifier.height(20.dp))
                Text(
                    if (isSignUpMode) "Create trainer account" else "Trainer sign in",
                    fontSize = 22.sp,
                    fontWeight = FontWeight.Bold,
                    color = Text
                )
                Spacer(modifier = Modifier.height(4.dp))
                Text(
                    if (isSignUpMode) "Start coaching on FitHero." else "Welcome back, coach.",
                    fontSize = 15.sp,
                    color = TextMuted
                )
            }

            Spacer(modifier = Modifier.height(32.dp))

            // Form
            Column(verticalArrangement = Arrangement.spacedBy(16.dp)) {
                if (isSignUpMode) {
                    AuthInputField(label = "Full name", value = name, onValueChange = { name = it }, placeholder = "Maya Johnson")
                    AuthInputField(label = "Business / Gym name", value = businessName, onValueChange = { businessName = it }, placeholder = "FitStudio Downtown")
                }
                AuthInputField(label = "Email", value = email, onValueChange = { email = it }, placeholder = "coach@fithero.com")
                AuthInputField(
                    label = "Password",
                    value = password,
                    onValueChange = { password = it },
                    placeholder = if (isSignUpMode) "Min 8 characters" else "Enter your password",
                    isSecure = true
                )
            }

            Spacer(modifier = Modifier.height(24.dp))

            Column(verticalArrangement = Arrangement.spacedBy(12.dp)) {
                Box(
                    modifier = Modifier
                        .fillMaxWidth()
                        .height(48.dp)
                        .clip(RoundedCornerShape(12.dp))
                        .background(Primary)
                        .clickable { onComplete() },
                    contentAlignment = Alignment.Center
                ) {
                    Text(
                        if (isSignUpMode) "Create account" else "Sign in",
                        fontSize = 16.sp,
                        fontWeight = FontWeight.SemiBold,
                        color = PrimaryInk
                    )
                }

                if (!isSignUpMode) {
                    Box(modifier = Modifier.fillMaxWidth(), contentAlignment = Alignment.Center) {
                        Text(
                            "Forgot password?",
                            fontSize = 14.sp,
                            fontWeight = FontWeight.Medium,
                            color = Accent,
                            modifier = Modifier.clickable { onForgotPassword() }
                        )
                    }
                }
            }

            Spacer(modifier = Modifier.height(20.dp))

            Row(
                modifier = Modifier.fillMaxWidth(),
                horizontalArrangement = Arrangement.Center,
                verticalAlignment = Alignment.CenterVertically
            ) {
                Text(
                    if (isSignUpMode) "Already have an account?" else "New to FitHero?",
                    fontSize = 15.sp,
                    color = TextMuted
                )
                Spacer(modifier = Modifier.height(4.dp))
                Text(
                    if (isSignUpMode) "Sign in" else "Create account",
                    fontSize = 15.sp,
                    fontWeight = FontWeight.SemiBold,
                    color = Primary,
                    modifier = Modifier.clickable { isSignUpMode = !isSignUpMode }
                )
            }

            Spacer(modifier = Modifier.height(32.dp))
        }
    }
}
