package com.fithero.ui.screens

import android.net.Uri
import androidx.activity.compose.rememberLauncherForActivityResult
import androidx.activity.result.PickVisualMediaRequest
import androidx.activity.result.contract.ActivityResultContracts
import androidx.compose.animation.*
import androidx.compose.foundation.background
import androidx.compose.foundation.border
import androidx.compose.foundation.clickable
import androidx.compose.foundation.gestures.detectTapGestures
import androidx.compose.foundation.gestures.detectTransformGestures
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.itemsIndexed
import androidx.compose.foundation.lazy.rememberLazyListState
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.foundation.text.BasicTextField
import androidx.compose.foundation.text.KeyboardActions
import androidx.compose.foundation.text.KeyboardOptions
import androidx.compose.foundation.verticalScroll
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.automirrored.filled.ArrowBack
import androidx.compose.material.icons.automirrored.filled.Send
import androidx.compose.material.icons.filled.AddPhotoAlternate
import androidx.compose.material.icons.filled.Close
import androidx.compose.material.icons.filled.Videocam
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.material3.Text
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.focus.FocusManager
import androidx.compose.ui.geometry.Offset
import androidx.compose.ui.graphics.Brush
import androidx.compose.ui.graphics.graphicsLayer
import androidx.compose.ui.hapticfeedback.HapticFeedbackType
import androidx.compose.ui.input.pointer.pointerInput
import androidx.compose.ui.platform.LocalFocusManager
import androidx.compose.ui.platform.LocalHapticFeedback
import androidx.compose.ui.platform.LocalSoftwareKeyboardController
import androidx.compose.ui.text.TextStyle
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.input.ImeAction
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.fithero.ui.theme.Accent
import com.fithero.ui.theme.Bg
import com.fithero.ui.theme.Border
import com.fithero.ui.theme.Primary
import com.fithero.ui.theme.PrimaryInk
import com.fithero.ui.theme.Success
import com.fithero.ui.theme.Surface
import com.fithero.ui.theme.Surface2
import com.fithero.ui.theme.Text
import com.fithero.ui.theme.TextMuted
import com.fithero.ui.theme.TextSubtle

// ---------- Data ----------

private data class ChatMessage(
    val id: Int,
    val text: String,
    val time: String,
    val isFromTrainer: Boolean,
    val isPhoto: Boolean = false,
    val imageUri: String? = null
)

private val defaultMessages = listOf(
    ChatMessage(1, "Hey Alex! Ready for today's upper body session?", "08:30", true),
    ChatMessage(2, "Yes! Feeling strong today 💪", "08:32", false),
    ChatMessage(3, "Great session yesterday! Your bench press form was on point.", "09:15", true),
    ChatMessage(4, "Thanks! I felt really stable on the last set.", "09:20", false),
    ChatMessage(5, "", "09:20", false, isPhoto = true),
    ChatMessage(6, "Let's aim for 82.5 kg today. You've got this.", "09:21", true),
    ChatMessage(7, "Deal. See you at the studio!", "09:22", false)
)

private fun formatTime(): String =
    java.text.SimpleDateFormat("HH:mm", java.util.Locale.getDefault()).format(java.util.Date())

// ---------- Screen ----------

@Composable
fun MessagesScreen(
    modifier: Modifier = Modifier,
    partnerName: String = "Maya",
    partnerInitial: String = "M",
    isTrainerContext: Boolean = false,
    onBack: (() -> Unit)? = null
) {
    var inputText by remember { mutableStateOf("") }
    var messages by remember { mutableStateOf(defaultMessages) }
    var showVideoCallAlert by remember { mutableStateOf(false) }
    var showSendPreview by remember { mutableStateOf(false) }
    var pendingUris by remember { mutableStateOf<List<Uri>>(emptyList()) }
    var pendingCaption by remember { mutableStateOf("") }
    var showGallery by remember { mutableStateOf(false) }
    var galleryStartIndex by remember { mutableIntStateOf(0) }

    val haptic = LocalHapticFeedback.current
    val focusManager = LocalFocusManager.current
    val keyboardController = LocalSoftwareKeyboardController.current
    val listState = rememberLazyListState()

    val photoMessages = remember(messages) { messages.filter { it.isPhoto } }

    LaunchedEffect(messages.size) {
        if (messages.isNotEmpty()) {
            listState.animateScrollToItem(messages.size - 1)
        }
    }

    val photoPicker = rememberLauncherForActivityResult(
        contract = ActivityResultContracts.PickMultipleVisualMedia(maxItems = 5)
    ) { uris ->
        if (uris.isNotEmpty()) {
            pendingUris = uris
            pendingCaption = ""
            showSendPreview = true
        }
    }

    fun sendPending() {
        haptic.performHapticFeedback(HapticFeedbackType.LongPress)
        val nextId = (messages.maxOfOrNull { it.id } ?: 0) + 1
        var idCounter = nextId

        pendingUris.forEach { uri ->
            messages = messages + ChatMessage(
                id = idCounter++,
                text = "",
                time = formatTime(),
                isFromTrainer = isTrainerContext,
                isPhoto = true,
                imageUri = uri.toString()
            )
        }
        if (pendingCaption.isNotBlank()) {
            messages = messages + ChatMessage(
                id = idCounter++,
                text = pendingCaption.trim(),
                time = formatTime(),
                isFromTrainer = isTrainerContext
            )
        }
        pendingUris = emptyList()
        pendingCaption = ""
        showSendPreview = false
    }

    fun cancelPending() {
        pendingUris = emptyList()
        pendingCaption = ""
        showSendPreview = false
    }

    Box(modifier = modifier.fillMaxSize().background(Bg).imePadding()) {
        Column(modifier = Modifier.fillMaxSize()) {
            ChatHeader(
                partnerName = partnerName,
                partnerInitial = partnerInitial,
                showBackButton = onBack != null,
                onBack = onBack,
                onVideoCall = {
                    haptic.performHapticFeedback(HapticFeedbackType.LongPress)
                    showVideoCallAlert = true
                }
            )
            Spacer(modifier = Modifier.height(1.dp).fillMaxWidth().background(Border))

            LazyColumn(
                state = listState,
                modifier = Modifier
                    .weight(1f)
                    .fillMaxWidth()
                    .padding(horizontal = 16.dp)
                    .pointerInput(Unit) {
                        detectTapGestures(onTap = {
                            focusManager.clearFocus()
                            keyboardController?.hide()
                        })
                    },
                contentPadding = PaddingValues(vertical = 16.dp),
                verticalArrangement = Arrangement.spacedBy(12.dp)
            ) {
                item {
                    Box(modifier = Modifier.fillMaxWidth(), contentAlignment = Alignment.Center) {
                        Text("Today", fontSize = 12.sp, fontWeight = FontWeight.Medium, color = TextSubtle)
                    }
                }
                itemsIndexed(messages, key = { _, m -> m.id }) { _, message ->
                    val photoIndex = if (message.isPhoto) photoMessages.indexOfFirst { it.id == message.id } else -1
                    MessageBubble(
                        message = message,
                        isTrainerContext = isTrainerContext,
                        onPhotoTap = if (photoIndex >= 0) {
                            { galleryStartIndex = photoIndex; showGallery = true }
                        } else null
                    )
                }
            }

            Spacer(modifier = Modifier.height(1.dp).fillMaxWidth().background(Border))

            ChatInputBar(
                inputText = inputText,
                onInputChange = { inputText = it },
                onSend = {
                    if (inputText.isNotBlank()) {
                        haptic.performHapticFeedback(HapticFeedbackType.LongPress)
                        val newId = (messages.maxOfOrNull { it.id } ?: 0) + 1
                        messages = messages + ChatMessage(
                            id = newId, text = inputText, time = formatTime(),
                            isFromTrainer = isTrainerContext
                        )
                        inputText = ""
                    }
                },
                onAttachPhoto = {
                    haptic.performHapticFeedback(HapticFeedbackType.LongPress)
                    photoPicker.launch(PickVisualMediaRequest(ActivityResultContracts.PickVisualMedia.ImageOnly))
                },
                focusManager = focusManager,
                keyboardController = keyboardController
            )
        }

        if (showVideoCallAlert) {
            VideoCallDialog(onDismiss = { showVideoCallAlert = false })
        }

        if (showSendPreview) {
            ImageSendPreviewSheet(
                uris = pendingUris,
                caption = pendingCaption,
                onCaptionChange = { pendingCaption = it },
                onSend = { sendPending() },
                onCancel = { cancelPending() }
            )
        }

        if (showGallery) {
            PhotoGalleryOverlay(
                photoMessages = photoMessages,
                startIndex = galleryStartIndex,
                onDismiss = { showGallery = false }
            )
        }
    }
}

// ---------- Header ----------

@Composable
private fun ChatHeader(
    partnerName: String,
    partnerInitial: String,
    showBackButton: Boolean,
    onBack: (() -> Unit)?,
    onVideoCall: () -> Unit = {}
) {
    Row(
        modifier = Modifier.fillMaxWidth().padding(16.dp),
        verticalAlignment = Alignment.CenterVertically
    ) {
        if (showBackButton && onBack != null) {
            IconButton(onClick = onBack) {
                Icon(Icons.AutoMirrored.Filled.ArrowBack, contentDescription = null, tint = TextMuted)
            }
            Spacer(modifier = Modifier.width(4.dp))
        }
        Box(
            modifier = Modifier.size(44.dp).clip(CircleShape).background(Accent.copy(alpha = 0.15f)),
            contentAlignment = Alignment.Center
        ) {
            Text(partnerInitial, fontSize = 17.sp, fontWeight = FontWeight.SemiBold, color = Accent)
        }
        Spacer(modifier = Modifier.width(12.dp))
        Column(modifier = Modifier.weight(1f)) {
            Text(partnerName, fontSize = 17.sp, fontWeight = FontWeight.SemiBold, color = Text)
            Row(verticalAlignment = Alignment.CenterVertically) {
                Box(modifier = Modifier.size(7.dp).clip(CircleShape).background(Success))
                Spacer(modifier = Modifier.width(4.dp))
                Text("Online", fontSize = 12.sp, color = Success)
            }
        }
        Box(
            modifier = Modifier.size(40.dp).clip(CircleShape).background(Surface).clickable(onClick = onVideoCall),
            contentAlignment = Alignment.Center
        ) {
            Icon(Icons.Default.Videocam, contentDescription = null, tint = TextMuted, modifier = Modifier.size(18.dp))
        }
    }
}

// ---------- Message Bubble ----------

@Composable
private fun MessageBubble(
    message: ChatMessage,
    isTrainerContext: Boolean,
    onPhotoTap: (() -> Unit)?
) {
    val isTrainer = message.isFromTrainer
    val isRightSide = if (isTrainerContext) isTrainer else !isTrainer

    Row(
        modifier = Modifier.fillMaxWidth(),
        horizontalArrangement = if (isRightSide) Arrangement.End else Arrangement.Start
    ) {
        if (isRightSide) Spacer(modifier = Modifier.width(48.dp))

        Column(horizontalAlignment = if (isRightSide) Alignment.End else Alignment.Start) {
            if (message.isPhoto) {
                PhotoBubble(onTap = onPhotoTap ?: {}, isRightSide = isRightSide)
            } else {
                Text(
                    text = message.text,
                    fontSize = 15.sp,
                    color = if (isRightSide) PrimaryInk else Text,
                    modifier = Modifier
                        .clip(RoundedCornerShape(16.dp))
                        .background(if (isRightSide) Primary else Surface)
                        .padding(horizontal = 14.dp, vertical = 10.dp)
                )
            }
            // Caption below photo
            if (message.isPhoto && message.text.isNotEmpty()) {
                Spacer(modifier = Modifier.height(2.dp))
                Text(
                    text = message.text,
                    fontSize = 14.sp,
                    color = if (isRightSide) PrimaryInk else Text,
                    modifier = Modifier
                        .clip(RoundedCornerShape(12.dp))
                        .background(if (isRightSide) Primary else Surface)
                        .padding(horizontal = 12.dp, vertical = 8.dp)
                )
            }
            Spacer(modifier = Modifier.height(2.dp))
            Text(message.time, fontSize = 11.sp, color = TextSubtle)
        }

        if (!isRightSide) Spacer(modifier = Modifier.width(48.dp))
    }
}

@Composable
private fun PhotoBubble(onTap: () -> Unit, isRightSide: Boolean) {
    val gradient = Brush.linearGradient(
        colors = listOf(
            if (isRightSide) Primary.copy(alpha = 0.5f) else Surface2,
            if (isRightSide) Primary.copy(alpha = 0.2f) else Surface2.copy(alpha = 0.6f)
        )
    )
    Box(
        modifier = Modifier
            .width(200.dp)
            .height(200.dp)
            .clip(RoundedCornerShape(16.dp))
            .background(gradient)
            .border(1.dp, if (isRightSide) Primary.copy(alpha = 0.5f) else Border, RoundedCornerShape(16.dp))
            .clickable(onClick = onTap),
        contentAlignment = Alignment.Center
    ) {
        Icon(Icons.Default.AddPhotoAlternate, contentDescription = null, tint = if (isRightSide) PrimaryInk else TextMuted, modifier = Modifier.size(48.dp))
    }
}

// ---------- Input Bar ----------

@Composable
private fun ChatInputBar(
    inputText: String,
    onInputChange: (String) -> Unit,
    onSend: () -> Unit,
    onAttachPhoto: () -> Unit = {},
    focusManager: FocusManager,
    keyboardController: androidx.compose.ui.platform.SoftwareKeyboardController?
) {
    Row(
        modifier = Modifier.fillMaxWidth().padding(16.dp),
        verticalAlignment = Alignment.CenterVertically
    ) {
        IconButton(onClick = onAttachPhoto) {
            Icon(Icons.Default.AddPhotoAlternate, contentDescription = null, tint = TextMuted, modifier = Modifier.size(22.dp))
        }
        Spacer(modifier = Modifier.width(4.dp))
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
            keyboardOptions = KeyboardOptions(imeAction = ImeAction.Send),
            keyboardActions = KeyboardActions(onSend = {
                focusManager.clearFocus()
                keyboardController?.hide()
                onSend()
            }),
            decorationBox = { innerTextField ->
                if (inputText.isEmpty()) Text("Message", fontSize = 15.sp, color = TextMuted)
                innerTextField()
            }
        )
        Spacer(modifier = Modifier.width(8.dp))
        IconButton(onClick = {
            focusManager.clearFocus()
            keyboardController?.hide()
            onSend()
        }, enabled = inputText.isNotEmpty()) {
            Icon(
                Icons.AutoMirrored.Filled.Send,
                contentDescription = null,
                tint = if (inputText.isEmpty()) TextSubtle else Primary,
                modifier = Modifier.size(28.dp)
            )
        }
    }
}

// ---------- Video Call Dialog ----------

@Composable
private fun VideoCallDialog(onDismiss: () -> Unit) {
    androidx.compose.ui.window.Dialog(onDismissRequest = onDismiss) {
        Box(
            modifier = Modifier
                .fillMaxSize()
                .background(Bg.copy(alpha = 0.85f))
                .clickable(onClick = onDismiss),
            contentAlignment = Alignment.Center
        ) {
            Column(
                modifier = Modifier
                    .fillMaxWidth(0.85f)
                    .clip(RoundedCornerShape(16.dp))
                    .background(Surface)
                    .padding(24.dp),
                horizontalAlignment = Alignment.CenterHorizontally
            ) {
                Text("Video Call", color = Text, fontSize = 18.sp, fontWeight = FontWeight.Bold)
                Spacer(modifier = Modifier.height(8.dp))
                Text("Starting video call...", color = TextMuted, fontSize = 14.sp, textAlign = TextAlign.Center)
                Spacer(modifier = Modifier.height(16.dp))
                Box(
                    modifier = Modifier
                        .clip(RoundedCornerShape(10.dp))
                        .background(Primary)
                        .clickable { onDismiss() }
                        .padding(horizontal = 24.dp, vertical = 10.dp)
                ) {
                    Text("OK", fontSize = 15.sp, fontWeight = FontWeight.SemiBold, color = PrimaryInk)
                }
            }
        }
    }
}

// ---------- Image Send Preview Sheet ----------

@Composable
private fun ImageSendPreviewSheet(
    uris: List<Uri>,
    caption: String,
    onCaptionChange: (String) -> Unit,
    onSend: () -> Unit,
    onCancel: () -> Unit
) {
    var selectedIndex by remember { mutableIntStateOf(0) }
    val focusManager = LocalFocusManager.current
    val keyboardController = LocalSoftwareKeyboardController.current

    Box(
        modifier = Modifier
            .fillMaxSize()
            .background(Bg.copy(alpha = 0.9f))
            .clickable(onClick = onCancel),
        contentAlignment = Alignment.Center
    ) {
        Column(
            modifier = Modifier
                .fillMaxSize()
                .clickable(enabled = false) { }
                .padding(top = 48.dp, bottom = 24.dp)
                .padding(horizontal = 16.dp)
        ) {
            // Nav bar
            Row(
                modifier = Modifier.fillMaxWidth(),
                horizontalArrangement = Arrangement.SpaceBetween,
                verticalAlignment = Alignment.CenterVertically
            ) {
                Text(
                    "Cancel",
                    fontSize = 15.sp,
                    fontWeight = FontWeight.Medium,
                    color = TextMuted,
                    modifier = Modifier.clickable { onCancel() }
                )
                Text(
                    if (uris.size == 1) "Send Photo" else "Send ${uris.size} Photos",
                    fontSize = 16.sp,
                    fontWeight = FontWeight.SemiBold,
                    color = Text
                )
                Text(
                    "Send",
                    fontSize = 15.sp,
                    fontWeight = FontWeight.SemiBold,
                    color = Primary,
                    modifier = Modifier.clickable { onSend() }
                )
            }
            Spacer(modifier = Modifier.height(20.dp))

            // Main preview
            Box(
                modifier = Modifier
                    .fillMaxWidth()
                    .weight(1f)
                    .clip(RoundedCornerShape(16.dp))
                    .background(Surface2)
                    .border(1.dp, Border, RoundedCornerShape(16.dp)),
                contentAlignment = Alignment.Center
            ) {
                Text("Photo ${selectedIndex + 1}", fontSize = 18.sp, fontWeight = FontWeight.SemiBold, color = Text)
            }
            Spacer(modifier = Modifier.height(16.dp))

            // Thumbnail strip (if multiple)
            if (uris.size > 1) {
                Row(
                    modifier = Modifier.fillMaxWidth(),
                    horizontalArrangement = Arrangement.spacedBy(8.dp)
                ) {
                    uris.forEachIndexed { index, _ ->
                        Box(
                            modifier = Modifier
                                .size(64.dp)
                                .clip(RoundedCornerShape(10.dp))
                                .background(if (index == selectedIndex) Primary.copy(alpha = 0.2f) else Surface2)
                                .border(
                                    if (index == selectedIndex) 2.dp else 1.dp,
                                    if (index == selectedIndex) Primary else Border,
                                    RoundedCornerShape(10.dp)
                                )
                                .clickable { selectedIndex = index },
                            contentAlignment = Alignment.Center
                        ) {
                            Text("${index + 1}", fontSize = 14.sp, fontWeight = FontWeight.SemiBold, color = if (index == selectedIndex) Primary else TextMuted)
                        }
                    }
                }
                Spacer(modifier = Modifier.height(16.dp))
            }

            // Caption + Send
            Row(
                modifier = Modifier.fillMaxWidth(),
                verticalAlignment = Alignment.CenterVertically
            ) {
                BasicTextField(
                    value = caption,
                    onValueChange = onCaptionChange,
                    modifier = Modifier
                        .weight(1f)
                        .clip(RoundedCornerShape(999.dp))
                        .background(Surface)
                        .border(1.dp, Border, RoundedCornerShape(999.dp))
                        .padding(horizontal = 16.dp, vertical = 12.dp),
                    textStyle = TextStyle(fontSize = 15.sp, color = Text),
                    keyboardOptions = KeyboardOptions(imeAction = ImeAction.Send),
                    keyboardActions = KeyboardActions(onSend = {
                        focusManager.clearFocus()
                        keyboardController?.hide()
                        onSend()
                    }),
                    decorationBox = { innerTextField ->
                        if (caption.isEmpty()) Text("Add a caption...", fontSize = 15.sp, color = TextMuted)
                        innerTextField()
                    }
                )
                Spacer(modifier = Modifier.width(8.dp))
                Box(
                    modifier = Modifier
                        .size(44.dp)
                        .clip(CircleShape)
                        .background(Primary)
                        .clickable { onSend() },
                    contentAlignment = Alignment.Center
                ) {
                    Icon(Icons.AutoMirrored.Filled.Send, contentDescription = null, tint = PrimaryInk, modifier = Modifier.size(22.dp))
                }
            }
        }
    }
}

// ---------- Photo Gallery Overlay ----------

@Composable
private fun PhotoGalleryOverlay(
    photoMessages: List<ChatMessage>,
    startIndex: Int,
    onDismiss: () -> Unit
) {
    var currentIndex by remember { mutableIntStateOf(startIndex.coerceIn(0, (photoMessages.size - 1).coerceAtLeast(0))) }
    var scale by remember { mutableFloatStateOf(1f) }
    var offset by remember { mutableStateOf(Offset.Zero) }

    val isZoomed = scale > 1.05f

    Box(
        modifier = Modifier
            .fillMaxSize()
            .background(Bg.copy(alpha = 0.98f))
            .pointerInput(Unit) {
                detectTapGestures(
                    onDoubleTap = {
                        scale = if (scale > 1.05f) 1f else 2.5f
                        offset = Offset.Zero
                    },
                    onTap = {
                        if (!isZoomed) onDismiss()
                    }
                )
            }
    ) {
        if (photoMessages.isEmpty()) {
            Box(modifier = Modifier.fillMaxSize(), contentAlignment = Alignment.Center) {
                Text("No photos", color = TextMuted)
            }
            return
        }

        // Top bar
        Row(
            modifier = Modifier
                .fillMaxWidth()
                .padding(16.dp)
                .align(Alignment.TopCenter),
            horizontalArrangement = Arrangement.SpaceBetween,
            verticalAlignment = Alignment.CenterVertically
        ) {
            Text(
                "${currentIndex + 1} of ${photoMessages.size}",
                color = TextMuted,
                fontSize = 15.sp,
                fontWeight = FontWeight.SemiBold
            )
            IconButton(onClick = onDismiss) {
                Icon(Icons.Default.Close, contentDescription = null, tint = TextMuted)
            }
        }

        // Image area with zoom
        Box(
            modifier = Modifier
                .fillMaxWidth()
                .fillMaxHeight(0.75f)
                .align(Alignment.Center)
                .pointerInput(Unit) {
                    detectTransformGestures { _, pan, zoom, _ ->
                        scale = (scale * zoom).coerceIn(1f, 4f)
                        offset = if (scale == 1f) Offset.Zero else offset + pan
                    }
                }
                .graphicsLayer(
                    scaleX = scale,
                    scaleY = scale,
                    translationX = offset.x,
                    translationY = offset.y
                ),
            contentAlignment = Alignment.Center
        ) {
            val msg = photoMessages.getOrNull(currentIndex)
            Box(
                modifier = Modifier
                    .fillMaxWidth(0.9f)
                    .fillMaxHeight()
                    .clip(RoundedCornerShape(16.dp))
                    .background(Surface2)
                    .border(1.dp, Border, RoundedCornerShape(16.dp)),
                contentAlignment = Alignment.Center
            ) {
                Column(horizontalAlignment = Alignment.CenterHorizontally) {
                    Icon(Icons.Default.AddPhotoAlternate, contentDescription = null, tint = Primary, modifier = Modifier.size(64.dp))
                    Spacer(modifier = Modifier.height(12.dp))
                    Text("Photo ${currentIndex + 1}", fontSize = 18.sp, fontWeight = FontWeight.SemiBold, color = Text)
                    msg?.let {
                        Spacer(modifier = Modifier.height(4.dp))
                        Text(it.time, fontSize = 14.sp, color = TextMuted)
                    }
                }
            }
        }

        // Nav arrows
        if (photoMessages.size > 1 && !isZoomed) {
            Row(
                modifier = Modifier
                    .fillMaxWidth()
                    .padding(horizontal = 16.dp)
                    .align(Alignment.Center),
                horizontalArrangement = Arrangement.SpaceBetween
            ) {
                if (currentIndex > 0) {
                    Box(
                        modifier = Modifier
                            .size(44.dp)
                            .clip(CircleShape)
                            .background(Surface2)
                            .clickable {
                                currentIndex--
                                scale = 1f
                                offset = Offset.Zero
                            },
                        contentAlignment = Alignment.Center
                    ) {
                        Text("‹", fontSize = 24.sp, color = Text)
                    }
                } else {
                    Spacer(modifier = Modifier.size(44.dp))
                }

                if (currentIndex < photoMessages.size - 1) {
                    Box(
                        modifier = Modifier
                            .size(44.dp)
                            .clip(CircleShape)
                            .background(Surface2)
                            .clickable {
                                currentIndex++
                                scale = 1f
                                offset = Offset.Zero
                            },
                        contentAlignment = Alignment.Center
                    ) {
                        Text("›", fontSize = 24.sp, color = Text)
                    }
                } else {
                    Spacer(modifier = Modifier.size(44.dp))
                }
            }
        }

        // Bottom hint
        Text(
            if (isZoomed) "Double-tap to reset zoom" else "Double-tap to zoom · Tap outside to dismiss",
            color = TextMuted,
            fontSize = 12.sp,
            modifier = Modifier.align(Alignment.BottomCenter).padding(bottom = 32.dp)
        )
    }
}
