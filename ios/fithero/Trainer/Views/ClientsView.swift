import SwiftUI

struct ClientsView: View {
    @State private var searchText = ""
    @State private var selectedFilter = "All"
    @State private var selectedClient: ClientItem? = nil
    @State private var showClientOnboarding = false

    let filters = ["All", "Active", "Pending", "Paused"]

    let clients = [
        ClientItem(name: "Alex Johnson", plan: "Pro — 3×/week", status: "Active", lastActive: "2h ago", initials: "AJ"),
        ClientItem(name: "Marco Rossi", plan: "Starter — 2×/week", status: "Active", lastActive: "1d ago", initials: "MR"),
        ClientItem(name: "Erika Szabo", plan: "Pro — 4×/week", status: "Active", lastActive: "5h ago", initials: "ES"),
        ClientItem(name: "Sam Taylor", plan: "Starter — 2×/week", status: "Paused", lastActive: "2w ago", initials: "ST"),
        ClientItem(name: "Lisa Chen", plan: "Pending invite", status: "Pending", lastActive: "—", initials: "LC"),
    ]

    var filteredClients: [ClientItem] {
        var result = clients
        if selectedFilter != "All" {
            result = result.filter { $0.status == selectedFilter }
        }
        if !searchText.isEmpty {
            result = result.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
        return result
    }

    var body: some View {
        NavigationStack {
            ZStack {
                FH.Colors.bg.ignoresSafeArea()

                ScrollView(showsIndicators: false) {
                    VStack(spacing: FH.Spacing.xl) {
                        headerSection
                        filterPills
                        clientList
                    }
                    .padding(.horizontal, FH.Spacing.base)
                    .padding(.bottom, FH.Spacing.xxxl)
                }
            }
            .navigationDestination(item: $selectedClient) { client in
                ClientDetailView(client: client)
            }
            .sheet(isPresented: $showClientOnboarding) {
                ClientOnboardingView()
            }
        }
    }

    // MARK: - Header

    private var headerSection: some View {
        VStack(spacing: FH.Spacing.md) {
            HStack {
                VStack(alignment: .leading, spacing: FH.Spacing.xs) {
                    Text("Clients")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundStyle(FH.Colors.text)
                    Text("\(clients.filter { $0.isActive }.count) active")
                        .font(.system(size: 14))
                        .foregroundStyle(FH.Colors.textMuted)
                }
                Spacer()
                Button {
                    showClientOnboarding = true
                } label: {
                    Image(systemName: "plus")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(FH.Colors.primaryInk)
                        .frame(width: 44, height: 44)
                        .background(FH.Colors.primary)
                        .clipShape(Circle())
                }
            }

            HStack(spacing: FH.Spacing.sm) {
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 14))
                    .foregroundStyle(FH.Colors.textSubtle)
                TextField("Search clients", text: $searchText)
                    .font(.system(size: 15))
                    .foregroundStyle(FH.Colors.text)
                if !searchText.isEmpty {
                    Button { searchText = "" } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 16))
                            .foregroundStyle(FH.Colors.textSubtle)
                    }
                }
            }
            .padding(.horizontal, FH.Spacing.md)
            .padding(.vertical, FH.Spacing.sm)
            .background(FH.Colors.surface)
            .clipShape(RoundedRectangle(cornerRadius: FH.Radius.pill))
            .overlay(
                RoundedRectangle(cornerRadius: FH.Radius.pill)
                    .stroke(FH.Colors.border, lineWidth: 1)
            )
        }
        .padding(.top, FH.Spacing.lg)
    }

    // MARK: - Filters

    private var filterPills: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: FH.Spacing.sm) {
                ForEach(filters, id: \.self) { filter in
                    Button {
                        withAnimation(.easeInOut(duration: 0.15)) {
                            selectedFilter = filter
                        }
                    } label: {
                        Text(filter)
                            .font(.system(size: 13, weight: selectedFilter == filter ? .semibold : .medium))
                            .foregroundStyle(selectedFilter == filter ? FH.Colors.primaryInk : FH.Colors.textMuted)
                            .padding(.horizontal, 14)
                            .padding(.vertical, 8)
                            .background(selectedFilter == filter ? FH.Colors.primary : FH.Colors.surface2)
                            .clipShape(Capsule())
                            .overlay(
                                Capsule()
                                    .stroke(selectedFilter == filter ? FH.Colors.primary : FH.Colors.border, lineWidth: 1)
                            )
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }

    // MARK: - Client List

    private var clientList: some View {
        VStack(spacing: FH.Spacing.sm) {
            ForEach(filteredClients) { client in
                clientRow(client)
            }

            if filteredClients.isEmpty {
                VStack(spacing: FH.Spacing.md) {
                    Image(systemName: "person.slash")
                        .font(.system(size: 32))
                        .foregroundStyle(FH.Colors.textSubtle)
                    Text("No clients found")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundStyle(FH.Colors.textMuted)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, FH.Spacing.xxl)
            }
        }
    }

    private func clientRow(_ client: ClientItem) -> some View {
        Button {
            selectedClient = client
        } label: {
            HStack(spacing: FH.Spacing.md) {
            ZStack {
                Circle()
                    .fill(client.statusColor.opacity(0.15))
                    .frame(width: 48, height: 48)
                Text(client.initials)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(client.statusColor)
            }

            VStack(alignment: .leading, spacing: 3) {
                Text(client.name)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(FH.Colors.text)
                Text(client.plan)
                    .font(.system(size: 13))
                    .foregroundStyle(FH.Colors.textMuted)
            }

            Spacer(minLength: 0)

            VStack(alignment: .trailing, spacing: 3) {
                statusPill(client.status)
                Text(client.lastActive)
                    .font(.system(size: 12))
                    .foregroundStyle(FH.Colors.textSubtle)
            }
            }
        }
        .buttonStyle(.plain)
        .padding(FH.Spacing.md)
        .background(FH.Colors.surface)
        .clipShape(RoundedRectangle(cornerRadius: FH.Radius.lg))
        .overlay(
            RoundedRectangle(cornerRadius: FH.Radius.lg)
                .stroke(FH.Colors.border, lineWidth: 1)
        )
    }

    private func statusPill(_ status: String) -> some View {
        let color: Color
        switch status {
        case "Active": color = FH.Colors.success
        case "Pending": color = FH.Colors.warning
        case "Paused": color = FH.Colors.textSubtle
        default: color = FH.Colors.textSubtle
        }

        return Text(status)
            .font(.system(size: 11, weight: .semibold))
            .foregroundStyle(color)
            .padding(.horizontal, 8)
            .padding(.vertical, 3)
            .background(color.opacity(0.12))
            .clipShape(Capsule())
    }
}

// MARK: - Model

struct ClientItem: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let plan: String
    let status: String
    let lastActive: String
    let initials: String

    var isActive: Bool { status == "Active" }

    var statusColor: Color {
        switch status {
        case "Active": return FH.Colors.accent
        case "Pending": return FH.Colors.warning
        case "Paused": return FH.Colors.textSubtle
        default: return FH.Colors.textSubtle
        }
    }
}

#Preview {
    ClientsView()
        .preferredColorScheme(.dark)
}
