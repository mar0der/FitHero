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
fun AddPaymentMethodSheet(
    onDismiss: () -> Unit,
    onAdd: (brand: String, lastFour: String, expiryMonth: String, expiryYear: String) -> Unit
) {
    var cardNumber by remember { mutableStateOf("") }
    var expiry by remember { mutableStateOf("") }
    var cvc by remember { mutableStateOf("") }
    val bg = Color(0xFF0B0D10)
    val surface = Color(0xFF14181D)
    val voltGreen = Color(0xFFC6FF3D)
    val isValid = cardNumber.length >= 16 && expiry.length == 5 && cvc.length >= 3

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
                    Text("Add Payment Method", color = Color.White, fontSize = 18.sp, fontWeight = FontWeight.Bold)
                    IconButton(onClick = onDismiss) {
                        Icon(Icons.Filled.Close, "Close", tint = Color.Gray)
                    }
                }
                Spacer(Modifier.height(16.dp))

                OutlinedTextField(
                    value = cardNumber,
                    onValueChange = { if (it.length <= 19) cardNumber = it.filter { c -> c.isDigit() } },
                    label = { Text("Card Number") },
                    singleLine = true,
                    keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Number),
                    colors = textFieldColors(),
                    modifier = Modifier.fillMaxWidth()
                )
                Spacer(Modifier.height(12.dp))
                Row(horizontalArrangement = Arrangement.spacedBy(12.dp)) {
                    OutlinedTextField(
                        value = expiry,
                        onValueChange = {
                            val raw = it.filter { c -> c.isDigit() }
                            expiry = when {
                                raw.length >= 2 -> "${raw.take(2)}/${raw.drop(2).take(2)}"
                                else -> raw
                            }
                        },
                        label = { Text("MM/YY") },
                        singleLine = true,
                        keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Number),
                        colors = textFieldColors(),
                        modifier = Modifier.weight(1f)
                    )
                    OutlinedTextField(
                        value = cvc,
                        onValueChange = { if (it.length <= 4) cvc = it.filter { c -> c.isDigit() } },
                        label = { Text("CVC") },
                        singleLine = true,
                        keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Number),
                        colors = textFieldColors(),
                        modifier = Modifier.weight(1f)
                    )
                }
                Spacer(Modifier.height(20.dp))
                Button(
                    onClick = {
                        val brand = when (cardNumber.firstOrNull()) {
                            '4' -> "Visa"
                            '5' -> "Mastercard"
                            '3' -> "Amex"
                            else -> "Card"
                        }
                        val parts = expiry.split("/")
                        onAdd(brand, cardNumber.takeLast(4), parts.getOrElse(0) { "" }, "20${parts.getOrElse(1) { "" }}")
                    },
                    enabled = isValid,
                    colors = ButtonDefaults.buttonColors(
                        containerColor = voltGreen,
                        disabledContainerColor = Color(0xFF3A3A3A),
                        contentColor = Color.Black,
                        disabledContentColor = Color.Gray
                    ),
                    shape = RoundedCornerShape(10.dp),
                    modifier = Modifier.fillMaxWidth()
                ) {
                    Text("Add Card", fontSize = 16.sp, modifier = Modifier.padding(vertical = 4.dp))
                }
            }
        }
    }
}

@OptIn(ExperimentalMaterial3Api::class)
@Composable
private fun textFieldColors() = OutlinedTextFieldDefaults.colors(
    focusedBorderColor = Color(0xFFC6FF3D),
    unfocusedBorderColor = Color(0xFF2A2F35),
    focusedLabelColor = Color(0xFFC6FF3D),
    unfocusedLabelColor = Color.Gray,
    focusedTextColor = Color.White,
    unfocusedTextColor = Color.White,
    cursorColor = Color(0xFFC6FF3D),
    focusedContainerColor = Color(0xFF0B0D10),
    unfocusedContainerColor = Color(0xFF0B0D10),
)
