package com.fithero.ui.screens.trainer

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
import androidx.compose.foundation.layout.width
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.foundation.verticalScroll
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Add
import androidx.compose.material.icons.filled.Close
import androidx.compose.material.icons.filled.Search
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
import com.fithero.ui.theme.Accent
import com.fithero.ui.theme.Bg
import com.fithero.ui.theme.Border
import com.fithero.ui.theme.Danger
import com.fithero.ui.theme.Primary
import com.fithero.ui.theme.PrimaryInk
import com.fithero.ui.theme.Success
import com.fithero.ui.theme.Surface
import com.fithero.ui.theme.Surface2
import com.fithero.ui.theme.Text
import com.fithero.ui.theme.TextMuted
import com.fithero.ui.theme.TextSubtle
import com.fithero.ui.theme.Warning

private val allClients = listOf(
    ClientItem("Alex Johnson", "Pro — 3×/week", "Active", "2h ago", "AJ"),
    ClientItem("Marco Rossi", "Starter — 2×/week", "Active", "1d ago", "MR"),
    ClientItem("Erika Szabo", "Pro — 4×/week", "Active", "5h ago", "ES"),
    ClientItem("Sam Taylor", "Starter — 2×/week", "Paused", "2w ago", "ST"),
    ClientItem("Lisa Chen", "Pending invite", "Pending", "—", "LC")
)

@Composable
fun TrainerClientsScreen(modifier: Modifier = Modifier) {
    var searchText by remember { mutableStateOf("") }
    var selectedFilter by remember { mutableStateOf("All") }
    var selectedClient by remember { mutableStateOf<ClientItem?>(null) }
    val filters = listOf("All", "Active", "Pending", "Paused")

    val filtered = allClients.filter { client ->
        val matchesFilter = selectedFilter == "All" || client.status == selectedFilter
        val matchesSearch = searchText.isEmpty() || client.name.contains(searchText, ignoreCase = true)
        matchesFilter && matchesSearch
    }

    Box(modifier = modifier.fillMaxSize().background(Bg)) {
        Column(
            modifier = Modifier
                .fillMaxSize()
                .verticalScroll(rememberScrollState())
                .padding(16.dp)
        ) {
        // Header
        Row(modifier = Modifier.fillMaxWidth(), horizontalArrangement = Arrangement.SpaceBetween, verticalAlignment = Alignment.Top) {
            Column {
                Text("Clients", fontSize = 28.sp, fontWeight = FontWeight.Bold, color = Text)
                Text("${allClients.count { it.status == "Active" }} active", fontSize = 14.sp, color = TextMuted)
            }
            Box(
                modifier = Modifier
                    .size(44.dp)
                    .clip(CircleShape)
                    .background(Primary),
                contentAlignment = Alignment.Center
            ) {
                Icon(Icons.Default.Add, contentDescription = null, tint = PrimaryInk, modifier = Modifier.size(20.dp))
            }
        }

        Spacer(modifier = Modifier.height(16.dp))

        // Search
        TextField(
            value = searchText,
            onValueChange = { searchText = it },
            placeholder = { Text("Search clients", color = TextMuted) },
            leadingIcon = { Icon(Icons.Default.Search, contentDescription = null, tint = TextSubtle, modifier = Modifier.size(18.dp)) },
            trailingIcon = {
                if (searchText.isNotEmpty()) {
                    Icon(Icons.Default.Close, contentDescription = null, tint = TextSubtle, modifier = Modifier.size(18.dp).clickable { searchText = "" })
                }
            },
            colors = TextFieldDefaults.colors(
                focusedContainerColor = Surface,
                unfocusedContainerColor = Surface,
                focusedIndicatorColor = Color.Transparent,
                unfocusedIndicatorColor = Color.Transparent,
                cursorColor = Primary
            ),
            modifier = Modifier
                .fillMaxWidth()
                .clip(RoundedCornerShape(999.dp))
                .border(1.dp, Border, RoundedCornerShape(999.dp)),
            singleLine = true
        )

        Spacer(modifier = Modifier.height(12.dp))

        // Filter pills
        Row(horizontalArrangement = Arrangement.spacedBy(8.dp)) {
            filters.forEach { filter ->
                val selected = selectedFilter == filter
                Box(
                    modifier = Modifier
                        .clip(RoundedCornerShape(999.dp))
                        .background(if (selected) Primary else Surface2)
                        .border(1.dp, if (selected) Primary else Border, RoundedCornerShape(999.dp))
                        .clickable { selectedFilter = filter }
                        .padding(horizontal = 14.dp, vertical = 8.dp)
                ) {
                    Text(
                        filter,
                        fontSize = 13.sp,
                        fontWeight = if (selected) FontWeight.SemiBold else FontWeight.Medium,
                        color = if (selected) PrimaryInk else TextMuted
                    )
                }
            }
        }

        Spacer(modifier = Modifier.height(16.dp))

        // Client list
        if (filtered.isEmpty()) {
            Box(modifier = Modifier.fillMaxWidth().padding(vertical = 48.dp), contentAlignment = Alignment.Center) {
                Text("No clients found", fontSize = 16.sp, color = TextMuted)
            }
        } else {
            filtered.forEach { client ->
                ClientRow(client, onClick = { selectedClient = client })
                Spacer(modifier = Modifier.height(8.dp))
            }
        }

        Spacer(modifier = Modifier.height(32.dp))
        }

        selectedClient?.let { client ->
            ClientDetailScreen(
                client = client,
                onDismiss = { selectedClient = null }
            )
        }
    }
}

@Composable
private fun ClientRow(client: ClientItem, onClick: () -> Unit) {
    val statusColor = when (client.status) {
        "Active" -> Success
        "Pending" -> Warning
        else -> TextSubtle
    }
    val avatarColor = when (client.status) {
        "Active" -> Accent
        "Pending" -> Warning
        else -> TextSubtle
    }

    Row(
        modifier = Modifier
            .fillMaxWidth()
            .clip(RoundedCornerShape(16.dp))
            .background(Surface)
            .border(1.dp, Border, RoundedCornerShape(16.dp))
            .clickable { onClick() }
            .padding(14.dp),
        verticalAlignment = Alignment.CenterVertically
    ) {
        Box(
            modifier = Modifier
                .size(48.dp)
                .clip(CircleShape)
                .background(avatarColor.copy(alpha = 0.15f)),
            contentAlignment = Alignment.Center
        ) {
            Text(client.initials, fontSize = 16.sp, fontWeight = FontWeight.SemiBold, color = avatarColor)
        }
        Spacer(modifier = Modifier.width(12.dp))
        Column(modifier = Modifier.weight(1f)) {
            Text(client.name, fontSize = 15.sp, fontWeight = FontWeight.SemiBold, color = Text)
            Text(client.plan, fontSize = 13.sp, color = TextMuted)
        }
        Column(horizontalAlignment = Alignment.End) {
            Box(
                modifier = Modifier
                    .clip(RoundedCornerShape(999.dp))
                    .background(statusColor.copy(alpha = 0.12f))
                    .padding(horizontal = 8.dp, vertical = 3.dp)
            ) {
                Text(client.status, fontSize = 11.sp, fontWeight = FontWeight.SemiBold, color = statusColor)
            }
            Spacer(modifier = Modifier.height(2.dp))
            Text(client.lastActive, fontSize = 12.sp, color = TextSubtle)
        }
    }
}
