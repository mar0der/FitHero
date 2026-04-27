import SwiftUI
import Charts

struct ClientProgressView: View {
    @State private var selectedTab = 0
    @State private var showAddPhoto = false
    let weightHistory = SampleData.weightHistory
    let personalRecords = SampleData.personalRecords
    let progressPhotos = SampleData.progressPhotos

    var body: some View {
        VStack(spacing: 0) {
            header
            segmentedControl
            ScrollView {
                VStack(spacing: FH.Spacing.xl) {
                    switch selectedTab {
                    case 0: weightSection
                    case 1: prsSection
                    case 2: measurementsSection
                    case 3: photosSection
                    default: EmptyView()
                    }
                }
                .padding(.horizontal, FH.Spacing.base)
                .padding(.bottom, FH.Spacing.xxxl)
            }
        }
        .background(FH.Colors.bg)
        .sheet(isPresented: $showAddPhoto) {
            AddPhotoSheet()
        }
    }

    // MARK: - Header

    private var header: some View {
        HStack {
            VStack(alignment: .leading, spacing: FH.Spacing.xs) {
                Text("Progress")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundStyle(FH.Colors.text)
                Text("8 weeks of training")
                    .font(.system(size: 14))
                    .foregroundStyle(FH.Colors.textMuted)
            }
            Spacer()
            Button {
                // Add entry
            } label: {
                Image(systemName: "plus.circle.fill")
                    .font(.system(size: 28))
                    .foregroundStyle(FH.Colors.primary)
                    .symbolRenderingMode(.hierarchical)
            }
        }
        .padding(.horizontal, FH.Spacing.base)
        .padding(.top, FH.Spacing.lg)
        .padding(.bottom, FH.Spacing.md)
    }

    // MARK: - Segmented Control

    private var segmentedControl: some View {
        HStack(spacing: FH.Spacing.sm) {
            ForEach(Array(["Weight", "PRs", "Body", "Photos"].enumerated()), id: \.offset) { index, title in
                Button {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        selectedTab = index
                    }
                } label: {
                    Text(title)
                        .font(.system(size: 14, weight: selectedTab == index ? .semibold : .medium))
                        .foregroundStyle(selectedTab == index ? FH.Colors.primaryInk : FH.Colors.textMuted)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background(selectedTab == index ? FH.Colors.primary : FH.Colors.surface)
                        .clipShape(RoundedRectangle(cornerRadius: FH.Radius.md))
                }
            }
        }
        .padding(4)
        .background(FH.Colors.surface)
        .clipShape(RoundedRectangle(cornerRadius: FH.Radius.lg))
        .padding(.horizontal, FH.Spacing.base)
        .padding(.bottom, FH.Spacing.lg)
    }

    // MARK: - Weight Section

    private var weightSection: some View {
        VStack(spacing: FH.Spacing.xl) {
            // Summary card
            HStack(spacing: FH.Spacing.xxl) {
                statBlock(label: "Current", value: "79.8", unit: "kg")
                statBlock(label: "Start", value: "82.3", unit: "kg")
                statBlock(label: "Change", value: "-2.5", unit: "kg", highlight: true)
            }
            .fhCard()

            // Chart
            VStack(alignment: .leading, spacing: FH.Spacing.md) {
                Text("WEIGHT TREND")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(FH.Colors.textSubtle)
                    .tracking(1.2)

                Chart {
                    ForEach(weightHistory) { entry in
                        LineMark(
                            x: .value("Date", entry.date),
                            y: .value("Weight", entry.weight)
                        )
                        .foregroundStyle(FH.Colors.primary)
                        .lineStyle(StrokeStyle(lineWidth: 2.5, lineCap: .round))
                        .interpolationMethod(.catmullRom)

                        AreaMark(
                            x: .value("Date", entry.date),
                            y: .value("Weight", entry.weight)
                        )
                        .foregroundStyle(
                            LinearGradient(
                                colors: [FH.Colors.primary.opacity(0.2), FH.Colors.primary.opacity(0)],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .interpolationMethod(.catmullRom)

                        PointMark(
                            x: .value("Date", entry.date),
                            y: .value("Weight", entry.weight)
                        )
                        .foregroundStyle(FH.Colors.primary)
                        .symbolSize(24)
                    }
                }
                .chartYScale(domain: 79...83)
                .chartYAxis {
                    AxisMarks(values: .automatic(desiredCount: 4)) { value in
                        AxisValueLabel {
                            if let v = value.as(Double.self) {
                                Text("\(v, specifier: "%.0f")")
                                    .font(.system(size: 11))
                                    .foregroundStyle(FH.Colors.textSubtle)
                            }
                        }
                        AxisGridLine()
                            .foregroundStyle(FH.Colors.border)
                    }
                }
                .chartXAxis {
                    AxisMarks(values: .stride(by: .weekOfYear, count: 2)) { value in
                        AxisValueLabel(format: .dateTime.month(.abbreviated).day())
                            .font(.system(size: 10))
                            .foregroundStyle(FH.Colors.textSubtle)
                        AxisGridLine()
                            .foregroundStyle(FH.Colors.border)
                    }
                }
                .frame(height: 200)
            }
            .fhCard()

            // Log entries
            VStack(alignment: .leading, spacing: FH.Spacing.md) {
                Text("LOG")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(FH.Colors.textSubtle)
                    .tracking(1.2)

                ForEach(weightHistory.reversed()) { entry in
                    HStack {
                        Text(entry.date.formatted(.dateTime.month(.abbreviated).day()))
                            .font(.system(size: 14))
                            .foregroundStyle(FH.Colors.textMuted)
                            .frame(width: 60, alignment: .leading)
                        Spacer()
                        Text("\(entry.weight, specifier: "%.1f") kg")
                            .font(.system(size: 16, weight: .semibold, design: .rounded))
                            .foregroundStyle(FH.Colors.text)
                            .monospacedDigit()
                    }
                    .padding(.vertical, FH.Spacing.sm)
                    if entry.id != weightHistory.first?.id {
                        Divider()
                            .background(FH.Colors.border)
                    }
                }
            }
            .fhCard()
        }
    }

    private func statBlock(label: String, value: String, unit: String, highlight: Bool = false) -> some View {
        VStack(spacing: FH.Spacing.xs) {
            Text(label)
                .font(.system(size: 12))
                .foregroundStyle(FH.Colors.textSubtle)
            HStack(alignment: .firstTextBaseline, spacing: 2) {
                Text(value)
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                    .foregroundStyle(highlight ? FH.Colors.success : FH.Colors.text)
                    .monospacedDigit()
                Text(unit)
                    .font(.system(size: 13))
                    .foregroundStyle(FH.Colors.textMuted)
            }
        }
        .frame(maxWidth: .infinity)
    }

    // MARK: - PRs Section

    private var prsSection: some View {
        VStack(spacing: FH.Spacing.md) {
            ForEach(personalRecords) { pr in
                HStack(spacing: FH.Spacing.base) {
                    ZStack {
                        RoundedRectangle(cornerRadius: FH.Radius.md)
                            .fill(FH.Colors.warning.opacity(0.12))
                            .frame(width: 48, height: 48)
                        Image(systemName: "trophy.fill")
                            .font(.system(size: 20))
                            .foregroundStyle(FH.Colors.warning)
                    }

                    VStack(alignment: .leading, spacing: 3) {
                        Text(pr.exerciseName)
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundStyle(FH.Colors.text)
                        Text(pr.date.formatted(.dateTime.month(.abbreviated).day(.defaultDigits).year()))
                            .font(.system(size: 13))
                            .foregroundStyle(FH.Colors.textSubtle)
                    }

                    Spacer()

                    Text(pr.value)
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                        .foregroundStyle(FH.Colors.primary)
                        .monospacedDigit()
                }
                .fhCard()
            }
        }
    }

    // MARK: - Measurements Section

    private var measurementsSection: some View {
        VStack(spacing: FH.Spacing.md) {
            measurementRow(name: "Chest", current: "98.5", previous: "99.2", unit: "cm")
            measurementRow(name: "Waist", current: "82.0", previous: "84.5", unit: "cm")
            measurementRow(name: "Hips", current: "96.0", previous: "96.8", unit: "cm")
            measurementRow(name: "Left Arm", current: "36.5", previous: "35.8", unit: "cm")
            measurementRow(name: "Right Arm", current: "37.0", previous: "36.2", unit: "cm")
            measurementRow(name: "Left Thigh", current: "58.0", previous: "57.5", unit: "cm")
            measurementRow(name: "Right Thigh", current: "58.5", previous: "57.8", unit: "cm")
        }
    }

    // MARK: - Photos Section

    private var photosSection: some View {
        VStack(spacing: FH.Spacing.lg) {
            HStack(spacing: FH.Spacing.md) {
                photoPlaceholder(
                    label: "Start",
                    date: progressPhotos.first?.date,
                    icon: "camera",
                    color: FH.Colors.textSubtle
                )
                photoPlaceholder(
                    label: "Current",
                    date: Date(),
                    icon: "camera.fill",
                    color: FH.Colors.primary
                )
            }

            VStack(alignment: .leading, spacing: FH.Spacing.md) {
                Text("PHOTO TIMELINE")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(FH.Colors.textSubtle)
                    .tracking(1.2)

                LazyVGrid(columns: [GridItem(.adaptive(minimum: 100, maximum: 120), spacing: FH.Spacing.md)], spacing: FH.Spacing.md) {
                    ForEach(progressPhotos) { photo in
                        photoCard(photo)
                    }

                    Button {
                        showAddPhoto = true
                    } label: {
                        VStack(spacing: FH.Spacing.sm) {
                            Image(systemName: "plus")
                                .font(.system(size: 24, weight: .semibold))
                                .foregroundStyle(FH.Colors.primary)
                            Text("Add")
                                .font(.system(size: 13, weight: .medium))
                                .foregroundStyle(FH.Colors.primary)
                        }
                        .frame(height: 120)
                        .frame(maxWidth: .infinity)
                        .background(FH.Colors.surface)
                        .clipShape(RoundedRectangle(cornerRadius: FH.Radius.md))
                        .overlay(
                            RoundedRectangle(cornerRadius: FH.Radius.md)
                                .stroke(FH.Colors.primary.opacity(0.3), style: StrokeStyle(lineWidth: 1, dash: [6, 4]))
                        )
                    }
                }
            }
            .fhCard()
        }
    }

    private func photoPlaceholder(label: String, date: Date?, icon: String, color: Color) -> some View {
        VStack(spacing: FH.Spacing.sm) {
            ZStack {
                RoundedRectangle(cornerRadius: FH.Radius.md)
                    .fill(color.opacity(0.12))
                    .frame(height: 140)
                VStack(spacing: FH.Spacing.xs) {
                    Image(systemName: icon)
                        .font(.system(size: 32))
                        .foregroundStyle(color)
                    Text(label)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(color)
                }
            }
            if let date = date {
                Text(date.formatted(.dateTime.month(.abbreviated).day().year(.twoDigits)))
                    .font(.system(size: 12))
                    .foregroundStyle(FH.Colors.textMuted)
            }
        }
        .frame(maxWidth: .infinity)
    }

    private func photoCard(_ photo: ProgressPhoto) -> some View {
        VStack(spacing: FH.Spacing.xs) {
            ZStack {
                RoundedRectangle(cornerRadius: FH.Radius.md)
                    .fill(photoColor(photo.colorName).opacity(0.15))
                    .frame(height: 120)
                Image(systemName: photo.sfSymbol)
                    .font(.system(size: 28))
                    .foregroundStyle(photoColor(photo.colorName))
            }
            Text(photo.label)
                .font(.system(size: 13, weight: .semibold))
                .foregroundStyle(FH.Colors.text)
            Text(photo.date.formatted(.dateTime.month(.abbreviated).day()))
                .font(.system(size: 11))
                .foregroundStyle(FH.Colors.textMuted)
        }
        .frame(maxWidth: .infinity)
    }

    private func photoColor(_ name: String) -> Color {
        switch name {
        case "accent": return FH.Colors.accent
        case "primary": return FH.Colors.primary
        case "warning": return FH.Colors.warning
        case "success": return FH.Colors.success
        default: return FH.Colors.primary
        }
    }

    private func measurementRow(name: String, current: String, previous: String, unit: String) -> some View {
        let curr = Double(current) ?? 0
        let prev = Double(previous) ?? 0
        let diff = curr - prev
        let diffStr = String(format: "%+.1f", diff)

        return HStack {
            Text(name)
                .font(.system(size: 15, weight: .medium))
                .foregroundStyle(FH.Colors.text)

            Spacer()

            Text("\(current) \(unit)")
                .font(.system(size: 16, weight: .semibold, design: .rounded))
                .foregroundStyle(FH.Colors.text)
                .monospacedDigit()

            Text(diffStr)
                .font(.system(size: 13, weight: .medium, design: .rounded))
                .foregroundStyle(diff < 0 ? FH.Colors.success : (diff > 0 ? FH.Colors.warning : FH.Colors.textSubtle))
                .frame(width: 50, alignment: .trailing)
                .monospacedDigit()
        }
        .fhCard()
    }
}

struct AddPhotoSheet: View {
    @Environment(\.dismiss) private var dismiss
    @State private var selectedLabel = "Progress"
    let labels = ["Progress", "Front", "Back", "Side", "Flexed"]

    var body: some View {
        NavigationStack {
            ZStack {
                FH.Colors.bg.ignoresSafeArea()

                VStack(spacing: FH.Spacing.xl) {
                    ZStack {
                        RoundedRectangle(cornerRadius: FH.Radius.lg)
                            .fill(FH.Colors.surface)
                            .frame(height: 300)
                        VStack(spacing: FH.Spacing.md) {
                            Image(systemName: "camera.fill")
                                .font(.system(size: 48))
                                .foregroundStyle(FH.Colors.primary)
                            Text("Take or select a photo")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundStyle(FH.Colors.textMuted)
                        }
                    }
                    .overlay(
                        RoundedRectangle(cornerRadius: FH.Radius.lg)
                            .stroke(FH.Colors.primary.opacity(0.3), style: StrokeStyle(lineWidth: 1, dash: [8, 6]))
                    )

                    VStack(alignment: .leading, spacing: FH.Spacing.md) {
                        Text("PHOTO LABEL")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundStyle(FH.Colors.textSubtle)
                            .tracking(1.2)

                        HStack(spacing: FH.Spacing.sm) {
                            ForEach(labels, id: \.self) { label in
                                Button {
                                    selectedLabel = label
                                } label: {
                                    Text(label)
                                        .font(.system(size: 14, weight: selectedLabel == label ? .semibold : .medium))
                                        .foregroundStyle(selectedLabel == label ? FH.Colors.primaryInk : FH.Colors.textMuted)
                                        .padding(.horizontal, 14)
                                        .padding(.vertical, 8)
                                        .background(selectedLabel == label ? FH.Colors.primary : FH.Colors.surface)
                                        .clipShape(Capsule())
                                }
                            }
                        }
                    }

                    Spacer()

                    Button {
                        dismiss()
                    } label: {
                        Text("Save Photo")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundStyle(FH.Colors.primaryInk)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(FH.Colors.primary)
                            .clipShape(RoundedRectangle(cornerRadius: FH.Radius.md))
                    }
                }
                .padding(FH.Spacing.base)
            }
            .navigationTitle("Add Progress Photo")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button { dismiss() } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 24))
                            .foregroundStyle(FH.Colors.textSubtle)
                    }
                }
            }
        }
    }
}

#Preview {
    ClientProgressView()
        .preferredColorScheme(.dark)
}
