import SwiftUI

struct AddPaymentMethodView: View {
    @Environment(\.dismiss) private var dismiss
    let onSave: (PaymentMethod) -> Void

    @State private var cardNumber = ""
    @State private var expiryMonth = ""
    @State private var expiryYear = ""
    @State private var cvc = ""
    @State private var cardBrand = "Visa"

    private let brands = ["Visa", "Mastercard", "Amex"]
    private var isValid: Bool {
        cardNumber.count >= 4 && expiryMonth.count == 2 && expiryYear.count == 2 && cvc.count >= 3
    }

    var body: some View {
        NavigationStack {
            ZStack {
                FH.Colors.bg.ignoresSafeArea()

                ScrollView(showsIndicators: false) {
                    VStack(spacing: FH.Spacing.xl) {
                        cardPreview
                        formSection
                        actionButtons
                    }
                    .padding(.horizontal, FH.Spacing.base)
                    .padding(.bottom, FH.Spacing.xxxl)
                }
            }
            .navigationTitle("Add Card")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button { dismiss() } label: {
                        Image(systemName: "xmark")
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundStyle(FH.Colors.text)
                    }
                }
            }
        }
        .preferredColorScheme(.dark)
    }

    // MARK: - Card Preview

    private var cardPreview: some View {
        VStack(alignment: .leading, spacing: FH.Spacing.lg) {
            HStack {
                Text(cardBrand.uppercased())
                    .font(.system(size: 14, weight: .bold))
                    .tracking(2)
                    .foregroundStyle(FH.Colors.primary)
                Spacer()
                Image(systemName: "creditcard.fill")
                    .font(.system(size: 24))
                    .foregroundStyle(FH.Colors.primary)
            }

            Text(formattedCardNumber)
                .font(.system(size: 24, weight: .medium, design: .monospaced))
                .foregroundStyle(FH.Colors.text)

            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text("EXPIRES")
                        .font(.system(size: 9, weight: .semibold))
                        .foregroundStyle(FH.Colors.textSubtle)
                        .tracking(1)
                    Text("\(expiryMonth)/\(expiryYear)")
                        .font(.system(size: 15, weight: .medium, design: .monospaced))
                        .foregroundStyle(FH.Colors.text)
                }

                Spacer()

                if !cvc.isEmpty {
                    VStack(alignment: .trailing, spacing: 2) {
                        Text("CVC")
                            .font(.system(size: 9, weight: .semibold))
                            .foregroundStyle(FH.Colors.textSubtle)
                            .tracking(1)
                        Text(String(repeating: "•", count: cvc.count))
                            .font(.system(size: 15, weight: .medium, design: .monospaced))
                            .foregroundStyle(FH.Colors.text)
                    }
                }
            }
        }
        .padding(FH.Spacing.xl)
        .background(
            LinearGradient(
                colors: [FH.Colors.surface, FH.Colors.surface2],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .clipShape(RoundedRectangle(cornerRadius: FH.Radius.xl))
        .overlay(
            RoundedRectangle(cornerRadius: FH.Radius.xl)
                .stroke(FH.Colors.primary.opacity(0.2), lineWidth: 1)
        )
        .padding(.top, FH.Spacing.lg)
    }

    private var formattedCardNumber: String {
        let digits = cardNumber.filter { $0.isNumber }
        guard !digits.isEmpty else {
            return "•••• •••• •••• ••••"
        }
        var result = ""
        for (index, char) in digits.enumerated() {
            if index > 0 && index % 4 == 0 {
                result += " "
            }
            if index < 4 {
                result.append(char)
            } else {
                result.append("•")
            }
        }
        // Pad remaining groups
        let totalGroups = 4
        let currentGroups = (result.count + 3) / 4
        let remainingGroups = totalGroups - currentGroups
        if remainingGroups > 0 {
            for g in 0..<remainingGroups {
                if !result.isEmpty { result += " " }
                result += "••••"
            }
        }
        return result
    }

    // MARK: - Form

    private var formSection: some View {
        VStack(spacing: FH.Spacing.lg) {
            VStack(alignment: .leading, spacing: FH.Spacing.sm) {
                Text("CARD BRAND")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(FH.Colors.textSubtle)
                    .tracking(1.2)

                HStack(spacing: FH.Spacing.sm) {
                    ForEach(brands, id: \.self) { brand in
                        Button {
                            cardBrand = brand
                        } label: {
                            Text(brand)
                                .font(.system(size: 13, weight: cardBrand == brand ? .semibold : .medium))
                                .foregroundStyle(cardBrand == brand ? FH.Colors.primaryInk : FH.Colors.textMuted)
                                .padding(.horizontal, 14)
                                .padding(.vertical, 8)
                                .background(cardBrand == brand ? FH.Colors.primary : FH.Colors.surface2)
                                .clipShape(Capsule())
                                .overlay(
                                    Capsule()
                                        .stroke(cardBrand == brand ? FH.Colors.primary : FH.Colors.border, lineWidth: 1)
                                )
                        }
                        .buttonStyle(.plain)
                    }
                }
            }

            inputField(label: "Card number", text: $cardNumber, placeholder: "4242 4242 4242 4242", keyboard: .numberPad)

            HStack(spacing: FH.Spacing.md) {
                inputField(label: "MM", text: $expiryMonth, placeholder: "04", keyboard: .numberPad)
                inputField(label: "YY", text: $expiryYear, placeholder: "28", keyboard: .numberPad)
                inputField(label: "CVC", text: $cvc, placeholder: "123", keyboard: .numberPad)
            }
        }
    }

    private var actionButtons: some View {
        VStack(spacing: FH.Spacing.md) {
            Button {
                let method = PaymentMethod(
                    brand: cardBrand,
                    lastFour: String(cardNumber.suffix(4)),
                    expiryMonth: expiryMonth,
                    expiryYear: expiryYear
                )
                onSave(method)
                dismiss()
            } label: {
                Text("Save card")
            }
            .buttonStyle(FHPrimaryButtonStyle())
            .disabled(!isValid)
            .opacity(isValid ? 1 : 0.5)

            Button {
                dismiss()
            } label: {
                Text("Skip for now")
                    .font(.system(size: 15, weight: .medium))
                    .foregroundStyle(FH.Colors.textMuted)
            }
            .buttonStyle(.plain)
        }
    }

    private func inputField(
        label: String,
        text: Binding<String>,
        placeholder: String,
        keyboard: UIKeyboardType = .default
    ) -> some View {
        VStack(alignment: .leading, spacing: FH.Spacing.sm) {
            Text(label.uppercased())
                .font(.system(size: 12, weight: .semibold))
                .foregroundStyle(FH.Colors.textSubtle)
                .tracking(1.2)

            TextField(placeholder, text: text)
                .font(.system(size: 17, weight: .medium, design: .monospaced))
                .foregroundStyle(FH.Colors.text)
                .keyboardType(keyboard)
                .padding(.horizontal, FH.Spacing.md)
                .padding(.vertical, FH.Spacing.md)
                .background(FH.Colors.surface)
                .clipShape(RoundedRectangle(cornerRadius: FH.Radius.md))
                .overlay(
                    RoundedRectangle(cornerRadius: FH.Radius.md)
                        .stroke(FH.Colors.border, lineWidth: 1)
                )
        }
    }
}

#Preview {
    AddPaymentMethodView { _ in }
        .preferredColorScheme(.dark)
}
