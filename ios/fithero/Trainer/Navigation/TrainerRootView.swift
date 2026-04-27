import SwiftUI

struct TrainerRootView: View {
    let onSignOut: () -> Void

    var body: some View {
        TrainerMainTabView(onSignOut: onSignOut)
    }
}

#Preview {
    TrainerRootView(onSignOut: {})
        .preferredColorScheme(.dark)
}
