package com.fithero.ui.screens

import androidx.compose.foundation.background
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.foundation.verticalScroll
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.automirrored.filled.ArrowBack
import androidx.compose.material.icons.filled.Add
import androidx.compose.material.icons.filled.CheckCircle
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp

// ------------------------------------------------------------------
// Models
// ------------------------------------------------------------------

private data class PaymentMethod(
    val brand: String,
    val lastFour: String,
    val expiryMonth: String,
    val expiryYear: String
)

private enum class PaymentStatus { Paid, Pending, Failed }

private data class PaymentHistoryItem(
    val dateLabel: String,
    val amount: String,
    val status: PaymentStatus,
    val description: String,
    val receiptId: String? = null
)

private data class SubscriptionPlan(
    val name: String,
    val amount: String,
    val billingInterval: String,
    val nextBilling: String,
    val status: String
)

private val paymentMethods = mutableStateListOf(
    PaymentMethod("Visa", "4242", "12", "2026"),
    PaymentMethod("Mastercard", "8888", "08", "2027"),
)

private val paymentHistory = listOf(
    PaymentHistoryItem("Today", "$89.00", PaymentStatus.Paid, "Monthly Premium", "R-20250427"),
    PaymentHistoryItem("27 Mar", "$89.00", PaymentStatus.Paid, "Monthly Premium", "R-20250327"),
    PaymentHistoryItem("27 Feb", "$89.00", PaymentStatus.Paid, "Monthly Premium", "R-20250227"),
    PaymentHistoryItem("27 Jan", "$89.00", PaymentStatus.Failed, "Monthly Premium", null),
    PaymentHistoryItem("27 Dec", "$89.00", PaymentStatus.Paid, "Monthly Premium", "R-20241227"),
)

private val currentPlan = SubscriptionPlan("Premium", "$89.00", "month", "27 May 2026", "Active")

// ------------------------------------------------------------------
// Screen
// ------------------------------------------------------------------

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun PaymentsScreen(
    onDismiss: () -> Unit,
    onAddPayment: () -> Unit
) {
    val bg = Color(0xFF0B0D10)
    val surface = Color(0xFF14181D)
    val voltGreen = Color(0xFFC6FF3D)
    var showAddPayment by remember { mutableStateOf(false) }

    Scaffold(
        topBar = {
            TopAppBar(
                title = { Text("Payments", color = Color.White) },
                navigationIcon = {
                    IconButton(onClick = onDismiss) {
                        Icon(Icons.AutoMirrored.Filled.ArrowBack, "Back", tint = Color.White)
                    }
                },
                colors = TopAppBarDefaults.topAppBarColors(containerColor = bg)
            )
        },
        containerColor = bg
    ) { pad ->
        Column(
            modifier = Modifier
                .padding(pad)
                .verticalScroll(rememberScrollState())
                .padding(16.dp)
        ) {
            // Plan card
            Surface(color = surface, shape = RoundedCornerShape(12.dp), modifier = Modifier.fillMaxWidth()) {
                Column(modifier = Modifier.padding(16.dp)) {
                    Row(
                        modifier = Modifier.fillMaxWidth(),
                        horizontalArrangement = Arrangement.SpaceBetween
                    ) {
                        Text(currentPlan.name, color = Color.White, fontSize = 18.sp, fontWeight = FontWeight.Bold)
                        Surface(color = Color(0xFF1A3D1A), shape = RoundedCornerShape(6.dp)) {
                            Text(currentPlan.status, color = voltGreen, fontSize = 12.sp, modifier = Modifier.padding(horizontal = 8.dp, vertical = 4.dp))
                        }
                    }
                    Spacer(Modifier.height(8.dp))
                    Text("${currentPlan.amount} / ${currentPlan.billingInterval}", color = Color.LightGray, fontSize = 14.sp)
                    Spacer(Modifier.height(4.dp))
                    Text("Next billing: ${currentPlan.nextBilling}", color = Color.Gray, fontSize = 12.sp)
                }
            }
            Spacer(Modifier.height(24.dp))

            // Payment methods
            Row(
                modifier = Modifier.fillMaxWidth(),
                horizontalArrangement = Arrangement.SpaceBetween,
                verticalAlignment = Alignment.CenterVertically
            ) {
                Text("Payment Methods", color = Color.White, fontSize = 16.sp, fontWeight = FontWeight.SemiBold)
                TextButton(onClick = { showAddPayment = true }) {
                    Text("Add", color = voltGreen, fontSize = 14.sp)
                }
            }
            Spacer(Modifier.height(8.dp))
            paymentMethods.forEach { pm ->
                PaymentMethodRow(pm, surface)
                Spacer(Modifier.height(8.dp))
            }
            Spacer(Modifier.height(24.dp))

            // History
            Text("Payment History", color = Color.White, fontSize = 16.sp, fontWeight = FontWeight.SemiBold)
            Spacer(Modifier.height(8.dp))
            paymentHistory.forEach { ph ->
                PaymentHistoryRow(ph, surface, voltGreen)
                Spacer(Modifier.height(8.dp))
            }
        }
    }

    if (showAddPayment) {
        AddPaymentMethodSheet(
            onDismiss = { showAddPayment = false },
            onAdd = { brand, lastFour, month, year ->
                paymentMethods.add(PaymentMethod(brand, lastFour, month, year))
                showAddPayment = false
            }
        )
    }
}

@Composable
private fun PaymentMethodRow(pm: PaymentMethod, surface: Color) {
    Surface(color = surface, shape = RoundedCornerShape(10.dp), modifier = Modifier.fillMaxWidth()) {
        Row(
            modifier = Modifier.padding(12.dp),
            verticalAlignment = Alignment.CenterVertically,
            horizontalArrangement = Arrangement.SpaceBetween
        ) {
            Column {
                Text("${pm.brand} ending in ${pm.lastFour}", color = Color.White, fontSize = 14.sp)
                Text("Expires ${pm.expiryMonth}/${pm.expiryYear}", color = Color.Gray, fontSize = 12.sp)
            }
            Icon(Icons.Filled.CheckCircle, "Default", tint = Color(0xFFC6FF3D))
        }
    }
}

@Composable
private fun PaymentHistoryRow(ph: PaymentHistoryItem, surface: Color, voltGreen: Color) {
    val statusColor = when (ph.status) {
        PaymentStatus.Paid -> voltGreen
        PaymentStatus.Pending -> Color(0xFFFFA500)
        PaymentStatus.Failed -> Color(0xFFFF4444)
    }
    Surface(color = surface, shape = RoundedCornerShape(10.dp), modifier = Modifier.fillMaxWidth()) {
        Row(
            modifier = Modifier.padding(12.dp),
            verticalAlignment = Alignment.CenterVertically,
            horizontalArrangement = Arrangement.SpaceBetween
        ) {
            Column {
                Text(ph.description, color = Color.White, fontSize = 14.sp)
                Text(ph.dateLabel, color = Color.Gray, fontSize = 12.sp)
            }
            Column(horizontalAlignment = Alignment.End) {
                Text(ph.amount, color = Color.White, fontSize = 14.sp, fontWeight = FontWeight.SemiBold)
                Text(ph.status.name, color = statusColor, fontSize = 12.sp)
            }
        }
    }
}
