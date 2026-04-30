package com.fithero.ui.screens.auth

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
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.automirrored.filled.ArrowBack
import androidx.compose.material.icons.automirrored.filled.KeyboardArrowRight
import androidx.compose.material.icons.filled.Email
import androidx.compose.material.icons.filled.FitnessCenter
import androidx.compose.material3.Icon
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.fithero.ui.theme.Bg
import com.fithero.ui.theme.Border
import com.fithero.ui.theme.Primary
import com.fithero.ui.theme.PrimaryInk
import com.fithero.ui.theme.Surface
import com.fithero.ui.theme.Surface2
import com.fithero.ui.theme.Text
import com.fithero.ui.theme.TextMuted
import com.fithero.ui.theme.TextSubtle

@Composable
fun AuthSignUpOptionsScreen(
    onInvitedByTrainer: () -> Unit,
    onTrainer: () -> Unit,
    onSignIn: () -> Unit,
    onBack: () -> Unit
) {
    Box(modifier = Modifier.fillMaxSize().background(Bg)) {
        Column(
            modifier = Modifier
                .fillMaxSize()
                .padding(horizontal = 16.dp),
            verticalArrangement = Arrangement.SpaceBetween,
            horizontalAlignment = Alignment.CenterHorizontally
        ) {
            Column(modifier = Modifier.fillMaxWidth()) {
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

                Spacer(modifier = Modifier.height(32.dp))

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
                    Text("How would you like to join?", fontSize = 22.sp, fontWeight = FontWeight.Bold, color = Text)
                    Spacer(modifier = Modifier.height(4.dp))
                    Text("Choose the path that fits you.", fontSize = 15.sp, color = TextMuted)
                }
            }

            Column(
                modifier = Modifier
                    .fillMaxWidth()
                    .padding(bottom = 52.dp),
                verticalArrangement = Arrangement.spacedBy(10.dp)
            ) {
                OptionCard(
                    icon = Icons.Default.Email,
                    title = "I was invited by a trainer",
                    subtitle = "Your coach sent you an invite link.",
                    onClick = onInvitedByTrainer
                )

                OptionCard(
                    icon = Icons.Default.FitnessCenter,
                    title = "I'm a trainer",
                    subtitle = "Create your coach account.",
                    onClick = onTrainer
                )

                Row(
                    modifier = Modifier
                        .fillMaxWidth()
                        .padding(top = 8.dp),
                    horizontalArrangement = Arrangement.Center,
                    verticalAlignment = Alignment.CenterVertically
                ) {
                    Text("Already have an account?", fontSize = 15.sp, color = TextMuted)
                    Spacer(modifier = Modifier.height(4.dp))
                    Text(
                        "Sign in",
                        fontSize = 15.sp,
                        fontWeight = FontWeight.SemiBold,
                        color = Primary,
                        modifier = Modifier.clickable { onSignIn() }
                    )
                }
            }
        }
    }
}

@Composable
private fun OptionCard(
    icon: androidx.compose.ui.graphics.vector.ImageVector,
    title: String,
    subtitle: String,
    onClick: () -> Unit
) {
    Row(
        modifier = Modifier
            .fillMaxWidth()
            .clip(RoundedCornerShape(12.dp))
            .background(Surface)
            .border(1.dp, Border, RoundedCornerShape(12.dp))
            .clickable { onClick() }
            .padding(14.dp),
        verticalAlignment = Alignment.CenterVertically,
        horizontalArrangement = Arrangement.spacedBy(12.dp)
    ) {
        Box(
            modifier = Modifier
                .size(52.dp)
                .clip(RoundedCornerShape(10.dp))
                .background(Surface2),
            contentAlignment = Alignment.Center
        ) {
            Icon(icon, contentDescription = null, tint = Text, modifier = Modifier.size(22.dp))
        }
        Column(modifier = Modifier.weight(1f)) {
            Text(title, fontSize = 17.sp, fontWeight = FontWeight.SemiBold, color = Text)
            Text(subtitle, fontSize = 14.sp, color = TextMuted)
        }
        Icon(Icons.AutoMirrored.Filled.KeyboardArrowRight, contentDescription = null, tint = TextSubtle, modifier = Modifier.size(20.dp))
    }
}
