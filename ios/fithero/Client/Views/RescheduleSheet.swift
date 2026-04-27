import SwiftUI

struct RescheduleSheet: View {
    let session: TrainingSession
    @Environment(\.dismiss) private var dismiss
    @State private var newDate: Date
    @State private var newDuration: Int
    @State private var showConfirmation = false

    init(session: TrainingSession) {
        self.session = session
        _newDate = State(initialValue: session.date)
        _newDuration = State(initialValue: session.durationMinutes)
    }

    var body: some View {
        NavigationStack {
            ZStack {
                FH.Colors.bg.ignoresSafeArea()

                ScrollView {
                    VStack(spacing: FH.Spacing.xl) {
                        currentSessionCard
                        datePickerCard
                        durationPickerCard
                        requestButton
                    }
                    .padding(FH.Spacing.base)
                    .padding(.bottom, FH.Spacing.xxxl)
                }
            }
            .navigationTitle("Reschedule")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button { dismiss() } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 24))
                            .foregroundStyle(FH.Colors.textSubtle)
                    }
                }
            }
            .alert("Request Sent", isPresented: $showConfirmation) {
                Button("OK", role: .cancel) {
                    dismiss()
                }
            } message: {
                Text("Your trainer will be notified of your reschedule request for \(newDate.formatted(date: .abbreviated, time: .shortened))")
            }
        }
    }

    private var currentSessionCard: some View {
        VStack(alignment: .leading, spacing: FH.Spacing.sm) {
            Text("CURRENT SESSION")
                .font(.system(size: 12, weight: .semibold))
                .foregroundStyle(FH.Colors.textSubtle)
                .tracking(1.2)

            HStack(spacing: FH.Spacing.base) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(session.type.rawValue)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(FH.Colors.text)
                    Text(session.date.formatted(date: .long, time: .shortened))
                        .font(.system(size: 14))
                        .foregroundStyle(FH.Colors.textMuted)
                }
                Spacer()
                Text("\(session.durationMinutes) min")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(FH.Colors.textSubtle)
            }
        }
        .padding(FH.Spacing.base)
        .background(FH.Colors.surface)
        .clipShape(RoundedRectangle(cornerRadius: FH.Radius.lg))
    }

    private var datePickerCard: some View {
        VStack(alignment: .leading, spacing: FH.Spacing.md) {
            Text("NEW DATE & TIME")
                .font(.system(size: 12, weight: .semibold))
                .foregroundStyle(FH.Colors.textSubtle)
                .tracking(1.2)

            DatePicker(
                "Select new time",
                selection: $newDate,
                displayedComponents: [.date, .hourAndMinute]
            )
            .datePickerStyle(.graphical)
            .colorMultiply(FH.Colors.primary)
            .padding(FH.Spacing.base)
            .background(FH.Colors.surface)
            .clipShape(RoundedRectangle(cornerRadius: FH.Radius.lg))
        }
    }

    private var durationPickerCard: some View {
        VStack(alignment: .leading, spacing: FH.Spacing.md) {
            Text("DURATION")
                .font(.system(size: 12, weight: .semibold))
                .foregroundStyle(FH.Colors.textSubtle)
                .tracking(1.2)

            HStack(spacing: FH.Spacing.md) {
                ForEach([15, 30, 45, 60, 90], id: \.self) { mins in
                    Button {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            newDuration = mins
                        }
                    } label: {
                        Text("\(mins)m")
                            .font(.system(size: 14, weight: newDuration == mins ? .semibold : .medium))
                            .foregroundStyle(newDuration == mins ? FH.Colors.primaryInk : FH.Colors.textMuted)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 10)
                            .background(newDuration == mins ? FH.Colors.primary : FH.Colors.surface)
                            .clipShape(RoundedRectangle(cornerRadius: FH.Radius.md))
                    }
                }
            }
        }
    }

    private var requestButton: some View {
        Button {
            showConfirmation = true
        } label: {
            Text("Send Reschedule Request")
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(FH.Colors.primaryInk)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(FH.Colors.primary)
                .clipShape(RoundedRectangle(cornerRadius: FH.Radius.md))
        }
    }
}
