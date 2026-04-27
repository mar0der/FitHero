import SwiftUI

// Variation B — "Stopwatch console"
// 9 category nodes arranged on a circular dial · stopwatch-style center readout
// Selected category test list below · transport bar at bottom

struct EvaluationVariationBView: View {
    @Binding var categories: [EvalCategory]
    let onOpenTest: (EvalTest, EvalCategory) -> Void

    @State private var selectedId: String = "mobility"

    private var selected: EvalCategory {
        categories.first(where: { $0.id == selectedId }) ?? categories[0]
    }
    private var selectedIndex: Int {
        categories.firstIndex(where: { $0.id == selectedId }) ?? 0
    }
    private var totalTests: Int { categories.reduce(0) { $0 + $1.tests.count } }
    private var doneTests:  Int { categories.reduce(0) { $0 + $1.doneCount  } }
    private var overallProgress: Double { totalTests > 0 ? Double(doneTests) / Double(totalTests) : 0 }

    // Dial geometry
    private let dialSize: CGFloat = 280
    private let dialRadius: CGFloat = 108
    private let nodeSize: CGFloat = 44

    // MARK: - Body

    var body: some View {
        ZStack(alignment: .bottom) {
            ScrollView {
                VStack(spacing: 0) {
                    topBar
                    titleBlock
                    dial
                    hintRow
                    selectedCategoryList
                }
                .padding(.bottom, 100)
            }
            .scrollIndicators(.hidden)

            transportBar
        }
        .background(EvalStyle.bg)
    }

    // MARK: - Top bar

    private var topBar: some View {
        HStack {
            HStack(spacing: 6) {
                Circle()
                    .fill(EvalStyle.accent)
                    .frame(width: 6, height: 6)
                Text("REC · 00:14:22")
                    .font(.system(size: 11, design: .monospaced))
                    .foregroundStyle(EvalStyle.muted)
                    .tracking(0.8)
            }
            Spacer()
            HStack(spacing: 10) {
                Text(EvalClient.sample.initials)
                    .font(.system(size: 10, weight: .bold))
                    .foregroundStyle(Color.black)
                    .frame(width: 26, height: 26)
                    .background(EvalStyle.accent)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                Text(EvalClient.sample.firstName)
                    .font(.system(size: 11, design: .monospaced))
                    .foregroundStyle(EvalStyle.text)
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 16)
        .padding(.bottom, 6)
    }

    // MARK: - Title block

    private var titleBlock: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Protocol · Initial Evaluation")
                .font(.system(size: 11, design: .monospaced))
                .foregroundStyle(EvalStyle.muted)
                .tracking(1.2)
                .textCase(.uppercase)
            HStack(spacing: 0) {
                Text("Assess ")
                    .foregroundStyle(EvalStyle.text)
                Text("9 systems")
                    .foregroundStyle(EvalStyle.accent)
                Text(" in 60 min")
                    .foregroundStyle(EvalStyle.muted)
                    .fontWeight(.medium)
            }
            .font(.system(size: 26, weight: .bold))
            .tracking(-0.8)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 20)
        .padding(.bottom, 0)
    }

    // MARK: - Circular dial

    private var dial: some View {
        ZStack {
            // Outer dashed ring
            Circle()
                .stroke(style: StrokeStyle(lineWidth: 1, dash: [2, 4]))
                .foregroundStyle(EvalStyle.muted)
                .frame(width: dialSize, height: dialSize)

            // Overall progress ring (inset 14pt each side)
            EvalRing(size: dialSize - 28, strokeWidth: 3, progress: overallProgress)

            // Center readout
            dialCenter

            // Category nodes
            ForEach(Array(categories.enumerated()), id: \.element.id) { i, cat in
                dialNode(cat: cat, index: i)
            }
        }
        .frame(width: dialSize, height: dialSize)
        .padding(.top, 18)
        .padding(.bottom, 6)
    }

    private var dialCenter: some View {
        VStack(spacing: 0) {
            Text(selected.short)
                .font(.system(size: 11, design: .monospaced))
                .foregroundStyle(EvalStyle.muted)
                .tracking(1.5)
                .textCase(.uppercase)

            HStack(alignment: .firstTextBaseline, spacing: 0) {
                Text(String(format: "%02d", selected.doneCount))
                    .foregroundColor(EvalStyle.text)
                Text("/\(String(format: "%02d", selected.tests.count))")
                    .foregroundColor(EvalStyle.muted)
                    .fontWeight(.light)
            }
            .font(.system(size: 56, weight: .semibold, design: .monospaced))
            .tracking(-3)
            .minimumScaleFactor(0.5)
            .lineLimit(1)

            Text(selected.name)
                .font(.system(size: 13, weight: .medium))
                .foregroundStyle(EvalStyle.text)
                .tracking(-0.2)
                .multilineTextAlignment(.center)
                .padding(.top, 6)

            Text("Total \(doneTests)/\(totalTests) · \(Int(overallProgress * 100))%")
                .font(.system(size: 10, design: .monospaced))
                .foregroundStyle(EvalStyle.muted)
                .tracking(1.2)
                .textCase(.uppercase)
                .padding(.top, 10)
        }
        .frame(width: dialSize - 80)
        .multilineTextAlignment(.center)
    }

    private func dialNode(cat: EvalCategory, index: Int) -> some View {
        let n = categories.count
        let angle = Double(index) / Double(n) * 2 * .pi - .pi / 2
        let cx = dialSize / 2
        let cy = dialSize / 2
        let x = cx + dialRadius * CGFloat(cos(angle))
        let y = cy + dialRadius * CGFloat(sin(angle))

        let isActive = cat.id == selectedId
        let isDone   = cat.progress >= 1.0

        return Button { withAnimation(.easeInOut(duration: 0.15)) { selectedId = cat.id } } label: {
            Text(cat.short)
                .font(.system(size: 10, weight: .bold, design: .monospaced))
                .foregroundStyle(isActive ? Color.black : (isDone ? EvalStyle.accent : EvalStyle.text))
                .tracking(0.3)
                .frame(width: nodeSize, height: nodeSize)
                .background(isActive ? EvalStyle.accent : (isDone ? Color.clear : EvalStyle.card))
                .clipShape(Circle())
                .overlay(
                    Circle().stroke(
                        isActive ? EvalStyle.accent : (isDone ? EvalStyle.accent : EvalStyle.hair),
                        lineWidth: 1.5
                    )
                )
                .shadow(color: isActive ? EvalStyle.accent.opacity(0.2) : .clear, radius: 8)
        }
        .buttonStyle(.plain)
        .position(x: x, y: y)
    }

    // MARK: - Hint row

    private var hintRow: some View {
        HStack(spacing: 8) {
            Text("Tap node to jump")
            Text("·")
            Text("\(selected.tests.count) tests")
        }
        .font(.system(size: 10, design: .monospaced))
        .foregroundStyle(EvalStyle.muted)
        .tracking(1)
        .textCase(.uppercase)
        .padding(.bottom, 14)
    }

    // MARK: - Selected category list

    private var selectedCategoryList: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text(selected.name)
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(EvalStyle.text)
                        .tracking(-0.3)
                    Text("Protocol \(selected.short)-01")
                        .font(.system(size: 10, design: .monospaced))
                        .foregroundStyle(EvalStyle.muted)
                        .tracking(1)
                        .textCase(.uppercase)
                }
                Spacer()
                Text("\(selected.doneCount)/\(selected.tests.count)")
                    .font(.system(size: 11, weight: .bold, design: .monospaced))
                    .foregroundStyle(Color.black)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(EvalStyle.accent)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .tracking(0.5)
            }
            .padding(.horizontal, 18)
            .padding(.vertical, 14)

            Divider().background(EvalStyle.hair)

            // Rows
            ForEach(Array(selected.tests.enumerated()), id: \.element.id) { i, test in
                Button { onOpenTest(test, selected) } label: {
                    HStack(spacing: 12) {
                        Text(String(format: "%02d", i + 1))
                            .font(.system(size: 10, design: .monospaced))
                            .foregroundStyle(EvalStyle.muted)
                            .tracking(0.5)
                            .frame(width: 22, alignment: .trailing)

                        ZStack {
                            Circle()
                                .fill(test.done ? EvalStyle.accent : Color.clear)
                                .frame(width: 20, height: 20)
                            Circle()
                                .stroke(test.done ? EvalStyle.accent : Color.white.opacity(0.2), lineWidth: 1.5)
                                .frame(width: 20, height: 20)
                            if test.done {
                                Image(systemName: "checkmark")
                                    .font(.system(size: 9, weight: .bold))
                                    .foregroundStyle(Color.black)
                            }
                        }

                        VStack(alignment: .leading, spacing: 2) {
                            Text(test.name)
                                .font(.system(size: 14, weight: .medium))
                                .foregroundStyle(test.done ? EvalStyle.muted : EvalStyle.text)
                                .strikethrough(test.done, color: EvalStyle.muted)
                            Text([test.tool, test.target.map { "→ \($0)" }].compactMap { $0 }.joined(separator: " "))
                                .font(.system(size: 10, design: .monospaced))
                                .foregroundStyle(EvalStyle.muted)
                                .tracking(0.3)
                        }

                        Spacer()

                        Text(test.value ?? "—")
                            .font(.system(size: 12, weight: .semibold, design: .monospaced))
                            .foregroundStyle(test.value != nil ? EvalStyle.accent : EvalStyle.muted)
                            .frame(minWidth: 44, alignment: .trailing)
                    }
                    .padding(.horizontal, 18)
                    .padding(.vertical, 14)
                }
                .buttonStyle(.plain)

                if i < selected.tests.count - 1 {
                    Divider().background(EvalStyle.hair).padding(.horizontal, 18)
                }
            }
        }
        .background(EvalStyle.card)
        .clipShape(RoundedRectangle(cornerRadius: 22))
        .overlay(RoundedRectangle(cornerRadius: 22).stroke(EvalStyle.hair, lineWidth: 1))
        .padding(.horizontal, 16)
    }

    // MARK: - Transport bar

    private var transportBar: some View {
        let nextTestNum = selected.tests.filter(\.done).count + 1

        return HStack(spacing: 6) {
            Button {} label: {
                Image(systemName: "pause.fill")
                    .font(.system(size: 14))
                    .foregroundStyle(EvalStyle.text)
                    .frame(width: 44, height: 44)
                    .background(Color.white.opacity(0.06))
                    .clipShape(Circle())
            }

            VStack(alignment: .leading, spacing: 1) {
                Text("\(selected.name) · test \(nextTestNum)")
                    .font(.system(size: 12, weight: .semibold, design: .monospaced))
                    .foregroundStyle(EvalStyle.text)
                    .tracking(0.5)
                Text("ELAPSED 14:22 · REM 45:38")
                    .font(.system(size: 10, design: .monospaced))
                    .foregroundStyle(EvalStyle.muted)
                    .tracking(0.5)
            }

            Spacer()

            Button {} label: {
                HStack(spacing: 6) {
                    Text("Start")
                        .font(.system(size: 14, weight: .bold))
                    Image(systemName: "play.fill")
                        .font(.system(size: 12))
                }
                .foregroundStyle(Color.black)
                .padding(.horizontal, 18)
                .frame(height: 44)
                .background(EvalStyle.accent)
                .clipShape(Capsule())
            }
        }
        .padding(.horizontal, 6)
        .padding(.vertical, 6)
        .background(EvalStyle.card)
        .clipShape(Capsule())
        .overlay(Capsule().stroke(EvalStyle.hair, lineWidth: 1))
        .padding(.horizontal, 16)
        .padding(.bottom, 24)
    }
}
