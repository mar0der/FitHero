package com.fithero.ui.screens

import androidx.compose.foundation.background
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.foundation.text.KeyboardOptions
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Close
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.input.KeyboardType
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.compose.ui.window.Dialog
import androidx.compose.ui.window.DialogProperties

@Composable
fun AddMeasurementSheet(
    onDismiss: () -> Unit,
    onAdd: (Map<String, String>) -> Unit
) {
    var weight by remember { mutableStateOf("") }
    var bodyFat by remember { mutableStateOf("") }
    var chest by remember { mutableStateOf("") }
    var waist by remember { mutableStateOf("") }
    var hips by remember { mutableStateOf("") }
    var leftArm by remember { mutableStateOf("") }
    var rightArm by remember { mutableStateOf("") }
    var leftThigh by remember { mutableStateOf("") }
    var rightThigh by remember { mutableStateOf("") }
    val surface = Color(0xFF14181D)
    val voltGreen = Color(0xFFC6FF3D)

    Dialog(
        onDismissRequest = onDismiss,
        properties = DialogProperties(usePlatformDefaultWidth = false)
    ) {
        Surface(
            modifier = Modifier
                .fillMaxWidth()
                .padding(16.dp),
            color = surface,
            shape = RoundedCornerShape(16.dp)
        ) {
            Column(modifier = Modifier.padding(20.dp)) {
                Row(
                    modifier = Modifier.fillMaxWidth(),
                    horizontalArrangement = Arrangement.SpaceBetween,
                    verticalAlignment = Alignment.CenterVertically
                ) {
                    Text("Add Measurement", color = Color.White, fontSize = 18.sp, fontWeight = FontWeight.Bold)
                    IconButton(onClick = onDismiss) {
                        Icon(Icons.Filled.Close, "Close", tint = Color.Gray)
                    }
                }
                Spacer(Modifier.height(16.dp))

                Row(horizontalArrangement = Arrangement.spacedBy(12.dp)) {
                    MeasurementField("Weight (kg)", weight, { weight = it }, Modifier.weight(1f))
                    MeasurementField("Body Fat %", bodyFat, { bodyFat = it }, Modifier.weight(1f))
                }
                Spacer(Modifier.height(10.dp))
                Row(horizontalArrangement = Arrangement.spacedBy(12.dp)) {
                    MeasurementField("Chest (cm)", chest, { chest = it }, Modifier.weight(1f))
                    MeasurementField("Waist (cm)", waist, { waist = it }, Modifier.weight(1f))
                }
                Spacer(Modifier.height(10.dp))
                Row(horizontalArrangement = Arrangement.spacedBy(12.dp)) {
                    MeasurementField("Hips (cm)", hips, { hips = it }, Modifier.weight(1f))
                    MeasurementField("L Arm (cm)", leftArm, { leftArm = it }, Modifier.weight(1f))
                }
                Spacer(Modifier.height(10.dp))
                Row(horizontalArrangement = Arrangement.spacedBy(12.dp)) {
                    MeasurementField("R Arm (cm)", rightArm, { rightArm = it }, Modifier.weight(1f))
                    MeasurementField("L Thigh (cm)", leftThigh, { leftThigh = it }, Modifier.weight(1f))
                }
                Spacer(Modifier.height(10.dp))
                MeasurementField("R Thigh (cm)", rightThigh, { rightThigh = it }, Modifier.fillMaxWidth(0.48f))

                Spacer(Modifier.height(20.dp))
                Button(
                    onClick = {
                        val data = buildMap {
                            if (weight.isNotBlank()) put("weight", weight)
                            if (bodyFat.isNotBlank()) put("bodyFat", bodyFat)
                            if (chest.isNotBlank()) put("chest", chest)
                            if (waist.isNotBlank()) put("waist", waist)
                            if (hips.isNotBlank()) put("hips", hips)
                            if (leftArm.isNotBlank()) put("leftArm", leftArm)
                            if (rightArm.isNotBlank()) put("rightArm", rightArm)
                            if (leftThigh.isNotBlank()) put("leftThigh", leftThigh)
                            if (rightThigh.isNotBlank()) put("rightThigh", rightThigh)
                        }
                        onAdd(data)
                    },
                    colors = ButtonDefaults.buttonColors(
                        containerColor = voltGreen,
                        contentColor = Color.Black
                    ),
                    shape = RoundedCornerShape(10.dp),
                    modifier = Modifier.fillMaxWidth()
                ) {
                    Text("Save Measurement", fontSize = 16.sp, modifier = Modifier.padding(vertical = 4.dp))
                }
            }
        }
    }
}

@OptIn(ExperimentalMaterial3Api::class)
@Composable
private fun MeasurementField(
    label: String,
    value: String,
    onChange: (String) -> Unit,
    modifier: Modifier = Modifier
) {
    OutlinedTextField(
        value = value,
        onValueChange = onChange,
        label = { Text(label, fontSize = 12.sp) },
        singleLine = true,
        keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Number),
        colors = OutlinedTextFieldDefaults.colors(
            focusedBorderColor = Color(0xFFC6FF3D),
            unfocusedBorderColor = Color(0xFF2A2F35),
            focusedLabelColor = Color(0xFFC6FF3D),
            unfocusedLabelColor = Color.Gray,
            focusedTextColor = Color.White,
            unfocusedTextColor = Color.White,
            cursorColor = Color(0xFFC6FF3D),
            focusedContainerColor = Color(0xFF0B0D10),
            unfocusedContainerColor = Color(0xFF0B0D10),
        ),
        modifier = modifier
    )
}
