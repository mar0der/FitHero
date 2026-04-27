import SwiftUI

// MARK: - Helper for sheet presentation

private struct SelectedTest: Identifiable {
    var id: String { test.id }
    let test: EvalTest
    let category: EvalCategory
}

// MARK: - Container

struct NewClientEvaluationView: View {
    @State private var variation = 0              // 0 = A (Session board), 1 = B (Stopwatch)
    @State private var categories = EvalCategory.samples
    @State private var selectedTest: SelectedTest?

    var body: some View {
        ZStack(alignment: .topTrailing) {
            EvalStyle.bg.ignoresSafeArea()

            if variation == 0 {
                EvaluationVariationAView(
                    categories: $categories,
                    onOpenTest: { test, cat in selectedTest = SelectedTest(test: test, category: cat) }
                )
            } else {
                EvaluationVariationBView(
                    categories: $categories,
                    onOpenTest: { test, cat in selectedTest = SelectedTest(test: test, category: cat) }
                )
            }

            // Floating variation switcher
            variationPicker
                .padding(.top, 10)
                .padding(.trailing, 16)
        }
        .preferredColorScheme(.dark)
        .sheet(item: $selectedTest) { sel in
            EvaluationDetailSheet(test: sel.test, category: sel.category)
                .presentationDetents([.fraction(0.78)])
                .presentationDragIndicator(.hidden)
        }
    }

    // MARK: - Variation picker

    private var variationPicker: some View {
        HStack(spacing: 0) {
            ForEach([("A", 0), ("B", 1)], id: \.1) { label, idx in
                Button { withAnimation(.easeInOut(duration: 0.15)) { variation = idx } } label: {
                    Text(label)
                        .font(.system(size: 11, weight: .bold, design: .monospaced))
                        .foregroundStyle(variation == idx ? Color.black : EvalStyle.text)
                        .frame(width: 34, height: 26)
                        .background(variation == idx ? EvalStyle.accent : Color.clear)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                }
                .buttonStyle(.plain)
            }
        }
        .padding(3)
        .background(Color.white.opacity(0.08))
        .clipShape(RoundedRectangle(cornerRadius: 11))
    }
}

// MARK: - Preview

#Preview {
    NewClientEvaluationView()
}
