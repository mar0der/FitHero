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
    @State private var showImagePreview = false
    @State private var previewStartIndex = 0
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

            if showImagePreview {
                ChatImageGallery(
                    imageMessages: imageMessages,
                    startIndex: previewStartIndex,
                    onDismiss: { showImagePreview = false }
                )
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
            Task { await loadAndSendImage(from: newItem) }
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

                    Text(message.timestamp.formatted(.dateTime.hour().minute()))
                        .font(.system(size: 11))
                        .foregroundStyle(FH.Colors.textSubtle)
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
                    previewStartIndex = index
                    showImagePreview = true
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

    private func loadAndSendImage(from item: PhotosPickerItem) async {
        guard let data = try? await item.loadTransferable(type: Data.self),
              let image = UIImage(data: data),
              let jpegData = image.jpegData(compressionQuality: 0.85) else { return }

        await MainActor.run {
            FHHaptics.medium()
            let newMessage = ChatMessage(
                senderName: isTrainerContext ? partnerName : SampleData.clientName,
                isFromTrainer: isTrainerContext,
                text: "",
                timestamp: Date(),
                isImageAttachment: true,
                imageData: jpegData
            )

            withAnimation(.easeOut(duration: 0.2)) {
                messages.append(newMessage)
                selectedPhoto = nil
            }
        }
    }
}

// MARK: - Full-Screen Image Gallery with Swipe & Zoom

struct ChatImageGallery: View {
    let imageMessages: [ChatMessage]
    let startIndex: Int
    let onDismiss: () -> Void

    @State private var selectedIndex: Int
    @State private var pageScales: [CGFloat]
    @State private var pageOffsets: [CGSize]
    @State private var dismissProgress: CGFloat = 0
    @State private var isDragging = false

    init(imageMessages: [ChatMessage], startIndex: Int, onDismiss: @escaping () -> Void) {
        self.imageMessages = imageMessages
        self.startIndex = startIndex
        self.onDismiss = onDismiss
        _selectedIndex = State(initialValue: startIndex)
        _pageScales = State(initialValue: Array(repeating: 1.0, count: imageMessages.count))
        _pageOffsets = State(initialValue: Array(repeating: .zero, count: imageMessages.count))
    }

    private var currentScale: CGFloat { pageScales[selectedIndex] }
    private var isZoomed: Bool { currentScale > 1.05 }

    var body: some View {
        ZStack {
            Color.black.opacity(0.95)
                .ignoresSafeArea()
                .opacity(1.0 - abs(dismissProgress) * 0.6)

            TabView(selection: $selectedIndex) {
                ForEach(Array(imageMessages.enumerated()), id: \.element.id) { index, message in
                    if let data = message.imageData, let uiImage = UIImage(data: data) {
                        zoomableImagePage(
                            uiImage: uiImage,
                            index: index
                        )
                    }
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .always))
            .indexViewStyle(.page(backgroundDisplayMode: .always))
            .offset(y: dismissProgress * 300)
            .scaleEffect(1.0 - abs(dismissProgress) * 0.1)
            .disabled(isDragging)

            // Top bar
            VStack {
                HStack {
                    Text("\(selectedIndex + 1) of \(imageMessages.count)")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(.white.opacity(0.8))

                    Spacer()

                    Button {
                        withAnimation(.easeOut(duration: 0.2)) {
                            onDismiss()
                        }
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 28))
                            .foregroundStyle(.white.opacity(0.8))
                    }
                }
                .padding(.horizontal, FH.Spacing.base)
                .padding(.top, FH.Spacing.lg)

                Spacer()
            }
            .opacity(1.0 - abs(dismissProgress) * 2)
        }
    }

    private func zoomableImagePage(uiImage: UIImage, index: Int) -> some View {
        GeometryReader { geo in
            Image(uiImage: uiImage)
                .resizable()
                .scaledToFit()
                .scaleEffect(pageScales[index])
                .offset(pageOffsets[index])
                .frame(width: geo.size.width, height: geo.size.height)
                .position(x: geo.size.width / 2, y: geo.size.height / 2)
                .simultaneousGesture(
                    MagnificationGesture()
                        .onChanged { value in
                            let newScale = min(max(value, 1.0), 4.0)
                            pageScales[index] = newScale
                        }
                        .onEnded { _ in
                            if pageScales[index] < 1.05 {
                                withAnimation(.easeOut(duration: 0.2)) {
                                    pageScales[index] = 1.0
                                    pageOffsets[index] = .zero
                                }
                            }
                        }
                )
                .simultaneousGesture(
                    DragGesture()
                        .onChanged { value in
                            if pageScales[index] > 1.05 {
                                pageOffsets[index] = CGSize(
                                    width: value.translation.width,
                                    height: value.translation.height
                                )
                            } else {
                                isDragging = true
                                dismissProgress = value.translation.height / geo.size.height
                            }
                        }
                        .onEnded { value in
                            isDragging = false
                            if pageScales[index] > 1.05 {
                                let velocity = CGSize(
                                    width: value.predictedEndTranslation.width - value.translation.width,
                                    height: value.predictedEndTranslation.height - value.translation.height
                                )
                                let magnitude = sqrt(velocity.width * velocity.width + velocity.height * velocity.height)
                                if magnitude > 800 || abs(pageOffsets[index].height) > geo.size.height * 0.4 {
                                    withAnimation(.easeOut(duration: 0.2)) {
                                        pageScales[index] = 1.0
                                        pageOffsets[index] = .zero
                                    }
                                } else {
                                    withAnimation(.easeOut(duration: 0.3)) {
                                        pageOffsets[index] = .zero
                                    }
                                }
                            } else {
                                if value.translation.height > 120 || (value.translation.height > 40 && value.velocity.height > 500) {
                                    withAnimation(.easeOut(duration: 0.25)) {
                                        dismissProgress = 1.0
                                    }
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                                        onDismiss()
                                    }
                                } else {
                                    withAnimation(.easeOut(duration: 0.25)) {
                                        dismissProgress = 0
                                    }
                                }
                            }
                        }
                )
                .onTapGesture(count: 2) {
                    withAnimation(.easeOut(duration: 0.2)) {
                        if pageScales[index] > 1.05 {
                            pageScales[index] = 1.0
                            pageOffsets[index] = .zero
                        } else {
                            pageScales[index] = 2.5
                        }
                    }
                }
                .tag(index)
        }
    }
}

#Preview {
    MessagesView()
        .preferredColorScheme(.dark)
}
