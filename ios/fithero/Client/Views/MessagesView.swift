import SwiftUI
import PhotosUI

struct MessagesView: View {
    let partnerName: String
    let partnerInitial: String
    let isTrainerContext: Bool

    @State private var messages: [ChatMessage]
    @State private var inputText = ""
    @State private var showVideoCallAlert = false
    @State private var showPhotoPicker = false
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var scrollToBottom = UUID()
    @FocusState private var isInputFocused: Bool

    init(partnerName: String? = nil, partnerInitial: String? = nil, isTrainerContext: Bool = false) {
        self.partnerName = partnerName ?? SampleData.trainerName
        self.partnerInitial = partnerInitial ?? SampleData.trainerAvatar
        self.isTrainerContext = isTrainerContext
        _messages = State(initialValue: SampleData.messages)
    }

    var body: some View {
        VStack(spacing: 0) {
            chatHeader
            Divider().background(FH.Colors.border)
            chatBody
            Divider().background(FH.Colors.border)
            inputBar
        }
        .background(FH.Colors.bg)
        .alert("Video Call", isPresented: $showVideoCallAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("Starting video call with \(partnerName)...")
        }
        .photosPicker(isPresented: $showPhotoPicker, selection: $selectedPhoto, matching: .images)
        .onChange(of: selectedPhoto) { _, newItem in
            guard newItem != nil else { return }
            sendImageAttachment()
        }
    }

    // MARK: - Header

    private var chatHeader: some View {
        HStack(spacing: FH.Spacing.md) {
            ZStack {
                Circle()
                    .fill(FH.Colors.accent.opacity(0.15))
                    .frame(width: 44, height: 44)
                Text(partnerInitial)
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundStyle(FH.Colors.accent)
            }

            VStack(alignment: .leading, spacing: 2) {
                Text(partnerName)
                    .font(.system(size: 17, weight: .semibold))
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
                    .background(FH.Colors.surface)
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
                withAnimation(.easeOut(duration: 0.2)) {
                    proxy.scrollTo("bottom", anchor: .bottom)
                }
            }
            .onAppear {
                proxy.scrollTo("bottom", anchor: .bottom)
            }
        }
    }

    private func messageBubble(_ message: ChatMessage) -> some View {
        let isTrainer = message.isFromTrainer
        let alignment: HorizontalAlignment = isTrainer ? .leading : .trailing

        return VStack(alignment: alignment, spacing: FH.Spacing.xs) {
            HStack {
                if !isTrainer { Spacer(minLength: 60) }

                VStack(alignment: isTrainer ? .leading : .trailing, spacing: 4) {
                    if message.isImageAttachment {
                        imageAttachmentBubble
                    } else {
                        Text(message.text)
                            .font(.system(size: 15))
                            .foregroundStyle(isTrainer ? FH.Colors.text : FH.Colors.primaryInk)
                            .padding(.horizontal, FH.Spacing.md)
                            .padding(.vertical, FH.Spacing.md)
                            .background(isTrainer ? FH.Colors.surface : FH.Colors.primary)
                            .clipShape(
                                RoundedRectangle(cornerRadius: FH.Radius.lg)
                            )
                    }

                    Text(message.timestamp.formatted(.dateTime.hour().minute()))
                        .font(.system(size: 11))
                        .foregroundStyle(FH.Colors.textSubtle)
                }

                if isTrainer { Spacer(minLength: 60) }
            }
        }
    }

    private var imageAttachmentBubble: some View {
        VStack(spacing: FH.Spacing.sm) {
            Image(systemName: "photo.fill")
                .font(.system(size: 32))
                .foregroundStyle(FH.Colors.primary)
            Text("Photo")
                .font(.system(size: 13, weight: .medium))
                .foregroundStyle(FH.Colors.textMuted)
        }
        .frame(width: 140, height: 140)
        .background(FH.Colors.surface)
        .clipShape(RoundedRectangle(cornerRadius: FH.Radius.lg))
        .overlay(
            RoundedRectangle(cornerRadius: FH.Radius.lg)
                .stroke(FH.Colors.border, lineWidth: 1)
        )
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

    private func sendImageAttachment() {
        FHHaptics.medium()
        let newMessage = ChatMessage(
            senderName: isTrainerContext ? partnerName : SampleData.clientName,
            isFromTrainer: isTrainerContext,
            text: "",
            timestamp: Date(),
            isImageAttachment: true
        )

        withAnimation(.easeOut(duration: 0.2)) {
            messages.append(newMessage)
            selectedPhoto = nil
        }
    }
}

#Preview {
    MessagesView()
        .preferredColorScheme(.dark)
}
