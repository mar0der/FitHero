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
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Close
import androidx.compose.material3.Icon
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
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.fithero.ui.theme.Bg
import com.fithero.ui.theme.Border
import com.fithero.ui.theme.Primary
import com.fithero.ui.theme.PrimaryInk
import com.fithero.ui.theme.Success
import com.fithero.ui.theme.Surface
import com.fithero.ui.theme.Text
import com.fithero.ui.theme.TextMuted
import com.fithero.ui.theme.TextSubtle

@Composable
fun ForgotPasswordSheet(onDismiss: () -> Unit) {
    var email by remember { mutableStateOf("") }
    var showConfirmation by remember { mutableStateOf(false) }
    val isValid = email.contains("@") && email.contains(".")

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
                .padding(top = 16.dp, bottom = 32.dp)
        ) {
            // Handle
            Box(modifier = Modifier.fillMaxWidth(), contentAlignment = Alignment.Center) {
                Box(modifier = Modifier.size(width = 38.dp, height = 5.dp).clip(RoundedCornerShape(100.dp)).background(Text.copy(alpha = 0.2f)))
            }
            Spacer(modifier = Modifier.height(12.dp))

            Row(
                modifier = Modifier.fillMaxWidth(),
                horizontalArrangement = Arrangement.SpaceBetween,
                verticalAlignment = Alignment.CenterVertically
            ) {
                Text("Reset Password", fontSize = 20.sp, fontWeight = FontWeight.Bold, color = Text)
                Icon(
                    Icons.Default.Close,
                    contentDescription = null,
                    tint = TextSubtle,
                    modifier = Modifier
                        .size(28.dp)
                        .clickable { onDismiss() }
                )
            }

            Spacer(modifier = Modifier.height(24.dp))

            // Header
            Column(horizontalAlignment = Alignment.CenterHorizontally, modifier = Modifier.fillMaxWidth()) {
                Box(
                    modifier = Modifier
                        .size(72.dp)
                        .clip(RoundedCornerShape(16.dp))
                        .background(Primary.copy(alpha = 0.12f)),
                    contentAlignment = Alignment.Center
                ) {
                    Text("L", fontSize = 32.sp, fontWeight = FontWeight.Bold, color = Primary)
                }
                Spacer(modifier = Modifier.height(16.dp))
                Text("Forgot your password?", fontSize = 20.sp, fontWeight = FontWeight.Bold, color = Text)
                Spacer(modifier = Modifier.height(8.dp))
                Text(
                    "Enter your email and we'll send you a link to reset your password.",
                    fontSize = 14.sp,
                    color = TextMuted,
                    lineHeight = 20.sp,
                    modifier = Modifier.padding(horizontal = 8.dp)
                )
            }

            Spacer(modifier = Modifier.height(24.dp))

            if (showConfirmation) {
                ConfirmationView(onBackToSignIn = onDismiss)
            } else {
                Column(verticalArrangement = Arrangement.spacedBy(16.dp)) {
                    Text("EMAIL", fontSize = 12.sp, fontWeight = FontWeight.SemiBold, color = TextSubtle, letterSpacing = 1.2.sp)
                    TextField(
                        value = email,
                        onValueChange = { email = it },
                        placeholder = { Text("you@example.com", color = TextSubtle) },
                        singleLine = true,
                        colors = TextFieldDefaults.colors(
                            focusedContainerColor = Surface,
                            unfocusedContainerColor = Surface,
                            focusedIndicatorColor = Color.Transparent,
                            unfocusedIndicatorColor = Color.Transparent,
                            cursorColor = Primary
                        ),
                        modifier = Modifier
                            .fillMaxWidth()
                            .clip(RoundedCornerShape(10.dp))
                    )

                    Box(
                        modifier = Modifier
                            .fillMaxWidth()
                            .height(48.dp)
                            .clip(RoundedCornerShape(12.dp))
                            .background(if (isValid) Primary else Primary.copy(alpha = 0.3f))
                            .clickable(enabled = isValid) { showConfirmation = true },
                        contentAlignment = Alignment.Center
                    ) {
                        Text("Send Reset Link", fontSize = 16.sp, fontWeight = FontWeight.SemiBold, color = PrimaryInk)
                    }
                }
            }
        }
    }
}

@Composable
private fun ConfirmationView(onBackToSignIn: () -> Unit) {
    Column(horizontalAlignment = Alignment.CenterHorizontally, modifier = Modifier.fillMaxWidth()) {
        Box(
            modifier = Modifier
                .size(64.dp)
                .clip(CircleShape)
                .background(Success.copy(alpha = 0.15f)),
            contentAlignment = Alignment.Center
        ) {
            Text("E", fontSize = 28.sp, fontWeight = FontWeight.Bold, color = Success)
        }
        Spacer(modifier = Modifier.height(16.dp))
        Text("Check your email", fontSize = 18.sp, fontWeight = FontWeight.Bold, color = Text)
        Spacer(modifier = Modifier.height(8.dp))
        Text(
            "We've sent a password reset link to your email. Tap the link in the email to create a new password.",
            fontSize = 14.sp,
            color = TextMuted,
            lineHeight = 20.sp,
            modifier = Modifier.padding(horizontal = 8.dp)
        )
        Spacer(modifier = Modifier.height(24.dp))
        Box(
            modifier = Modifier
                .fillMaxWidth()
                .height(48.dp)
                .clip(RoundedCornerShape(12.dp))
                .background(Primary)
                .clickable { onBackToSignIn() },
            contentAlignment = Alignment.Center
        ) {
            Text("Back to Sign In", fontSize = 16.sp, fontWeight = FontWeight.SemiBold, color = PrimaryInk)
        }
    }
}
