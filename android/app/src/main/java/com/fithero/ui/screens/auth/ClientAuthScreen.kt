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
import androidx.compose.foundation.shape.CircleShape
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
import com.fithero.ui.theme.Border
import com.fithero.ui.theme.Primary
import com.fithero.ui.theme.PrimaryInk
import com.fithero.ui.theme.Surface2
import com.fithero.ui.theme.Text
import com.fithero.ui.theme.TextMuted
import com.fithero.ui.theme.TextSubtle

@Composable
fun ClientAuthScreen(
    onComplete: (Boolean) -> Unit,
    onBack: () -> Unit,
    onForgotPassword: () -> Unit
) {
    var inviteCode by remember { mutableStateOf("") }
    var hasValidatedInvite by remember { mutableStateOf(true) }
    var email by remember { mutableStateOf("") }
    var password by remember { mutableStateOf("") }
    var isSignUpMode by remember { mutableStateOf(true) }

    val trainerName = "Maya"
    val trainerInitial = "M"
    val inviteMessage = "I'd love to help you reach your fitness goals. Let's get started."

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

            if (hasValidatedInvite) {
                // Invite header
                Column(horizontalAlignment = Alignment.CenterHorizontally, modifier = Modifier.fillMaxWidth()) {
                    Box(
                        modifier = Modifier
                            .size(80.dp)
                            .clip(CircleShape)
                            .background(Primary.copy(alpha = 0.15f)),
                        contentAlignment = Alignment.Center
                    ) {
                        Text(trainerInitial, fontSize = 32.sp, fontWeight = FontWeight.Bold, color = Primary)
                    }
                    Spacer(modifier = Modifier.height(20.dp))
                    Text("$trainerName invited you", fontSize = 22.sp, fontWeight = FontWeight.Bold, color = Text)
                    Spacer(modifier = Modifier.height(4.dp))
                    Text("to train together on FitHero", fontSize = 15.sp, color = TextMuted)
                    Spacer(modifier = Modifier.height(12.dp))
                    Text(
                        inviteMessage,
                        fontSize = 15.sp,
                        color = TextMuted,
                        lineHeight = 20.sp,
                        modifier = Modifier.padding(horizontal = 16.dp)
                    )
                }
            } else {
                // Invite code section
                Column(horizontalAlignment = Alignment.CenterHorizontally, modifier = Modifier.fillMaxWidth()) {
                    Text("Welcome to FitHero", fontSize = 28.sp, fontWeight = FontWeight.Bold, color = Text)
                    Spacer(modifier = Modifier.height(8.dp))
                    Text("Enter your invite code to get started", fontSize = 15.sp, color = TextMuted)
                    Spacer(modifier = Modifier.height(24.dp))
                    AuthInputField(
                        label = "Invite code",
                        value = inviteCode,
                        onValueChange = { inviteCode = it },
                        placeholder = "ABC-123-XYZ"
                    )
                    Spacer(modifier = Modifier.height(16.dp))
                    Box(
                        modifier = Modifier
                            .fillMaxWidth()
                            .height(48.dp)
                            .clip(RoundedCornerShape(12.dp))
                            .background(Primary)
                            .clickable { hasValidatedInvite = true },
                        contentAlignment = Alignment.Center
                    ) {
                        Text("Validate invite", fontSize = 16.sp, fontWeight = FontWeight.SemiBold, color = PrimaryInk)
                    }
                }
            }

            Spacer(modifier = Modifier.height(32.dp))

            // Auth form
            Column(verticalArrangement = Arrangement.spacedBy(16.dp)) {
                AuthInputField(label = "Email", value = email, onValueChange = { email = it }, placeholder = "alex@example.com")
                AuthInputField(label = "Password", value = password, onValueChange = { password = it }, placeholder = if (isSignUpMode) "Min 8 characters" else "Enter your password", isSecure = true)
            }

            Spacer(modifier = Modifier.height(24.dp))

            Column(verticalArrangement = Arrangement.spacedBy(12.dp)) {
                Box(
                    modifier = Modifier
                        .fillMaxWidth()
                        .height(48.dp)
                        .clip(RoundedCornerShape(12.dp))
                        .background(Primary)
                        .clickable { onComplete(isSignUpMode) },
                    contentAlignment = Alignment.Center
                ) {
                    Text(if (isSignUpMode) "Accept & set up" else "Sign in", fontSize = 16.sp, fontWeight = FontWeight.SemiBold, color = PrimaryInk)
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

            // Divider with or
            Row(verticalAlignment = Alignment.CenterVertically, modifier = Modifier.fillMaxWidth()) {
                Box(modifier = Modifier.weight(1f).height(1.dp).background(Border))
                Text("or", fontSize = 13.sp, color = TextSubtle, modifier = Modifier.padding(horizontal = 12.dp))
                Box(modifier = Modifier.weight(1f).height(1.dp).background(Border))
            }

            Spacer(modifier = Modifier.height(20.dp))

            Column(verticalArrangement = Arrangement.spacedBy(8.dp)) {
                SignInWithGoogleButton { onComplete(isSignUpMode) }
            }

            Spacer(modifier = Modifier.height(20.dp))

            Row(
                modifier = Modifier.fillMaxWidth(),
                horizontalArrangement = Arrangement.Center,
                verticalAlignment = Alignment.CenterVertically
            ) {
                Text(if (isSignUpMode) "Already have an account?" else "New to FitHero?", fontSize = 15.sp, color = TextMuted)
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
