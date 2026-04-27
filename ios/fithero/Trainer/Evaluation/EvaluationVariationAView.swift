import SwiftUI

// Variation A — "Session board"
// Hero completion dial · client card · category filter pills · expandable accordion with test rows

struct EvaluationVariationAView: View {
    @Binding var categories: [EvalCategory]
    let onOpenTest: (EvalTest, EvalCategory) -> Void

    @State private var filter: String = "all"
    @State private var expanded: Set<String> = ["mobility", "posture"]

    // MARK: - Computed

    private var totalTests: Int { categories.reduce(0) { $0 + $1.tests.count } }
    private var doneTests:  Int { categories.reduce(0) { $0 + $1.doneCount  } }
    private var overallProgress: Double { totalTests > 0 ? Double(doneTests) / Double(totalTests) : 0 }

    private var visibleCategories: [EvalCategory] {
        filter == "all" ? categories : categories.filter { $0.id == filter }
    }

    private var nextPending: (test: EvalTest, category: EvalCategory)? {
        for cat in categories {
            if let t = cat.tests.first(where: { !$0.done }) { return (t, cat) }
        }
        return nil
    }

    // MARK: - Body

    var body: some View {
        ZStack(alignment: .bottom) {
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    topMetaStrip
                    titleBlock
                    heroCard
                    filterPills
                    categorySections
                }
                .padding(.bottom, 100)
            }
            .scrollIndicators(.hidden)

            if let next = nextPending {
                bottomCTA(next: next)
            }
        }
        .background(EvalStyle.bg)
    }

    // MARK: - Top meta strip

    private var topMetaStrip: some View {
        HStack {
            Text("● LIVE · 10:32")
            Spacer()
            Text("SESSION 01 / NEW CLIENT")
        }
        .font(.system(size: 11, design: .monospaced))
        .foregroundStyle(EvalStyle.muted)
        .tracking(0.6)
        .textCase(.uppercase)
        .padding(.horizontal, 20)
        .padding(.top, 16)
        .padding(.bottom, 8)
    }

    // MARK: - Title

    private var titleBlock: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text("Evaluation")
                .font(.system(size: 13, design: .monospaced))
                .foregroundStyle(EvalStyle.muted)
                .tracking(1)
                .textCase(.uppercase)
            Text("\(EvalClient.sample.firstName)'s baseline")
                .font(.system(size: 34, weight: .bold))
                .foregroundStyle(EvalStyle.text)
                .tracking(-1.2)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 8)
    }

    // MARK: - Hero card

    private var heroCard: some View {
        HStack(spacing: 18) {
            // Dial
            ZStack {
                EvalRing(size: 124, strokeWidth: 10, progress: overallProgress)
                VStack(spacing: 4) {
                    HStack(alignment: .firstTextBaseline, spacing: 0) {
                        Text("\(doneTests)")
                            .foregroundStyle(EvalStyle.text)
                        Text("/\(totalTests)")
                            .foregroundStyle(EvalStyle.muted)
                    }
                    .font(.system(size: 28, weight: .semibold, design: .monospaced))
                    .tracking(-1)
                    Text("Tests done")
                        .font(.system(size: 10, design: .monospaced))
                        .foregroundStyle(EvalStyle.muted)
                        .tracking(1.2)
                        .textCase(.uppercase)
                }
            }
            .frame(width: 124, height: 124)

            // Client info
            VStack(alignment: .leading, spacing: 0) {
                HStack(spacing: 10) {
                    Text(EvalClient.sample.initials)
                        .font(.system(size: 13, weight: .bold))
                        .foregroundStyle(Color.black)
                        .frame(width: 36, height: 36)
                        .background(EvalStyle.accent)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    Text(EvalClient.sample.name)
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundStyle(EvalStyle.text)
                }
                Text("\(EvalClient.sample.age) · \(EvalClient.sample.sex) · \(EvalClient.sample.height) · \(EvalClient.sample.weight)")
                    .font(.system(size: 12))
                    .foregroundStyle(EvalStyle.muted)
                    .lineSpacing(3)
                    .padding(.top, 8)
                // Goal badge
                HStack(spacing: 0) {
                    Text("Goal — ").foregroundStyle(EvalStyle.muted)
                    Text(EvalClient.sample.goal).foregroundStyle(EvalStyle.text)
                }
                .font(.system(size: 12))
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .background(EvalStyle.accent.opacity(0.08))
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .overlay(RoundedRectangle(cornerRadius: 8).stroke(EvalStyle.hair, lineWidth: 1))
                .padding(.top, 6)
            }
            Spacer(minLength: 0)
        }
        .padding(20)
        .background(EvalStyle.card)
        .clipShape(RoundedRectangle(cornerRadius: 28))
        .overlay(RoundedRectangle(cornerRadius: 28).stroke(EvalStyle.hair, lineWidth: 1))
        .padding(.horizontal, 16)
        .padding(.top, 16)
        .padding(.bottom, 20)
    }

    // MARK: - Filter pills

    private var filterPills: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                pill(id: "all", label: "All")
                ForEach(categories) { cat in pill(id: cat.id, label: cat.short) }
            }
            .padding(.horizontal, 16)
        }
        .padding(.bottom, 16)
    }

    private func pill(id: String, label: String) -> some View {
        let active = filter == id
        return Button { filter = id } label: {
            Text(label)
                .font(.system(size: 11, weight: .semibold, design: .monospaced))
                .foregroundStyle(active ? Color.black : EvalStyle.text)
                .tracking(0.8)
                .textCase(.uppercase)
                .padding(.horizontal, 14)
                .padding(.vertical, 8)
                .background(active ? EvalStyle.accent : Color.clear)
                .clipShape(Capsule())
                .overlay(Capsule().stroke(active ? EvalStyle.accent : EvalStyle.hair, lineWidth: 1))
        }
        .buttonStyle(.plain)
    }

    // MARK: - Category sections

    private var categorySections: some View {
        VStack(spacing: 12) {
            ForEach(visibleCategories) { cat in
                categoryCard(cat)
            }
        }
        .padding(.horizontal, 16)
    }

    private func categoryCard(_ cat: EvalCategory) -> some View {
        let isOpen = expanded.contains(cat.id)
        return VStack(spacing: 0) {
            // Header
            Button {
                withAnimation(.easeInOut(duration: 0.2)) {
                    if isOpen { expanded.remove(cat.id) } else { expanded.insert(cat.id) }
                }
            } label: {
                HStack(spacing: 14) {
                    ZStack {
                        EvalRing(size: 44, strokeWidth: 4, progress: cat.progress)
                        Text(cat.short)
                            .font(.system(size: 10, weight: .semibold, design: .monospaced))
                            .foregroundStyle(EvalStyle.text)
                            .tracking(0.5)
                    }
                    .frame(width: 44, height: 44)

                    VStack(alignment: .leading, spacing: 2) {
                        Text(cat.name)
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundStyle(EvalStyle.text)
                            .tracking(-0.3)
                        Text("\(cat.doneCount)/\(cat.tests.count) done")
                            .font(.system(size: 12, design: .monospaced))
                            .foregroundStyle(EvalStyle.muted)
                    }

                    Spacer()

                    Image(systemName: "chevron.right")
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundStyle(EvalStyle.muted)
                        .rotationEffect(.degrees(isOpen ? 90 : 0))
                        .animation(.easeInOut(duration: 0.2), value: isOpen)
                }
                .padding(16)
            }
            .buttonStyle(.plain)

            // Test rows
            if isOpen {
                VStack(spacing: 0) {
                    ForEach(cat.tests) { test in
                        Divider().background(EvalStyle.hair)
                        testRow(test, category: cat)
                    }
                }
                .padding(.bottom, 6)
            }
        }
        .background(EvalStyle.card)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .overlay(RoundedRectangle(cornerRadius: 20).stroke(EvalStyle.hair, lineWidth: 1))
    }

    private func testRow(_ test: EvalTest, category: EvalCategory) -> some View {
        Button { onOpenTest(test, category) } label: {
            HStack(spacing: 12) {
                // Checkbox
                ZStack {
                    RoundedRectangle(cornerRadius: 7)
                        .fill(test.done ? EvalStyle.accent : Color.clear)
                        .frame(width: 22, height: 22)
                    RoundedRectangle(cornerRadius: 7)
                        .stroke(test.done ? EvalStyle.accent : Color.white.opacity(0.2), lineWidth: 1.5)
                        .frame(width: 22, height: 22)
                    if test.done {
                        Image(systemName: "checkmark")
                            .font(.system(size: 11, weight: .bold))
                            .foregroundStyle(Color.black)
                    }
                }

                // Label + tool
                VStack(alignment: .leading, spacing: 2) {
                    Text(test.name)
                        .font(.system(size: 15, weight: .medium))
                        .foregroundStyle(test.done ? EvalStyle.muted : EvalStyle.text)
                        .strikethrough(test.done, color: EvalStyle.muted)
                    Text([test.tool, test.target.map { "target \($0)" }].compactMap { $0 }.joined(separator: " · "))
                        .font(.system(size: 11, design: .monospaced))
                        .foregroundStyle(EvalStyle.muted)
                        .tracking(0.3)
                }

                Spacer()

                if let value = test.value {
                    Text(value)
                        .font(.system(size: 13, weight: .semibold, design: .monospaced))
                        .foregroundStyle(EvalStyle.accent)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(EvalStyle.accent.opacity(0.1))
                        .clipShape(RoundedRectangle(cornerRadius: 6))
                } else {
                    Text("— · —")
                        .font(.system(size: 11, design: .monospaced))
                        .foregroundStyle(EvalStyle.muted)
                        .tracking(0.5)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
        }
        .buttonStyle(.plain)
    }

    // MARK: - Bottom CTA

    private func bottomCTA(next: (test: EvalTest, category: EvalCategory)) -> some View {
        HStack {
            Text("Next: \(next.test.name)")
                .font(.system(size: 15, weight: .semibold))
                .foregroundStyle(Color.black)
            Spacer()
            ZStack {
                Circle()
                    .fill(Color.black)
                    .frame(width: 28, height: 28)
                Image(systemName: "chevron.right")
                    .font(.system(size: 11, weight: .bold))
                    .foregroundStyle(EvalStyle.accent)
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .background(EvalStyle.accent)
        .clipShape(Capsule())
        .shadow(color: EvalStyle.accent.opacity(0.25), radius: 12, x: 0, y: 8)
        .padding(.horizontal, 16)
        .padding(.bottom, 28)
    }
}
