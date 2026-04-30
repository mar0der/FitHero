import SwiftUI

struct AddNoteSheet: View {
    let onSave: (String) -> Void
    @Environment(\.dismiss) private var dismiss
    @State private var text = ""
    @FocusState private var focused: Bool

    var body: some View {
        NavigationStack {
            ZStack {
                FH.Colors.bg.ignoresSafeArea()

                VStack(spacing: FH.Spacing.lg) {
                    sheetHandle

                    TextEditor(text: $text)
                        .font(.system(size: 15))
                        .foregroundStyle(FH.Colors.text)
                        .padding(FH.Spacing.md)
                        .background(FH.Colors.surface)
                        .clipShape(RoundedRectangle(cornerRadius: FH.Radius.lg))
                        .overlay(RoundedRectangle(cornerRadius: FH.Radius.lg).stroke(FH.Colors.border, lineWidth: 1))
                        .focused($focused)
                        .scrollContentBackground(.hidden)

                    Spacer()
                }
                .padding(FH.Spacing.base)
            }
            .navigationTitle("New Note")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundStyle(FH.Colors.textMuted)
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") {
                        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
                        guard !trimmed.isEmpty else { return }
                        FHHaptics.success()
                        onSave(trimmed)
                        dismiss()
                    }
                    .foregroundStyle(!text.trimmingCharacters(in: .whitespaces).isEmpty ? FH.Colors.primary : FH.Colors.textSubtle)
                    .disabled(text.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
            .onAppear {
                focused = true
            }
        }
    }

    private var sheetHandle: some View {
        RoundedRectangle(cornerRadius: 100)
            .fill(Color.white.opacity(0.2))
            .frame(width: 38, height: 5)
            .frame(maxWidth: .infinity)
            .padding(.top, 10)
            .padding(.bottom, FH.Spacing.md)
    }
}

#Preview {
    AddNoteSheet { _ in }
        .preferredColorScheme(.dark)
}
