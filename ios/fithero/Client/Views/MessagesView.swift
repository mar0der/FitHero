import SwiftUI

struct MessagesView: View {
    let messages = SampleData.messages
    @State private var inputText = ""

    var body: some View {
        VStack(spacing: 0) {
            chatHeader
            Divider().background(FH.Colors.border)
            chatBody
            Divider().background(FH.Colors.border)
            inputBar
        }
        .background(FH.Colors.bg)
    }

    // MARK: - Header

    private var chatHeader: some View {
        HStack(spacing: FH.Spacing.md) {
            ZStack {
                Circle()
                    .fill(FH.Colors.accent.opacity(0.15))
                    .frame(width: 44, height: 44)
                Text(SampleData.trainerAvatar)
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundStyle(FH.Colors.accent)
            }

            VStack(alignment: .leading, spacing: 2) {
                Text(SampleData.trainerName)
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
                // Video call
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
        ScrollView {
            LazyVStack(spacing: FH.Spacing.md) {
                // Date header
                Text("Today")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundStyle(FH.Colors.textSubtle)
                    .padding(.vertical, FH.Spacing.sm)

                ForEach(messages) { message in
                    messageBubble(message)
                }
            }
            .padding(.horizontal, FH.Spacing.base)
            .padding(.vertical, FH.Spacing.base)
        }
    }

    private func messageBubble(_ message: ChatMessage) -> some View {
        let isTrainer = message.isFromTrainer
        let alignment: HorizontalAlignment = isTrainer ? .leading : .trailing

        return VStack(alignment: alignment, spacing: FH.Spacing.xs) {
            HStack {
                if !isTrainer { Spacer(minLength: 60) }

                VStack(alignment: isTrainer ? .leading : .trailing, spacing: 4) {
                    Text(message.text)
                        .font(.system(size: 15))
                        .foregroundStyle(isTrainer ? FH.Colors.text : FH.Colors.primaryInk)
                        .padding(.horizontal, FH.Spacing.md)
                        .padding(.vertical, FH.Spacing.md)
                        .background(isTrainer ? FH.Colors.surface : FH.Colors.primary)
                        .clipShape(
                            RoundedRectangle(cornerRadius: FH.Radius.lg)
                        )

                    Text(message.timestamp.formatted(.dateTime.hour().minute()))
                        .font(.system(size: 11))
                        .foregroundStyle(FH.Colors.textSubtle)
                }

                if isTrainer { Spacer(minLength: 60) }
            }
        }
    }

    // MARK: - Input Bar

    private var inputBar: some View {
        HStack(spacing: FH.Spacing.md) {
            Button {
                // Attach image
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
            }
            .background(FH.Colors.surface)
            .clipShape(RoundedRectangle(cornerRadius: FH.Radius.pill))
            .overlay(
                RoundedRectangle(cornerRadius: FH.Radius.pill)
                    .stroke(FH.Colors.border, lineWidth: 1)
            )

            Button {
                // Send
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
}

#Preview {
    MessagesView()
        .preferredColorScheme(.dark)
}
