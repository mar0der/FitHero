import SwiftUI

struct TrainerMessagesView: View {
    @State private var conversations: [Conversation] = [
        Conversation(name: "Alex Johnson", preview: "Thanks for the program update! Ready for tomorrow.", time: "10m", unread: 2, initials: "AJ"),
        Conversation(name: "Marco Rossi", preview: "Can we reschedule Thursday to Friday?", time: "1h", unread: 1, initials: "MR"),
        Conversation(name: "Erika Szabo", preview: "Hit a new PR on deadlifts today 🎉", time: "3h", unread: 0, initials: "ES"),
        Conversation(name: "Sam Taylor", preview: "I'm back from vacation, ready to start Monday.", time: "2d", unread: 0, initials: "ST"),
    ]
    @State private var selectedConversation: Conversation?

    var body: some View {
        ZStack {
            FH.Colors.bg.ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(spacing: FH.Spacing.xl) {
                    headerSection
                    conversationList
                }
                .padding(.horizontal, FH.Spacing.base)
                .padding(.bottom, FH.Spacing.xxxl)
            }
        }
        .sheet(item: $selectedConversation) { conv in
            MessagesView(
                partnerName: conv.name,
                partnerInitial: conv.initials,
                isTrainerContext: true
            )
        }
    }

    // MARK: - Header

    private var headerSection: some View {
        HStack {
            VStack(alignment: .leading, spacing: FH.Spacing.xs) {
                Text("Messages")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundStyle(FH.Colors.text)
                Text("\(conversations.filter { $0.unread > 0 }.count) unread")
                    .font(.system(size: 14))
                    .foregroundStyle(FH.Colors.textMuted)
            }
            Spacer()
        }
        .padding(.top, FH.Spacing.lg)
    }

    // MARK: - Conversation List

    private var conversationList: some View {
        VStack(spacing: FH.Spacing.sm) {
            ForEach($conversations) { $conv in
                Button {
                    FHHaptics.medium()
                    if conv.unread > 0 {
                        conv.unread = 0
                    }
                    selectedConversation = conv
                } label: {
                    conversationRow(conv)
                }
                .buttonStyle(.plain)
            }
        }
    }

    private func conversationRow(_ conv: Conversation) -> some View {
        HStack(spacing: FH.Spacing.md) {
            ZStack(alignment: .bottomTrailing) {
                Circle()
                    .fill(FH.Colors.accent.opacity(0.15))
                    .frame(width: 48, height: 48)
                Text(conv.initials)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(FH.Colors.accent)

                if conv.unread > 0 {
                    ZStack {
                        Circle()
                            .fill(FH.Colors.primary)
                            .frame(width: 18, height: 18)
                        Text("\(min(conv.unread, 9))")
                            .font(.system(size: 10, weight: .bold))
                            .foregroundStyle(FH.Colors.primaryInk)
                    }
                    .offset(x: 2, y: 2)
                }
            }

            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(conv.name)
                        .font(.system(size: 15, weight: conv.unread > 0 ? .semibold : .medium))
                        .foregroundStyle(FH.Colors.text)
                    Spacer()
                    Text(conv.time)
                        .font(.system(size: 12))
                        .foregroundStyle(FH.Colors.textSubtle)
                }
                Text(conv.preview)
                    .font(.system(size: 13))
                    .foregroundStyle(conv.unread > 0 ? FH.Colors.textMuted : FH.Colors.textSubtle)
                    .lineLimit(2)
            }

            Spacer(minLength: 0)

            Image(systemName: "chevron.right")
                .font(.system(size: 12, weight: .semibold))
                .foregroundStyle(FH.Colors.textSubtle)
        }
        .padding(FH.Spacing.md)
        .background(FH.Colors.surface)
        .clipShape(RoundedRectangle(cornerRadius: FH.Radius.lg))
        .overlay(
            RoundedRectangle(cornerRadius: FH.Radius.lg)
                .stroke(FH.Colors.border, lineWidth: 1)
        )
    }
}

// MARK: - Model

struct Conversation: Identifiable {
    let id = UUID()
    let name: String
    let preview: String
    let time: String
    var unread: Int
    let initials: String
}

#Preview {
    TrainerMessagesView()
        .preferredColorScheme(.dark)
}
