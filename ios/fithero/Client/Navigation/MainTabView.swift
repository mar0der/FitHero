import SwiftUI

struct MainTabView: View {
    @State private var selectedTab = 0
    let onSignOut: () -> Void

    var body: some View {
        TabView(selection: $selectedTab) {
            Tab("Home", systemImage: "house.fill", value: 0) {
                ClientHomeView(onSignOut: onSignOut)
            }
            Tab("Workout", systemImage: "dumbbell.fill", value: 1) {
                WorkoutFlowView(workout: SampleData.todayWorkout)
            }
            Tab("Progress", systemImage: "chart.line.uptrend.xyaxis", value: 2) {
                ClientProgressView()
            }
            Tab("Schedule", systemImage: "calendar", value: 3) {
                ScheduleView()
            }
            Tab("Messages", systemImage: "message.fill", value: 4) {
                MessagesView()
            }
        }
        .tint(FH.Colors.primary)
    }
}

#Preview {
    MainTabView(onSignOut: {})
        .preferredColorScheme(.dark)
}
