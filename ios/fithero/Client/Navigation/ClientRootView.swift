import SwiftUI

struct ClientRootView: View {
    let onSignOut: () -> Void

    var body: some View {
        MainTabView(onSignOut: onSignOut)
    }
}

#Preview {
    ClientRootView(onSignOut: {})
        .preferredColorScheme(.dark)
}
