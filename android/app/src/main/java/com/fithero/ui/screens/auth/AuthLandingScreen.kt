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
import com.fithero.ui.theme.Surface2
import com.fithero.ui.theme.Text
import com.fithero.ui.theme.TextMuted
import com.fithero.ui.theme.TextSubtle

@Composable
fun AuthLandingScreen(
    onSignIn: () -> Unit,
    onGetStarted: () -> Unit,
    onDebugTrainer: () -> Unit,
    onDebugClient: () -> Unit,
    onDebugOnboarding: () -> Unit
) {
    Box(
        modifier = Modifier
            .fillMaxSize()
            .background(Bg)
    ) {
        Column(
            modifier = Modifier.fillMaxSize(),
            verticalArrangement = Arrangement.SpaceBetween,
            horizontalAlignment = Alignment.CenterHorizontally
        ) {
            Spacer(modifier = Modifier.height(48.dp))

            // Brand
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
                Spacer(modifier = Modifier.height(8.dp))
                Text("Training, simplified.", fontSize = 17.sp, color = TextMuted)
            }

            // Debug buttons + Actions
            Column(
                modifier = Modifier
                    .fillMaxWidth()
                    .padding(horizontal = 24.dp)
                    .padding(bottom = 52.dp),
                verticalArrangement = Arrangement.spacedBy(10.dp),
                horizontalAlignment = Alignment.CenterHorizontally
            ) {
                // Debug buttons
                Row(
                    modifier = Modifier
                        .fillMaxWidth()
                        .padding(bottom = 8.dp),
                    horizontalArrangement = Arrangement.spacedBy(8.dp, Alignment.CenterHorizontally)
                ) {
                    DebugPill("Trainer", onDebugTrainer)
                    DebugPill("Hero", onDebugClient)
                    DebugPill("Onboarding", onDebugOnboarding)
                }
                Box(
                    modifier = Modifier
                        .fillMaxWidth()
                        .height(48.dp)
                        .clip(RoundedCornerShape(12.dp))
                        .background(Primary)
                        .clickable { onSignIn() },
                    contentAlignment = Alignment.Center
                ) {
                    Text("Sign In", fontSize = 16.sp, fontWeight = FontWeight.SemiBold, color = PrimaryInk)
                }

                Box(
                    modifier = Modifier
                        .fillMaxWidth()
                        .height(44.dp)
                        .clip(RoundedCornerShape(12.dp))
                        .background(Surface2)
                        .clickable { onGetStarted() },
                    contentAlignment = Alignment.Center
                ) {
                    Text("Get Started", fontSize = 15.sp, fontWeight = FontWeight.Medium, color = Text)
                }
            }
        }
    }
}

@Composable
private fun DebugPill(label: String, onClick: () -> Unit) {
    Text(
        text = label,
        fontSize = 10.sp,
        fontWeight = FontWeight.Medium,
        color = TextSubtle,
        modifier = Modifier
            .clip(CircleShape)
            .background(Surface2)
            .clickable { onClick() }
            .padding(horizontal = 10.dp, vertical = 4.dp)
    )
}
