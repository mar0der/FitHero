import SwiftUI

struct TrainerMainTabView: View {
    @State private var selectedTab = 0
    let onSignOut: () -> Void

    var body: some View {
        TabView(selection: $selectedTab) {
            Tab("Today", systemImage: "calendar.badge.clock", value: 0) {
                TodayView()
            }
            Tab("Clients", systemImage: "person.2.fill", value: 1) {
                ClientsView()
            }
            Tab("Library", systemImage: "books.vertical.fill", value: 2) {
                LibraryView()
            }
            Tab("Messages", systemImage: "message.fill", value: 3) {
                TrainerMessagesView()
            }
            Tab("Settings", systemImage: "gearshape.fill", value: 4) {
                TrainerSettingsView(onSignOut: onSignOut)
            }
        }
        .tint(FH.Colors.primary)
    }
}

#Preview {
    TrainerMainTabView(onSignOut: {})
        .preferredColorScheme(.dark)
}
