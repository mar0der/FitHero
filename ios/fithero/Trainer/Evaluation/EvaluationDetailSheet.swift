import SwiftUI

// MARK: - Shared design tokens (evaluation screens)

enum EvalStyle {
    static let accent     = FH.Colors.primary                                   // #C6FF3D
    static let bg         = Color(hex: 0x000000)
    static let card       = Color(hex: 0x111111)
    static let sheetBg    = Color(hex: 0x0F0F0F)
    static let hair       = Color.white.opacity(0.06)
    static let track      = Color.white.opacity(0.08)
    static let muted      = Color(red: 235/255, green: 235/255, blue: 245/255).opacity(0.55)
    static let text       = Color.white
}

// MARK: - Ring

struct EvalRing: View {
    let size: CGFloat
    let strokeWidth: CGFloat
    let progress: Double

    var body: some View {
        ZStack {
            Circle()
                .stroke(EvalStyle.track, lineWidth: strokeWidth)
            Circle()
                .trim(from: 0, to: CGFloat(min(progress, 1)))
                .stroke(EvalStyle.accent,
                        style: StrokeStyle(lineWidth: strokeWidth, lineCap: .round))
                .rotationEffect(.degrees(-90))
                .animation(.easeInOut(duration: 0.3), value: progress)
        }
        .frame(width: size, height: size)
    }
}

// MARK: - Detail sheet

struct EvaluationDetailSheet: View {
    let test: EvalTest
    let category: EvalCategory
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            EvalStyle.sheetBg.ignoresSafeArea()
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    handle
                    VStack(alignment: .leading, spacing: 0) {
                        categoryLabel
                        testTitle
                        metaGrid    .padding(.top, 18)
                        protocol_   .padding(.top, 22)
                        recordValue .padding(.top, 20)
                        swipeHint   .padding(.top, 14)
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 60)
                }
            }
        }
        .preferredColorScheme(.dark)
    }

    // MARK: Sub-views

    private var handle: some View {
        RoundedRectangle(cornerRadius: 100)
            .fill(Color.white.opacity(0.2))
            .frame(width: 38, height: 5)
            .frame(maxWidth: .infinity)
            .padding(.top, 10)
            .padding(.bottom, 14)
    }

    private var categoryLabel: some View {
        Text("\(category.name) · \(category.short)-\(test.id)")
            .font(.system(size: 10, weight: .medium, design: .monospaced))
            .foregroundStyle(EvalStyle.muted)
            .tracking(1.2)
            .textCase(.uppercase)
    }

    private var testTitle: some View {
        Text(test.name)
            .font(.system(size: 24, weight: .bold))
            .foregroundStyle(EvalStyle.text)
            .tracking(-0.5)
            .padding(.top, 6)
    }

    private var metaGrid: some View {
        let items: [(label: String, value: String, highlight: Bool)] = [
            ("Tool",     test.tool,             false),
            ("Metric",   test.metric,           false),
            ("Target",   test.target ?? "—",    false),
            ("Recorded", test.value ?? "— not yet —", test.value != nil),
        ]
        return LazyVGrid(
            columns: [GridItem(.flexible(), spacing: 1), GridItem(.flexible(), spacing: 1)],
            spacing: 1
        ) {
            ForEach(items.indices, id: \.self) { i in
                VStack(alignment: .leading, spacing: 4) {
                    Text(items[i].label)
                        .font(.system(size: 9, weight: .medium, design: .monospaced))
                        .foregroundStyle(EvalStyle.muted)
                        .tracking(1.2)
                        .textCase(.uppercase)
                    Text(items[i].value)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(items[i].highlight ? EvalStyle.accent : EvalStyle.text)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 14)
                .padding(.vertical, 12)
                .background(EvalStyle.card)
            }
        }
        .background(EvalStyle.hair)
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .overlay(RoundedRectangle(cornerRadius: 14).stroke(EvalStyle.hair, lineWidth: 1))
    }

    private var protocol_: some View {
        let steps = [
            "Brief the client on the test and its purpose.",
            "Ensure neutral start position; demo once.",
            "Record \(test.metric)\(test.target.map { " — compare to target \($0)" } ?? "").",
            "Log bilateral values if applicable. Note pain or compensation.",
        ]
        return VStack(alignment: .leading, spacing: 0) {
            Text("Protocol")
                .font(.system(size: 10, weight: .medium, design: .monospaced))
                .foregroundStyle(EvalStyle.muted)
                .tracking(1.2)
                .textCase(.uppercase)
                .padding(.bottom, 8)
            ForEach(steps.indices, id: \.self) { i in
                HStack(alignment: .top, spacing: 12) {
                    Text(String(format: "%02d", i + 1))
                        .font(.system(size: 11, weight: .bold, design: .monospaced))
                        .foregroundStyle(EvalStyle.accent)
                        .frame(width: 18, alignment: .trailing)
                    Text(steps[i])
                        .font(.system(size: 14))
                        .foregroundStyle(EvalStyle.text)
                        .lineSpacing(4)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .padding(.vertical, 10)
                if i < steps.count - 1 {
                    Divider().background(EvalStyle.hair)
                }
            }
        }
    }

    private var recordValue: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Record value")
                .font(.system(size: 10, weight: .medium, design: .monospaced))
                .foregroundStyle(EvalStyle.muted)
                .tracking(1.2)
                .textCase(.uppercase)
            HStack(spacing: 10) {
                Text(test.value ?? "— \(test.metric)")
                    .font(.system(size: 24, weight: .semibold, design: .monospaced))
                    .foregroundStyle(test.value != nil ? EvalStyle.text : EvalStyle.muted)
                    .tracking(-1)
                Spacer()
                Button(test.done ? "Update" : "Log result") {}
                    .font(.system(size: 13, weight: .bold))
                    .foregroundStyle(Color.black)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                    .background(EvalStyle.accent)
                    .clipShape(Capsule())
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            .background(Color.white.opacity(0.04))
            .clipShape(RoundedRectangle(cornerRadius: 14))
            .overlay(RoundedRectangle(cornerRadius: 14).stroke(EvalStyle.hair, lineWidth: 1))
        }
    }

    private var swipeHint: some View {
        Text("Swipe down to close")
            .font(.system(size: 10, design: .monospaced))
            .foregroundStyle(EvalStyle.muted)
            .tracking(0.8)
            .frame(maxWidth: .infinity)
    }
}
