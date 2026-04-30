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
import androidx.compose.ui.text.input.PasswordVisualTransformation
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.fithero.ui.theme.Accent
import com.fithero.ui.theme.Bg
import com.fithero.ui.theme.Border
import com.fithero.ui.theme.Primary
import com.fithero.ui.theme.PrimaryInk
import com.fithero.ui.theme.Surface
import com.fithero.ui.theme.Text
import com.fithero.ui.theme.TextMuted
import com.fithero.ui.theme.TextSubtle

@Composable
fun AuthSignInScreen(
    onSignIn: (String) -> Unit,
    onBack: () -> Unit,
    onForgotPassword: () -> Unit
) {
    var email by remember { mutableStateOf("") }
    var password by remember { mutableStateOf("") }

    Box(modifier = Modifier.fillMaxSize().background(Bg)) {
        Column(
            modifier = Modifier
                .fillMaxSize()
                .verticalScroll(rememberScrollState())
                .padding(horizontal = 16.dp)
        ) {
            // Back button
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
                        .size(48.dp)
                        .clip(RoundedCornerShape(12.dp))
                        .background(Primary),
                    contentAlignment = Alignment.Center
                ) {
                    Text("FH", fontSize = 16.sp, fontWeight = FontWeight.Black, color = PrimaryInk)
                }
                Spacer(modifier = Modifier.height(20.dp))
                Text("Sign in to your account", fontSize = 22.sp, fontWeight = FontWeight.Bold, color = Text)
                Spacer(modifier = Modifier.height(4.dp))
                Text("Welcome back.", fontSize = 15.sp, color = TextMuted)
            }

            Spacer(modifier = Modifier.height(32.dp))

            // Form
            Column(verticalArrangement = Arrangement.spacedBy(16.dp)) {
                AuthInputField(label = "Email", value = email, onValueChange = { email = it }, placeholder = "you@example.com")
                AuthInputField(label = "Password", value = password, onValueChange = { password = it }, placeholder = "Enter your password", isSecure = true)
            }

            Spacer(modifier = Modifier.height(24.dp))

            Column(verticalArrangement = Arrangement.spacedBy(12.dp)) {
                Box(
                    modifier = Modifier
                        .fillMaxWidth()
                        .height(48.dp)
                        .clip(RoundedCornerShape(12.dp))
                        .background(Primary)
                        .clickable { onSignIn(email) },
                    contentAlignment = Alignment.Center
                ) {
                    Text("Sign in", fontSize = 16.sp, fontWeight = FontWeight.SemiBold, color = PrimaryInk)
                }

                Box(
                    modifier = Modifier.fillMaxWidth(),
                    contentAlignment = Alignment.Center
                ) {
                    Text(
                        "Forgot password?",
                        fontSize = 14.sp,
                        fontWeight = FontWeight.Medium,
                        color = Accent,
                        modifier = Modifier.clickable { onForgotPassword() }
                    )
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
                SignInWithGoogleButton { onSignIn(email) }
            }

            Spacer(modifier = Modifier.height(32.dp))
        }
    }
}

@Composable
fun AuthInputField(
    label: String,
    value: String,
    onValueChange: (String) -> Unit,
    placeholder: String,
    isSecure: Boolean = false
) {
    Column(verticalArrangement = Arrangement.spacedBy(6.dp)) {
        Text(
            label.uppercase(),
            fontSize = 12.sp,
            fontWeight = FontWeight.SemiBold,
            color = TextSubtle,
            letterSpacing = 1.2.sp
        )
        TextField(
            value = value,
            onValueChange = onValueChange,
            placeholder = { Text(placeholder, color = TextSubtle) },
            singleLine = true,
            visualTransformation = if (isSecure) PasswordVisualTransformation() else androidx.compose.ui.text.input.VisualTransformation.None,
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
    }
}
