package com.fithero.ui.screens.trainer

import androidx.compose.foundation.background
import androidx.compose.foundation.border
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
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
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
import com.fithero.ui.theme.Surface
import com.fithero.ui.theme.Text
import com.fithero.ui.theme.TextMuted
import com.fithero.ui.theme.TextSubtle

private data class Conversation(
    val name: String,
    val preview: String,
    val time: String,
    val unread: Int,
    val initials: String
)

private val conversations = listOf(
    Conversation("Alex Johnson", "Thanks for the program update! Ready for tomorrow.", "10m", 2, "AJ"),
    Conversation("Marco Rossi", "Can we reschedule Thursday to Friday?", "1h", 1, "MR"),
    Conversation("Erika Szabo", "Hit a new PR on deadlifts today 🎉", "3h", 0, "ES"),
    Conversation("Sam Taylor", "I'm back from vacation, ready to start Monday.", "2d", 0, "ST")
)

@Composable
fun TrainerMessagesScreen(modifier: Modifier = Modifier) {
    Column(
        modifier = modifier
            .fillMaxSize()
            .background(Bg)
            .verticalScroll(rememberScrollState())
            .padding(16.dp)
    ) {
        Text("Messages", fontSize = 28.sp, fontWeight = FontWeight.Bold, color = Text)
        Text("${conversations.count { it.unread > 0 }} unread", fontSize = 14.sp, color = TextMuted)

        Spacer(modifier = Modifier.height(20.dp))

        conversations.forEach { conv ->
            ConversationRow(conv)
            Spacer(modifier = Modifier.height(8.dp))
        }

        Spacer(modifier = Modifier.height(32.dp))
    }
}

@Composable
private fun ConversationRow(conv: Conversation) {
    Row(
        modifier = Modifier
            .fillMaxWidth()
            .clip(RoundedCornerShape(16.dp))
            .background(Surface)
            .border(1.dp, Border, RoundedCornerShape(16.dp))
            .padding(14.dp),
        verticalAlignment = Alignment.CenterVertically
    ) {
        Box(modifier = Modifier.size(48.dp), contentAlignment = Alignment.BottomEnd) {
            Box(
                modifier = Modifier
                    .size(48.dp)
                    .clip(CircleShape)
                    .background(Accent.copy(alpha = 0.15f)),
                contentAlignment = Alignment.Center
            ) {
                Text(conv.initials, fontSize = 16.sp, fontWeight = FontWeight.SemiBold, color = Accent)
            }
            if (conv.unread > 0) {
                Box(
                    modifier = Modifier
                        .size(18.dp)
                        .clip(CircleShape)
                        .background(Primary),
                    contentAlignment = Alignment.Center
                ) {
                    Text("${conv.unread}", fontSize = 10.sp, fontWeight = FontWeight.Bold, color = PrimaryInk)
                }
            }
        }
        Spacer(modifier = Modifier.width(12.dp))
        Column(modifier = Modifier.weight(1f)) {
            Row(modifier = Modifier.fillMaxWidth(), horizontalArrangement = Arrangement.SpaceBetween) {
                Text(conv.name, fontSize = 15.sp, fontWeight = if (conv.unread > 0) FontWeight.SemiBold else FontWeight.Medium, color = Text)
                Text(conv.time, fontSize = 12.sp, color = TextSubtle)
            }
            Text(conv.preview, fontSize = 13.sp, color = if (conv.unread > 0) TextMuted else TextSubtle, maxLines = 2)
        }
    }
}
