package com.fithero.ui.screens

import androidx.compose.foundation.background
import androidx.compose.foundation.border
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.PaddingValues
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.layout.width
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.foundation.text.BasicTextField
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.automirrored.filled.Send
import androidx.compose.material.icons.filled.AddPhotoAlternate
import androidx.compose.material.icons.filled.Videocam
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.text.TextStyle
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.fithero.ui.theme.Accent
import com.fithero.ui.theme.Bg
import com.fithero.ui.theme.Border
import com.fithero.ui.theme.Primary
import com.fithero.ui.theme.PrimaryInk
import com.fithero.ui.theme.Success
import com.fithero.ui.theme.Surface
import com.fithero.ui.theme.Text
import com.fithero.ui.theme.TextMuted
import com.fithero.ui.theme.TextSubtle

// ---------- Data ----------

private data class ChatMessage(
    val id: Int,
    val text: String,
    val time: String,
    val isFromTrainer: Boolean
)

private val messages = listOf(
    ChatMessage(1, "Hey Alex! Ready for today's upper body session?", "08:30", true),
    ChatMessage(2, "Yes! Feeling strong today 💪", "08:32", false),
    ChatMessage(3, "Great session yesterday! Your bench press form was on point.", "09:15", true),
    ChatMessage(4, "Thanks! I felt really stable on the last set.", "09:20", false),
    ChatMessage(5, "Let's aim for 82.5 kg today. You've got this.", "09:21", true),
    ChatMessage(6, "Deal. See you at the studio!", "09:22", false)
)

// ---------- Screen ----------

@Composable
fun MessagesScreen(modifier: Modifier = Modifier) {
    var inputText by remember { mutableStateOf("") }

    Column(
        modifier = modifier
            .fillMaxSize()
            .background(Bg)
    ) {
        // Header
        ChatHeader()

        Spacer(modifier = Modifier.height(1.dp).fillMaxWidth().background(Border))

        // Chat body
        LazyColumn(
            modifier = Modifier
                .weight(1f)
                .fillMaxWidth()
                .padding(horizontal = 16.dp),
            reverseLayout = false,
            contentPadding = PaddingValues(vertical = 16.dp),
            verticalArrangement = Arrangement.spacedBy(12.dp)
        ) {
            // Date header
            item {
                Box(modifier = Modifier.fillMaxWidth(), contentAlignment = Alignment.Center) {
                    Text("Today", fontSize = 12.sp, fontWeight = FontWeight.Medium, color = TextSubtle)
                }
            }

            items(messages) { message ->
                MessageBubble(message)
            }
        }

        Spacer(modifier = Modifier.height(1.dp).fillMaxWidth().background(Border))

        // Input bar
        ChatInputBar(
            inputText = inputText,
            onInputChange = { inputText = it }
        )
    }
}

@Composable
private fun ChatHeader() {
    Row(
        modifier = Modifier
            .fillMaxWidth()
            .padding(16.dp),
        verticalAlignment = Alignment.CenterVertically
    ) {
        Box(
            modifier = Modifier
                .size(44.dp)
                .clip(CircleShape)
                .background(Accent.copy(alpha = 0.15f)),
            contentAlignment = Alignment.Center
        ) {
            Text("M", fontSize = 17.sp, fontWeight = FontWeight.SemiBold, color = Accent)
        }

        Spacer(modifier = Modifier.width(12.dp))

        Column(modifier = Modifier.weight(1f)) {
            Text("Maya", fontSize = 17.sp, fontWeight = FontWeight.SemiBold, color = Text)
            Row(verticalAlignment = Alignment.CenterVertically) {
                Box(modifier = Modifier.size(7.dp).clip(CircleShape).background(Success))
                Spacer(modifier = Modifier.width(4.dp))
                Text("Online", fontSize = 12.sp, color = Success)
            }
        }

        Box(
            modifier = Modifier
                .size(40.dp)
                .clip(CircleShape)
                .background(Surface),
            contentAlignment = Alignment.Center
        ) {
            Icon(Icons.Default.Videocam, contentDescription = null, tint = TextMuted, modifier = Modifier.size(18.dp))
        }
    }
}

@Composable
private fun MessageBubble(message: ChatMessage) {
    val isTrainer = message.isFromTrainer

    Row(
        modifier = Modifier.fillMaxWidth(),
        horizontalArrangement = if (isTrainer) Arrangement.Start else Arrangement.End
    ) {
        if (!isTrainer) Spacer(modifier = Modifier.width(48.dp))

        Column(horizontalAlignment = if (isTrainer) Alignment.Start else Alignment.End) {
            Text(
                text = message.text,
                fontSize = 15.sp,
                color = if (isTrainer) Text else PrimaryInk,
                modifier = Modifier
                    .clip(RoundedCornerShape(16.dp))
                    .background(if (isTrainer) Surface else Primary)
                    .padding(horizontal = 14.dp, vertical = 10.dp)
            )
            Spacer(modifier = Modifier.height(2.dp))
            Text(message.time, fontSize = 11.sp, color = TextSubtle)
        }

        if (isTrainer) Spacer(modifier = Modifier.width(48.dp))
    }
}

@Composable
private fun ChatInputBar(inputText: String, onInputChange: (String) -> Unit) {
    Row(
        modifier = Modifier
            .fillMaxWidth()
            .padding(16.dp),
        verticalAlignment = Alignment.CenterVertically
    ) {
        IconButton(onClick = { }) {
            Icon(Icons.Default.AddPhotoAlternate, contentDescription = null, tint = TextMuted, modifier = Modifier.size(22.dp))
        }

        Spacer(modifier = Modifier.width(4.dp))

        // Text field
        BasicTextField(
            value = inputText,
            onValueChange = onInputChange,
            modifier = Modifier
                .weight(1f)
                .clip(RoundedCornerShape(999.dp))
                .background(Surface)
                .border(1.dp, Border, RoundedCornerShape(999.dp))
                .padding(horizontal = 16.dp, vertical = 10.dp),
            textStyle = TextStyle(fontSize = 15.sp, color = Text),
            decorationBox = { innerTextField ->
                if (inputText.isEmpty()) {
                    Text("Message", fontSize = 15.sp, color = TextMuted)
                }
                innerTextField()
            }
        )

        Spacer(modifier = Modifier.width(8.dp))

        IconButton(onClick = { }, enabled = inputText.isNotEmpty()) {
            Icon(
                Icons.AutoMirrored.Filled.Send,
                contentDescription = null,
                tint = if (inputText.isEmpty()) TextSubtle else Primary,
                modifier = Modifier.size(28.dp)
            )
        }
    }
}
