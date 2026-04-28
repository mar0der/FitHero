import SwiftUI
import PhotosUI

struct MessagesView: View {
    let partnerName: String
    let partnerInitial: String
    let isTrainerContext: Bool
    var onBack: (() -> Void)? = nil

    @State private var messages: [ChatMessage]
    @State private var inputText = ""
    @State private var showVideoCallAlert = false
    @State private var showPhotoPicker = false
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var showImageGallery = false
    @State private var galleryStartIndex = 0
    @State private var showSendPreview = false
    @State private var pendingImageData: Data?
    @State private var pendingCaption = ""
    @FocusState private var isInputFocused: Bool

    private var imageMessages: [ChatMessage] {
        messages.filter { $0.imageData != nil }
    }

    init(partnerName: String? = nil, partnerInitial: String? = nil, isTrainerContext: Bool = false, onBack: (() -> Void)? = nil) {
        self.partnerName = partnerName ?? SampleData.trainerName
        self.partnerInitial = partnerInitial ?? SampleData.trainerAvatar
        self.isTrainerContext = isTrainerContext
        self.onBack = onBack
        _messages = State(initialValue: SampleData.messages)
    }

    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                chatHeader
                Divider().background(FH.Colors.border)
                chatBody
                Divider().background(FH.Colors.border)
                inputBar
            }
            .background(FH.Colors.bg)

            if showImageGallery {
                ChatImageGallery(
                    imageMessages: imageMessages,
                    startIndex: galleryStartIndex,
                    onDismiss: { showImageGallery = false }
                )
                .transition(.opacity)
                .zIndex(1)
            }
        }
        .alert("Video Call", isPresented: $showVideoCallAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("Starting video call with \(partnerName)...")
        }
        .photosPicker(isPresented: $showPhotoPicker, selection: $selectedPhoto, matching: .images)
        .onChange(of: selectedPhoto) { _, newItem in
            guard let newItem else { return }
            Task { await loadImageForPreview(from: newItem) }
        }
        .sheet(isPresented: $showSendPreview) {
            ImageSendPreview(
                imageData: pendingImageData,
                caption: $pendingCaption,
                onSend: sendPendingImage,
                onCancel: cancelPendingImage
            )
        }
    }

    // MARK: - Header

    private var chatHeader: some View {
        HStack(spacing: FH.Spacing.md) {
            if let onBack = onBack {
                Button {
                    FHHaptics.light()
                    onBack()
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundStyle(FH.Colors.text)
                        .frame(width: 36, height: 36)
                }
            }

            ZStack {
                Circle()
                    .fill(FH.Colors.accent.opacity(0.15))
                    .frame(width: 40, height: 40)
                Text(partnerInitial)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(FH.Colors.accent)
            }

            VStack(alignment: .leading, spacing: 2) {
                Text(partnerName)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(FH.Colors.text)
                HStack(spacing: 4) {
                    Circle()
                        .fill(FH.Colors.success)
                        .frame(width: 7, height: 7)
                    Text("Online")
                        .font(.system(size: 12))
                        .foregroundStyle(FH.Colors.success)
                }
            }

            Spacer()

            Button {
                FHHaptics.light()
                showVideoCallAlert = true
            } label: {
                Image(systemName: "video.fill")
                    .font(.system(size: 16))
                    .foregroundStyle(FH.Colors.textMuted)
                    .frame(width: 40, height: 40)
                    .background(FH.Colors.surface2)
                    .clipShape(Circle())
            }
        }
        .padding(.horizontal, FH.Spacing.base)
        .padding(.vertical, FH.Spacing.md)
    }

    // MARK: - Chat Body

    private var chatBody: some View {
        ScrollViewReader { proxy in
            ScrollView {
                LazyVStack(spacing: FH.Spacing.md) {
                    Text("Today")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundStyle(FH.Colors.textSubtle)
                        .padding(.vertical, FH.Spacing.sm)
                        .id("top")

                    ForEach(messages) { message in
                        messageBubble(message)
                            .id(message.id)
                    }

                    Color.clear
                        .frame(height: 1)
                        .id("bottom")
                }
                .padding(.horizontal, FH.Spacing.base)
                .padding(.vertical, FH.Spacing.base)
            }
            .onChange(of: messages.count) { _, _ in
                scrollToBottom(proxy: proxy)
            }
            .onAppear {
                scrollToBottom(proxy: proxy)
            }
        }
    }

    private func scrollToBottom(proxy: ScrollViewProxy) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
            withAnimation(.easeOut(duration: 0.25)) {
                proxy.scrollTo("bottom", anchor: .bottom)
            }
        }
    }

    // MARK: - Message Bubble

    private func messageBubble(_ message: ChatMessage) -> some View {
        let isTrainer = message.isFromTrainer
        let alignment: HorizontalAlignment = isTrainer ? .leading : .trailing
        let isFromMe = isTrainerContext ? isTrainer : !isTrainer

        return VStack(alignment: alignment, spacing: FH.Spacing.xs) {
            HStack {
                if !isTrainer { Spacer(minLength: 40) }

                VStack(alignment: isTrainer ? .leading : .trailing, spacing: 4) {
                    if let imageData = message.imageData, let uiImage = UIImage(data: imageData) {
                        chatImageBubble(uiImage: uiImage, message: message)
                    } else {
                        Text(message.text)
                            .font(.system(size: 15))
                            .foregroundStyle(isTrainer ? FH.Colors.text : FH.Colors.primaryInk)
                            .padding(.horizontal, FH.Spacing.md)
                            .padding(.vertical, FH.Spacing.md)
                            .background(isTrainer ? FH.Colors.surface : FH.Colors.primary)
                            .clipShape(RoundedRectangle(cornerRadius: FH.Radius.lg))
                    }

                    // Caption below image
                    if message.imageData != nil && !message.text.isEmpty {
                        Text(message.text)
                            .font(.system(size: 14))
                            .foregroundStyle(isTrainer ? FH.Colors.text : FH.Colors.primaryInk)
                            .padding(.horizontal, FH.Spacing.md)
                            .padding(.vertical, FH.Spacing.sm)
                            .background(isTrainer ? FH.Colors.surface : FH.Colors.primary)
                            .clipShape(RoundedRectangle(cornerRadius: FH.Radius.md))
                    }

                    Text(message.timestamp.formatted(.dateTime.hour().minute()))
                        .font(.system(size: 11))
                        .foregroundStyle(FH.Colors.textSubtle)
                }
                .contextMenu {
                    if message.imageData == nil {
                        Button {
                            UIPasteboard.general.string = message.text
                        } label: {
                            Label("Copy", systemImage: "doc.on.doc")
                        }
                    }
                    if isFromMe {
                        Button(role: .destructive) {
                            withAnimation(.easeOut(duration: 0.2)) {
                                messages.removeAll { $0.id == message.id }
                            }
                        } label: {
                            Label("Unsend", systemImage: "arrow.uturn.backward")
                        }
                    }
                }

                if isTrainer { Spacer(minLength: 40) }
            }
        }
    }

    private func chatImageBubble(uiImage: UIImage, message: ChatMessage) -> some View {
        Image(uiImage: uiImage)
            .resizable()
            .scaledToFill()
            .frame(width: 200, height: 260)
            .clipShape(RoundedRectangle(cornerRadius: FH.Radius.lg))
            .overlay(
                RoundedRectangle(cornerRadius: FH.Radius.lg)
                    .stroke(FH.Colors.border, lineWidth: 1)
            )
            .contentShape(RoundedRectangle(cornerRadius: FH.Radius.lg))
            .onTapGesture {
                FHHaptics.medium()
                if let index = imageMessages.firstIndex(where: { $0.id == message.id }) {
                    galleryStartIndex = index
                    showImageGallery = true
                }
            }
    }

    // MARK: - Input Bar

    private var inputBar: some View {
        HStack(spacing: FH.Spacing.md) {
            Button {
                FHHaptics.light()
                showPhotoPicker = true
            } label: {
                Image(systemName: "photo")
                    .font(.system(size: 18))
                    .foregroundStyle(FH.Colors.textMuted)
            }

            HStack {
                TextField("Message", text: $inputText)
                    .font(.system(size: 15))
                    .foregroundStyle(FH.Colors.text)
                    .padding(.horizontal, FH.Spacing.md)
                    .padding(.vertical, FH.Spacing.md)
                    .focused($isInputFocused)
            }
            .background(FH.Colors.surface)
            .clipShape(RoundedRectangle(cornerRadius: FH.Radius.pill))
            .overlay(
                RoundedRectangle(cornerRadius: FH.Radius.pill)
                    .stroke(FH.Colors.border, lineWidth: 1)
            )

            Button {
                sendMessage()
            } label: {
                Image(systemName: "arrow.up.circle.fill")
                    .font(.system(size: 32))
                    .foregroundStyle(inputText.isEmpty ? FH.Colors.textSubtle : FH.Colors.primary)
            }
            .disabled(inputText.isEmpty)
        }
        .padding(.horizontal, FH.Spacing.base)
        .padding(.vertical, FH.Spacing.md)
    }

    // MARK: - Actions

    private func sendMessage() {
        guard !inputText.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        FHHaptics.medium()

        let newMessage = ChatMessage(
            senderName: isTrainerContext ? partnerName : SampleData.clientName,
            isFromTrainer: isTrainerContext,
            text: inputText.trimmingCharacters(in: .whitespaces),
            timestamp: Date()
        )

        withAnimation(.easeOut(duration: 0.2)) {
            messages.append(newMessage)
            inputText = ""
        }
    }

    private func loadImageForPreview(from item: PhotosPickerItem) async {
        guard let data = try? await item.loadTransferable(type: Data.self),
              let image = UIImage(data: data),
              let jpegData = image.jpegData(compressionQuality: 0.85) else { return }

        await MainActor.run {
            pendingImageData = jpegData
            pendingCaption = ""
            showSendPreview = true
            selectedPhoto = nil
        }
    }

    private func sendPendingImage() {
        guard let imageData = pendingImageData else { return }
        FHHaptics.medium()

        let caption = pendingCaption.trimmingCharacters(in: .whitespaces)
        let newMessage = ChatMessage(
            senderName: isTrainerContext ? partnerName : SampleData.clientName,
            isFromTrainer: isTrainerContext,
            text: caption,
            timestamp: Date(),
            isImageAttachment: true,
            imageData: imageData
        )

        withAnimation(.easeOut(duration: 0.2)) {
            messages.append(newMessage)
        }

        pendingImageData = nil
        pendingCaption = ""
        showSendPreview = false
    }

    private func cancelPendingImage() {
        pendingImageData = nil
        pendingCaption = ""
        showSendPreview = false
    }
}

// MARK: - Image Send Preview Sheet

struct ImageSendPreview: View {
    let imageData: Data?
    @Binding var caption: String
    let onSend: () -> Void
    let onCancel: () -> Void
    @FocusState private var captionFocused: Bool

    var body: some View {
        NavigationStack {
            ZStack {
                FH.Colors.bg.ignoresSafeArea()

                VStack(spacing: FH.Spacing.xl) {
                    if let data = imageData, let uiImage = UIImage(data: data) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFit()
                            .clipShape(RoundedRectangle(cornerRadius: FH.Radius.lg))
                            .overlay(
                                RoundedRectangle(cornerRadius: FH.Radius.lg)
                                    .stroke(FH.Colors.border, lineWidth: 1)
                            )
                            .padding(.horizontal, FH.Spacing.base)
                    }

                    HStack(spacing: FH.Spacing.md) {
                        TextField("Add a caption...", text: $caption, axis: .vertical)
                            .font(.system(size: 15))
                            .foregroundStyle(FH.Colors.text)
                            .padding(.horizontal, FH.Spacing.md)
                            .padding(.vertical, FH.Spacing.md)
                            .background(FH.Colors.surface)
                            .clipShape(RoundedRectangle(cornerRadius: FH.Radius.pill))
                            .overlay(
                                RoundedRectangle(cornerRadius: FH.Radius.pill)
                                    .stroke(FH.Colors.border, lineWidth: 1)
                            )
                            .focused($captionFocused)
                            .lineLimit(1...4)

                        Button {
                            onSend()
                        } label: {
                            Image(systemName: "arrow.up.circle.fill")
                                .font(.system(size: 36))
                                .foregroundStyle(FH.Colors.primary)
                        }
                    }
                    .padding(.horizontal, FH.Spacing.base)

                    Spacer()
                }
                .padding(.top, FH.Spacing.lg)
            }
            .navigationTitle("Send Photo")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        onCancel()
                    }
                    .foregroundStyle(FH.Colors.textMuted)
                }
            }
        }
    }
}

// MARK: - Full-Screen Image Gallery

struct ChatImageGallery: View {
    let imageMessages: [ChatMessage]
    let startIndex: Int
    let onDismiss: () -> Void

    @State private var currentIndex: Int
    @State private var hDrag: CGFloat = 0
    @State private var vDrag: CGFloat = 0
    @State private var scales: [CGFloat]
    @State private var lastScales: [CGFloat]
    @State private var pans: [CGSize]

    private var isZoomed: Bool { scales[safe: currentIndex, default: 1.0] > 1.05 }

    init(imageMessages: [ChatMessage], startIndex: Int, onDismiss: @escaping () -> Void) {
        self.imageMessages = imageMessages
        self.startIndex = startIndex
        self.onDismiss = onDismiss
        _currentIndex = State(initialValue: startIndex)
        _scales = State(initialValue: Array(repeating: 1.0, count: imageMessages.count))
        _lastScales = State(initialValue: Array(repeating: 1.0, count: imageMessages.count))
        _pans = State(initialValue: Array(repeating: .zero, count: imageMessages.count))
    }

    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width
            let h = geo.size.height
            let safeTop = geo.safeAreaInsets.top

            ZStack {
                Color.black
                    .ignoresSafeArea()
                    .opacity(1.0 - abs(vDrag) / max(h, 1) * 0.5)

                ForEach(Array(imageMessages.enumerated()), id: \.offset) { i, msg in
                    if let data = msg.imageData, let uiImage = UIImage(data: data) {
                        galleryImage(uiImage: uiImage, index: i, width: w, height: h)
                    }
                }

                VStack {
                    HStack {
                        Text("\(currentIndex + 1) of \(imageMessages.count)")
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundStyle(.white.opacity(0.9))

                        Spacer()

                        Button {
                            withAnimation(.easeOut(duration: 0.2)) { onDismiss() }
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                                .font(.system(size: 28))
                                .foregroundStyle(.white.opacity(0.9))
                        }
                    }
                    .padding(.horizontal, FH.Spacing.base)
                    .padding(.top, safeTop + FH.Spacing.md)

                    Spacer()
                }
                .allowsHitTesting(true)
                .zIndex(2)
            }
            .contentShape(Rectangle())
            .simultaneousGesture(
                MagnificationGesture()
                    .onChanged { value in
                        guard !imageMessages.isEmpty else { return }
                        let delta = value / lastScales[currentIndex]
                        lastScales[currentIndex] = value
                        scales[currentIndex] = min(max(scales[currentIndex] * delta, 1.0), 4.0)
                    }
                    .onEnded { _ in
                        guard !imageMessages.isEmpty else { return }
                        lastScales[currentIndex] = 1.0
                        if scales[currentIndex] < 1.05 {
                            withAnimation(.easeOut(duration: 0.2)) {
                                scales[currentIndex] = 1.0
                                pans[currentIndex] = .zero
                            }
                        }
                    }
            )
            .simultaneousGesture(
                DragGesture(minimumDistance: 10)
                    .onChanged { value in
                        guard !imageMessages.isEmpty else { return }
                        if isZoomed {
                            pans[currentIndex] = CGSize(
                                width: value.translation.width,
                                height: value.translation.height
                            )
                        } else {
                            let dx = value.translation.width
                            let dy = value.translation.height
                            if abs(dx) > abs(dy) {
                                hDrag = dx
                                vDrag = 0
                            } else {
                                vDrag = dy
                                hDrag = 0
                            }
                        }
                    }
                    .onEnded { value in
                        guard !imageMessages.isEmpty else { return }
                        if isZoomed {
                            withAnimation(.easeOut(duration: 0.3)) {
                                pans[currentIndex] = .zero
                            }
                        } else {
                            let threshold = w * 0.25
                            let velX = value.predictedEndTranslation.width - value.translation.width
                            let velY = value.velocity.height

                            if abs(vDrag) > 100 || (abs(vDrag) > 40 && abs(velY) > 600) {
                                withAnimation(.easeOut(duration: 0.25)) {
                                    vDrag = vDrag > 0 ? h : -h
                                }
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                                    onDismiss()
                                }
                            } else if hDrag < -threshold || (hDrag < -50 && velX < -600) {
                                withAnimation(.easeOut(duration: 0.25)) {
                                    currentIndex = min(currentIndex + 1, imageMessages.count - 1)
                                }
                            } else if hDrag > threshold || (hDrag > 50 && velX > 600) {
                                withAnimation(.easeOut(duration: 0.25)) {
                                    currentIndex = max(currentIndex - 1, 0)
                                }
                            }

                            withAnimation(.easeOut(duration: 0.25)) {
                                hDrag = 0
                                vDrag = 0
                            }
                        }
                    }
            )
            .onTapGesture(count: 2) {
                guard !imageMessages.isEmpty else { return }
                withAnimation(.easeOut(duration: 0.2)) {
                    if scales[currentIndex] > 1.05 {
                        scales[currentIndex] = 1.0
                        pans[currentIndex] = .zero
                    } else {
                        scales[currentIndex] = 2.5
                    }
                }
            }
        }
    }

    private func galleryImage(uiImage: UIImage, index: Int, width: CGFloat, height: CGFloat) -> some View {
        let xOffset = CGFloat(index - currentIndex) * width + hDrag
        let yOffset = vDrag
        let scale = scales[safe: index, default: 1.0]
        let pan = pans[safe: index, default: .zero]
        let isCurrent = index == currentIndex

        return Image(uiImage: uiImage)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .scaleEffect(scale)
            .offset(x: pan.width, y: pan.height)
            .frame(width: width, height: height)
            .position(x: width / 2 + xOffset, y: height / 2 + yOffset)
            .opacity(isCurrent ? 1.0 : 0.4)
            .zIndex(isCurrent ? 1 : 0)
    }
}

// MARK: - Safe Array Access

private extension Array {
    subscript(safe index: Int, default defaultValue: Element) -> Element {
        indices.contains(index) ? self[index] : defaultValue
    }
}

#Preview {
    MessagesView()
        .preferredColorScheme(.dark)
}
