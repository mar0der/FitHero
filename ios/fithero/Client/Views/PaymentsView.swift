import SwiftUI

struct PaymentsView: View {
    @AppStorage("savedPaymentMethod") private var savedMethodData: Data?
    @AppStorage("paymentHistory") private var paymentHistoryData: Data?
    @AppStorage("subscriptionPlan") private var subscriptionPlanData: Data?

    @State private var showAddPaymentMethod = false

    private var paymentMethod: PaymentMethod? {
        guard let data = savedMethodData else { return nil }
        return try? JSONDecoder().decode(PaymentMethod.self, from: data)
    }

    private var history: [PaymentHistoryItem] {
        guard let data = paymentHistoryData else { return SampleData.paymentHistory }
        return (try? JSONDecoder().decode([PaymentHistoryItem].self, from: data)) ?? SampleData.paymentHistory
    }

    private var plan: SubscriptionPlan {
        guard let data = subscriptionPlanData else { return SampleData.subscriptionPlan }
        return (try? JSONDecoder().decode(SubscriptionPlan.self, from: data)) ?? SampleData.subscriptionPlan
    }

    var body: some View {
        ZStack {
            FH.Colors.bg.ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(spacing: FH.Spacing.xl) {
                    planCard
                    paymentMethodSection
                    historySection
                }
                .padding(.horizontal, FH.Spacing.base)
                .padding(.bottom, FH.Spacing.xxxl)
            }
        }
        .navigationTitle("Payments")
        .navigationBarTitleDisplayMode(.large)
        .sheet(isPresented: $showAddPaymentMethod) {
            AddPaymentMethodView(onSave: { method in
                if let data = try? JSONEncoder().encode(method) {
                    savedMethodData = data
                }
            })
        }
    }

    // MARK: - Plan Card

    private var planCard: some View {
        VStack(alignment: .leading, spacing: FH.Spacing.lg) {
            HStack {
                VStack(alignment: .leading, spacing: FH.Spacing.sm) {
                    Text("CURRENT PLAN")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundStyle(FH.Colors.textSubtle)
                        .tracking(1.2)

                    Text(plan.name)
                        .font(.system(size: 22, weight: .bold))
                        .foregroundStyle(FH.Colors.text)
                }

                Spacer()

                statusPill(plan.status)
            }

            HStack(alignment: .lastTextBaseline, spacing: 4) {
                Text(plan.amount)
                    .font(.system(size: 32, weight: .bold, design: .rounded))
                    .foregroundStyle(FH.Colors.primary)
                Text("/ \(plan.billingInterval)")
                    .font(.system(size: 15))
                    .foregroundStyle(FH.Colors.textMuted)
            }

            Divider().background(FH.Colors.border)

            HStack(spacing: FH.Spacing.sm) {
                Image(systemName: "calendar")
                    .font(.system(size: 14))
                    .foregroundStyle(FH.Colors.textMuted)
                Text("Next billing: \(plan.nextBillingDate.formatted(date: .abbreviated, time: .omitted))")
                    .font(.system(size: 14))
                    .foregroundStyle(FH.Colors.textMuted)
            }
        }
        .padding(FH.Spacing.base)
        .background(FH.Colors.surface)
        .clipShape(RoundedRectangle(cornerRadius: FH.Radius.lg))
        .overlay(
            RoundedRectangle(cornerRadius: FH.Radius.lg)
                .stroke(FH.Colors.border, lineWidth: 1)
        )
        .padding(.top, FH.Spacing.lg)
    }

    // MARK: - Payment Method

    private var paymentMethodSection: some View {
        VStack(alignment: .leading, spacing: FH.Spacing.md) {
            Text("PAYMENT METHOD")
                .font(.system(size: 12, weight: .semibold))
                .foregroundStyle(FH.Colors.textSubtle)
                .tracking(1.2)

            if let method = paymentMethod {
                Button {
                    showAddPaymentMethod = true
                } label: {
                    HStack(spacing: FH.Spacing.md) {
                        ZStack {
                            RoundedRectangle(cornerRadius: FH.Radius.md)
                                .fill(FH.Colors.primary.opacity(0.12))
                                .frame(width: 36, height: 36)
                            Image(systemName: "creditcard.fill")
                                .font(.system(size: 14))
                                .foregroundStyle(FH.Colors.primary)
                        }

                        VStack(alignment: .leading, spacing: 2) {
                            Text("\(method.brand) ···· \(method.lastFour)")
                                .font(.system(size: 15, weight: .semibold))
                                .foregroundStyle(FH.Colors.text)
                            Text("Expires \(method.expiryMonth)/\(method.expiryYear)")
                                .font(.system(size: 13))
                                .foregroundStyle(FH.Colors.textMuted)
                        }

                        Spacer()

                        Image(systemName: "chevron.right")
                            .font(.system(size: 14))
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
                .buttonStyle(.plain)
            } else {
                Button {
                    showAddPaymentMethod = true
                } label: {
                    HStack(spacing: FH.Spacing.md) {
                        ZStack {
                            RoundedRectangle(cornerRadius: FH.Radius.md)
                                .fill(FH.Colors.textSubtle.opacity(0.12))
                                .frame(width: 36, height: 36)
                            Image(systemName: "creditcard")
                                .font(.system(size: 14))
                                .foregroundStyle(FH.Colors.textSubtle)
                        }

                        Text("Add payment method")
                            .font(.system(size: 15, weight: .medium))
                            .foregroundStyle(FH.Colors.textMuted)

                        Spacer()

                        Image(systemName: "plus")
                            .font(.system(size: 14))
                            .foregroundStyle(FH.Colors.primary)
                    }
                    .padding(FH.Spacing.md)
                    .background(FH.Colors.surface)
                    .clipShape(RoundedRectangle(cornerRadius: FH.Radius.lg))
                    .overlay(
                        RoundedRectangle(cornerRadius: FH.Radius.lg)
                            .stroke(FH.Colors.border, lineWidth: 1)
                    )
                }
                .buttonStyle(.plain)
            }
        }
    }

    // MARK: - History

    private var historySection: some View {
        VStack(alignment: .leading, spacing: FH.Spacing.md) {
            Text("PAYMENT HISTORY")
                .font(.system(size: 12, weight: .semibold))
                .foregroundStyle(FH.Colors.textSubtle)
                .tracking(1.2)

            VStack(spacing: FH.Spacing.sm) {
                ForEach(history) { item in
                    historyRow(item)
                }
            }
        }
    }

    private func historyRow(_ item: PaymentHistoryItem) -> some View {
        HStack(spacing: FH.Spacing.md) {
            VStack(alignment: .leading, spacing: 2) {
                Text(item.description)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(FH.Colors.text)
                Text(item.date.formatted(date: .abbreviated, time: .omitted))
                    .font(.system(size: 13))
                    .foregroundStyle(FH.Colors.textMuted)
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 2) {
                Text(item.amount)
                    .font(.system(size: 15, weight: .semibold, design: .rounded))
                    .foregroundStyle(FH.Colors.text)

                Text(item.status.rawValue)
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundStyle(statusColor(item.status))
                    .padding(.horizontal, 8)
                    .padding(.vertical, 3)
                    .background(statusColor(item.status).opacity(0.12))
                    .clipShape(Capsule())
            }
        }
        .padding(FH.Spacing.md)
        .background(FH.Colors.surface)
        .clipShape(RoundedRectangle(cornerRadius: FH.Radius.lg))
        .overlay(
            RoundedRectangle(cornerRadius: FH.Radius.lg)
                .stroke(FH.Colors.border, lineWidth: 1)
        )
    }

    private func statusColor(_ status: PaymentHistoryItem.PaymentStatus) -> Color {
        switch status {
        case .paid: return FH.Colors.success
        case .pending: return FH.Colors.warning
        case .failed: return FH.Colors.danger
        }
    }

    private func statusPill(_ status: String) -> some View {
        let color: Color = status == "Active" ? FH.Colors.success : FH.Colors.textSubtle
        return Text(status)
            .font(.system(size: 11, weight: .semibold))
            .foregroundStyle(color)
            .padding(.horizontal, 10)
            .padding(.vertical, 4)
            .background(color.opacity(0.12))
            .clipShape(Capsule())
    }
}

// MARK: - Sample Data

extension SampleData {
    static let subscriptionPlan = SubscriptionPlan(
        name: "Pro — 3×/week",
        amount: "$149",
        billingInterval: "month",
        nextBillingDate: Calendar.current.date(byAdding: .day, value: 14, to: Date())!,
        status: "Active"
    )

    static let paymentHistory: [PaymentHistoryItem] = {
        let cal = Calendar.current
        let now = Date()
        return [
            PaymentHistoryItem(
                date: cal.date(byAdding: .day, value: -2, to: now)!,
                amount: "$149.00",
                status: .paid,
                description: "Pro plan — April",
                receiptId: "R-2026-0412"
            ),
            PaymentHistoryItem(
                date: cal.date(byAdding: .month, value: -1, to: now)!,
                amount: "$149.00",
                status: .paid,
                description: "Pro plan — March",
                receiptId: "R-2026-0312"
            ),
            PaymentHistoryItem(
                date: cal.date(byAdding: .month, value: -2, to: now)!,
                amount: "$149.00",
                status: .paid,
                description: "Pro plan — February",
                receiptId: "R-2026-0212"
            ),
        ]
    }()
}

#Preview {
    NavigationStack {
        PaymentsView()
    }
    .preferredColorScheme(.dark)
}
