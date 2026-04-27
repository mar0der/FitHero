import SwiftUI

struct LibraryView: View {
    @State private var selectedTab = 0

    var body: some View {
        ZStack {
            FH.Colors.bg.ignoresSafeArea()

            VStack(spacing: 0) {
                headerSection
                tabSegmentedControl
                    .padding(.horizontal, FH.Spacing.base)
                    .padding(.bottom, FH.Spacing.md)

                if selectedTab == 0 {
                    ExerciseListView()
                } else {
                    WorkoutListView()
                }
            }
        }
    }

    private var headerSection: some View {
        HStack {
            Text("Library")
                .font(.system(size: 28, weight: .bold))
                .foregroundStyle(FH.Colors.text)
            Spacer()
        }
        .padding(.horizontal, FH.Spacing.base)
        .padding(.top, FH.Spacing.lg)
        .padding(.bottom, FH.Spacing.md)
    }

    private var tabSegmentedControl: some View {
        HStack(spacing: 0) {
            ForEach(["Exercises", "Workouts"], id: \.self) { title in
                let index = title == "Exercises" ? 0 : 1
                Button {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        selectedTab = index
                    }
                } label: {
                    Text(title)
                        .font(.system(size: 14, weight: selectedTab == index ? .semibold : .medium))
                        .foregroundStyle(selectedTab == index ? FH.Colors.primaryInk : FH.Colors.textMuted)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background(selectedTab == index ? FH.Colors.primary : Color.clear)
                        .clipShape(RoundedRectangle(cornerRadius: FH.Radius.md))
                }
                .buttonStyle(.plain)
            }
        }
        .padding(4)
        .background(FH.Colors.surface)
        .clipShape(RoundedRectangle(cornerRadius: FH.Radius.lg))
    }
}

#Preview {
    LibraryView()
        .preferredColorScheme(.dark)
}
