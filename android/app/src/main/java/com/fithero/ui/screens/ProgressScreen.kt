package com.fithero.ui.screens

import androidx.compose.foundation.Canvas
import androidx.compose.foundation.background
import androidx.compose.foundation.border
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.ExperimentalLayoutApi
import androidx.compose.foundation.layout.FlowRow
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.aspectRatio
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
import androidx.compose.material.icons.filled.Check
import androidx.compose.material3.Icon
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableIntStateOf
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.geometry.Offset
import androidx.compose.ui.graphics.Brush
import androidx.compose.ui.graphics.Path
import androidx.compose.ui.graphics.StrokeCap
import androidx.compose.ui.graphics.drawscope.Stroke
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

@Composable
fun ProgressScreen(modifier: Modifier = Modifier) {
    var selectedTab by remember { mutableIntStateOf(0) }
    val tabs = listOf("Weight", "PRs", "Body", "Photos")

    Column(
        modifier = modifier
            .fillMaxSize()
            .background(Bg)
    ) {
        // Header
        Column(modifier = Modifier.padding(16.dp)) {
            Text("Progress", fontSize = 28.sp, fontWeight = FontWeight.Bold, color = Text)
            Text("8 weeks of training", fontSize = 14.sp, color = TextMuted)
        }

        // Segmented control
        Row(
            modifier = Modifier
                .fillMaxWidth()
                .padding(horizontal = 16.dp)
                .clip(RoundedCornerShape(12.dp))
                .background(Surface)
                .padding(4.dp),
            horizontalArrangement = Arrangement.spacedBy(4.dp)
        ) {
            tabs.forEachIndexed { index, title ->
                val selected = selectedTab == index
                Box(
                    modifier = Modifier
                        .weight(1f)
                        .clip(RoundedCornerShape(10.dp))
                        .background(if (selected) Primary else Surface)
                        .clickable { selectedTab = index }
                        .padding(vertical = 10.dp),
                    contentAlignment = Alignment.Center
                ) {
                    Text(
                        text = title,
                        fontSize = 14.sp,
                        fontWeight = if (selected) FontWeight.SemiBold else FontWeight.Medium,
                        color = if (selected) PrimaryInk else TextMuted
                    )
                }
            }
        }

        Spacer(modifier = Modifier.height(16.dp))

        // Content
        Column(
            modifier = Modifier
                .fillMaxWidth()
                .weight(1f)
                .verticalScroll(rememberScrollState())
                .padding(horizontal = 16.dp)
                .padding(bottom = 32.dp)
        ) {
            when (selectedTab) {
                0 -> WeightTab()
                1 -> PRsTab()
                2 -> BodyTab()
                3 -> PhotosTab()
            }
        }
    }
}

// ---------- Weight Tab ----------

private val weightHistory = listOf(
    WeightEntry("Feb 1", 82.3),
    WeightEntry("Feb 8", 81.9),
    WeightEntry("Feb 15", 81.5),
    WeightEntry("Feb 22", 81.1),
    WeightEntry("Mar 1", 80.6),
    WeightEntry("Mar 8", 80.2),
    WeightEntry("Mar 15", 79.9),
    WeightEntry("Mar 22", 79.8)
)

private data class WeightEntry(val date: String, val weight: Double)

@Composable
private fun WeightTab() {
    Column(verticalArrangement = Arrangement.spacedBy(16.dp)) {
        // Summary card
        Row(
            modifier = Modifier
                .fillMaxWidth()
                .clip(RoundedCornerShape(16.dp))
                .background(Surface)
                .padding(16.dp),
            horizontalArrangement = Arrangement.SpaceEvenly
        ) {
            StatBlock("Current", "79.8", "kg")
            StatBlock("Start", "82.3", "kg")
            StatBlock("Change", "-2.5", "kg", highlight = true)
        }

        // Chart card
        Column(
            modifier = Modifier
                .fillMaxWidth()
                .clip(RoundedCornerShape(16.dp))
                .background(Surface)
                .padding(16.dp)
        ) {
            Text("WEIGHT TREND", fontSize = 12.sp, fontWeight = FontWeight.SemiBold, color = TextSubtle, letterSpacing = 1.2.sp)
            Spacer(modifier = Modifier.height(12.dp))
            SimpleLineChart(
                data = weightHistory.map { it.weight },
                labels = weightHistory.map { it.date },
                modifier = Modifier
                    .fillMaxWidth()
                    .height(180.dp)
            )
        }

        // Log card
        Column(
            modifier = Modifier
                .fillMaxWidth()
                .clip(RoundedCornerShape(16.dp))
                .background(Surface)
                .padding(16.dp)
        ) {
            Text("LOG", fontSize = 12.sp, fontWeight = FontWeight.SemiBold, color = TextSubtle, letterSpacing = 1.2.sp)
            Spacer(modifier = Modifier.height(8.dp))
            weightHistory.asReversed().forEachIndexed { idx, entry ->
                Row(
                    modifier = Modifier
                        .fillMaxWidth()
                        .padding(vertical = 8.dp),
                    horizontalArrangement = Arrangement.SpaceBetween
                ) {
                    Text(entry.date, fontSize = 14.sp, color = TextMuted)
                    Text("${entry.weight} kg", fontSize = 16.sp, fontWeight = FontWeight.SemiBold, color = Text)
                }
                if (idx < weightHistory.size - 1) {
                    Spacer(modifier = Modifier.height(1.dp).fillMaxWidth().background(Border))
                }
            }
        }
    }
}

@Composable
private fun SimpleLineChart(
    data: List<Double>,
    labels: List<String>,
    modifier: Modifier = Modifier
) {
    val minVal = data.minOrNull() ?: 0.0
    val maxVal = data.maxOrNull() ?: 1.0
    val range = (maxVal - minVal).coerceAtLeast(0.1)

    Box(modifier = modifier) {
        Canvas(modifier = Modifier.fillMaxSize()) {
            val w = size.width
            val h = size.height
            val padLeft = 28f
            val padBottom = 20f
            val chartW = w - padLeft
            val chartH = h - padBottom

            // Grid lines
            val gridCount = 4
            for (i in 0..gridCount) {
                val y = chartH * i / gridCount
                drawLine(
                    color = androidx.compose.ui.graphics.Color(0xFF262C34),
                    start = Offset(padLeft, y),
                    end = Offset(w, y),
                    strokeWidth = 1f
                )
            }

            // Area path
            val path = Path()
            data.forEachIndexed { i, v ->
                val x = padLeft + chartW * i / (data.size - 1).coerceAtLeast(1)
                val y = chartH - ((v - minVal) / range * chartH * 0.85f + chartH * 0.05f).toFloat()
                if (i == 0) path.moveTo(x, y) else path.lineTo(x, y)
            }
            // Close area
            val lastX = padLeft + chartW
            val firstX = padLeft
            path.lineTo(lastX, chartH)
            path.lineTo(firstX, chartH)
            path.close()
            drawPath(
                path = path,
                brush = Brush.verticalGradient(
                    colors = listOf(
                        androidx.compose.ui.graphics.Color(0xFFC6FF3D).copy(alpha = 0.2f),
                        androidx.compose.ui.graphics.Color(0xFFC6FF3D).copy(alpha = 0f)
                    ),
                    startY = 0f,
                    endY = chartH
                )
            )

            // Line path
            val linePath = Path()
            data.forEachIndexed { i, v ->
                val x = padLeft + chartW * i / (data.size - 1).coerceAtLeast(1)
                val y = chartH - ((v - minVal) / range * chartH * 0.85f + chartH * 0.05f).toFloat()
                if (i == 0) linePath.moveTo(x, y) else linePath.lineTo(x, y)
            }
            drawPath(
                path = linePath,
                color = androidx.compose.ui.graphics.Color(0xFFC6FF3D),
                style = Stroke(width = 2.5f, cap = StrokeCap.Round)
            )

            // Points
            data.forEachIndexed { i, v ->
                val x = padLeft + chartW * i / (data.size - 1).coerceAtLeast(1)
                val y = chartH - ((v - minVal) / range * chartH * 0.85f + chartH * 0.05f).toFloat()
                drawCircle(
                    color = androidx.compose.ui.graphics.Color(0xFFC6FF3D),
                    radius = 4f,
                    center = Offset(x, y)
                )
            }
        }
    }
}

@Composable
private fun StatBlock(label: String, value: String, unit: String, highlight: Boolean = false) {
    Column(horizontalAlignment = Alignment.CenterHorizontally, modifier = Modifier.width(80.dp)) {
        Text(label, fontSize = 12.sp, color = TextSubtle)
        Row(verticalAlignment = androidx.compose.ui.Alignment.Bottom) {
            Text(value, fontSize = 24.sp, fontWeight = FontWeight.Bold, color = if (highlight) Success else Text)
            Text(unit, fontSize = 13.sp, color = TextMuted, modifier = Modifier.padding(start = 2.dp, bottom = 3.dp))
        }
    }
}

// ---------- PRs Tab ----------

private val personalRecords = listOf(
    PR("Bench Press", "105 kg", "Feb 14"),
    PR("Deadlift", "165 kg", "Jan 28"),
    PR("Squat", "140 kg", "Mar 3"),
    PR("Overhead Press", "62.5 kg", "Feb 21")
)

private data class PR(val exerciseName: String, val value: String, val date: String)

@Composable
private fun PRsTab() {
    Column(verticalArrangement = Arrangement.spacedBy(12.dp)) {
        personalRecords.forEach { pr ->
            Row(
                modifier = Modifier
                    .fillMaxWidth()
                    .clip(RoundedCornerShape(16.dp))
                    .background(Surface)
                    .padding(16.dp),
                verticalAlignment = Alignment.CenterVertically
            ) {
                Box(
                    modifier = Modifier
                        .size(48.dp)
                        .clip(RoundedCornerShape(12.dp))
                        .background(Warning.copy(alpha = 0.12f)),
                    contentAlignment = Alignment.Center
                ) {
                    Text("🏆", fontSize = 20.sp)
                }
                Spacer(modifier = Modifier.width(12.dp))
                Column(modifier = Modifier.weight(1f)) {
                    Text(pr.exerciseName, fontSize = 16.sp, fontWeight = FontWeight.SemiBold, color = Text)
                    Text(pr.date, fontSize = 13.sp, color = TextSubtle)
                }
                Text(pr.value, fontSize = 20.sp, fontWeight = FontWeight.Bold, color = Primary)
            }
        }
    }
}

// ---------- Body Tab ----------

private val measurements = listOf(
    Measurement("Chest", "98.5", "99.2", "cm"),
    Measurement("Waist", "82.0", "84.5", "cm"),
    Measurement("Hips", "96.0", "96.8", "cm"),
    Measurement("Left Arm", "36.5", "35.8", "cm"),
    Measurement("Right Arm", "37.0", "36.2", "cm"),
    Measurement("Left Thigh", "58.0", "57.5", "cm"),
    Measurement("Right Thigh", "58.5", "57.8", "cm")
)

private data class Measurement(val name: String, val current: String, val previous: String, val unit: String)

@Composable
private fun BodyTab() {
    Column(verticalArrangement = Arrangement.spacedBy(10.dp)) {
        measurements.forEach { m ->
            val curr = m.current.toDoubleOrNull() ?: 0.0
            val prev = m.previous.toDoubleOrNull() ?: 0.0
            val diff = curr - prev
            val diffStr = String.format("%+.1f", diff)
            val diffColor = when {
                diff < 0 -> Success
                diff > 0 -> Warning
                else -> TextSubtle
            }

            Row(
                modifier = Modifier
                    .fillMaxWidth()
                    .clip(RoundedCornerShape(16.dp))
                    .background(Surface)
                    .padding(16.dp),
                verticalAlignment = Alignment.CenterVertically,
                horizontalArrangement = Arrangement.SpaceBetween
            ) {
                Text(m.name, fontSize = 15.sp, fontWeight = FontWeight.Medium, color = Text)
                Row(verticalAlignment = Alignment.CenterVertically) {
                    Text("${m.current} ${m.unit}", fontSize = 16.sp, fontWeight = FontWeight.SemiBold, color = Text)
                    Spacer(modifier = Modifier.width(12.dp))
                    Text(diffStr, fontSize = 13.sp, fontWeight = FontWeight.Medium, color = diffColor, modifier = Modifier.width(50.dp))
                }
            }
        }
    }
}

// ---------- Photos Tab ----------

private val progressPhotos = listOf(
    PhotoItem("Progress", "Feb 1", "accent"),
    PhotoItem("Front", "Feb 15", "primary"),
    PhotoItem("Back", "Mar 1", "warning"),
    PhotoItem("Side", "Mar 15", "success")
)

private data class PhotoItem(val label: String, val date: String, val colorName: String)

@OptIn(ExperimentalLayoutApi::class)
@Composable
private fun PhotosTab() {
    Column(verticalArrangement = Arrangement.spacedBy(16.dp)) {
        // Start / Current row
        Row(modifier = Modifier.fillMaxWidth(), horizontalArrangement = Arrangement.spacedBy(12.dp)) {
            PhotoPlaceholder("Start", "Feb 1, 26", TextSubtle, modifier = Modifier.weight(1f))
            PhotoPlaceholder("Current", "Apr 21", Primary, modifier = Modifier.weight(1f))
        }

        // Timeline grid
        Column(
            modifier = Modifier
                .fillMaxWidth()
                .clip(RoundedCornerShape(16.dp))
                .background(Surface)
                .padding(16.dp)
        ) {
            Text("PHOTO TIMELINE", fontSize = 12.sp, fontWeight = FontWeight.SemiBold, color = TextSubtle, letterSpacing = 1.2.sp)
            Spacer(modifier = Modifier.height(12.dp))

            FlowRow(
                modifier = Modifier.fillMaxWidth(),
                horizontalArrangement = Arrangement.spacedBy(12.dp),
                verticalArrangement = Arrangement.spacedBy(12.dp),
                maxItemsInEachRow = 3
            ) {
                progressPhotos.forEach { photo ->
                    PhotoCard(photo, modifier = Modifier.weight(1f))
                }
                // Add button
                Column(
                    modifier = Modifier
                        .weight(1f)
                        .aspectRatio(1f)
                        .clip(RoundedCornerShape(12.dp))
                        .background(Surface2)
                        .border(1.dp, Primary.copy(alpha = 0.3f), RoundedCornerShape(12.dp))
                        .clickable { },
                    horizontalAlignment = Alignment.CenterHorizontally,
                    verticalArrangement = Arrangement.Center
                ) {
                    Icon(Icons.Default.Add, contentDescription = null, tint = Primary, modifier = Modifier.size(24.dp))
                    Text("Add", fontSize = 13.sp, fontWeight = FontWeight.Medium, color = Primary)
                }
            }
        }
    }
}

@Composable
private fun PhotoPlaceholder(label: String, date: String, color: androidx.compose.ui.graphics.Color, modifier: Modifier = Modifier) {
    Column(
        modifier = modifier,
        horizontalAlignment = Alignment.CenterHorizontally
    ) {
        Box(
            modifier = Modifier
                .fillMaxWidth()
                .height(140.dp)
                .clip(RoundedCornerShape(12.dp))
                .background(color.copy(alpha = 0.12f)),
            contentAlignment = Alignment.Center
        ) {
            Column(horizontalAlignment = Alignment.CenterHorizontally) {
                Icon(Icons.Default.Add, contentDescription = null, tint = color, modifier = Modifier.size(32.dp))
                Text(label, fontSize = 14.sp, fontWeight = FontWeight.SemiBold, color = color)
            }
        }
        Spacer(modifier = Modifier.height(4.dp))
        Text(date, fontSize = 12.sp, color = TextMuted)
    }
}

@Composable
private fun PhotoCard(photo: PhotoItem, modifier: Modifier = Modifier) {
    val color = when (photo.colorName) {
        "accent" -> Accent
        "warning" -> Warning
        "success" -> Success
        else -> Primary
    }
    Column(
        modifier = modifier.aspectRatio(1f),
        horizontalAlignment = Alignment.CenterHorizontally
    ) {
        Box(
            modifier = Modifier
                .fillMaxWidth()
                .weight(1f)
                .clip(RoundedCornerShape(12.dp))
                .background(color.copy(alpha = 0.15f)),
            contentAlignment = Alignment.Center
        ) {
            Icon(Icons.Default.Check, contentDescription = null, tint = color, modifier = Modifier.size(28.dp))
        }
        Spacer(modifier = Modifier.height(4.dp))
        Text(photo.label, fontSize = 13.sp, fontWeight = FontWeight.SemiBold, color = Text)
        Text(photo.date, fontSize = 11.sp, color = TextMuted)
    }
}
