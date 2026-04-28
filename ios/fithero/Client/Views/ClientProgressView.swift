import SwiftUI
import Charts
import PhotosUI

struct ClientProgressView: View {
    @State private var selectedTab = 0
    @State private var showAddPhoto = false
    @State private var showSubmitCheckIn = false
    @State private var showPhotoViewer = false
    @State private var viewerSelectedIndex = 0
    @State private var selectedExercise: Exercise? = nil
    @State private var photos: [ProgressPhoto] = SampleData.progressPhotos
    let weightHistory = SampleData.weightHistory
    let personalRecords = SampleData.personalRecords

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
                    case 4: checkInsSection
                    default: EmptyView()
                    }
                }
                .padding(.horizontal, FH.Spacing.base)
                .padding(.bottom, FH.Spacing.xxxl)
            }
        }
        .background(FH.Colors.bg)
        .sheet(isPresented: $showAddPhoto) {
            AddPhotoSheet(onPhotoSelected: { photo in
                photos.append(photo)
            })
        }
        .sheet(isPresented: $showPhotoViewer) {
            PhotoViewer(photos: photos, selectedIndex: $viewerSelectedIndex)
        }
        .sheet(item: $selectedExercise) { exercise in
            ExerciseDetailView(exercise: exercise)
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
            ForEach(Array(["Weight", "PRs", "Body", "Photos", "Check-Ins"].enumerated()), id: \.offset) { index, title in
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
                let matchingExercise = SampleData.exerciseLibrary.first { $0.name == pr.exerciseName }
                Button {
                    FHHaptics.selection()
                    if let ex = matchingExercise {
                        selectedExercise = ex
                    }
                } label: {
                    HStack(spacing: FH.Spacing.base) {
                        ZStack {
                            RoundedRectangle(cornerRadius: FH.Radius.md)
                                .fill(FH.Colors.warning.opacity(0.12))
                                .frame(width: 48, height: 48)
                            Image(systemName: matchingExercise?.sfSymbol ?? "trophy.fill")
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

                        Image(systemName: "chevron.right")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundStyle(FH.Colors.textSubtle)
                    }
                    .fhCard()
                }
                .buttonStyle(.plain)
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
        VStack(spacing: FH.Spacing.xl) {
            // Header with Add button
            HStack {
                Text("PROGRESS PHOTOS")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(FH.Colors.textSubtle)
                    .tracking(1.2)

                Spacer()

                Button {
                    FHHaptics.medium()
                    showAddPhoto = true
                } label: {
                    HStack(spacing: 4) {
                        Image(systemName: "plus")
                            .font(.system(size: 14, weight: .semibold))
                        Text("Add")
                            .font(.system(size: 14, weight: .semibold))
                    }
                    .foregroundStyle(FH.Colors.primaryInk)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(FH.Colors.primary)
                    .clipShape(Capsule())
                }
            }

            // Grouped by week
            VStack(spacing: FH.Spacing.xl) {
                ForEach(groupedPhotos, id: \.week) { group in
                    weekPhotoGroup(group)
                }
            }
        }
    }

    private var groupedPhotos: [(week: String, dateRange: String, photos: [ProgressPhoto])] {
        let cal = Calendar.current
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"

        // Group by week of year
        var groups: [Int: [ProgressPhoto]] = [:]
        for photo in photos {
            let week = cal.component(.weekOfYear, from: photo.date)
            groups[week, default: []].append(photo)
        }

        return groups.sorted { $0.key > $1.key }.map { week, photos in
            let sorted = photos.sorted { $0.date < $1.date }
            let first = sorted.first?.date ?? Date()
            let last = sorted.last?.date ?? Date()
            let range = first == last ? formatter.string(from: first) : "\(formatter.string(from: first)) – \(formatter.string(from: last))"
            let label = sorted.first?.label ?? "Week \(week)"
            return (week: label, dateRange: range, photos: sorted)
        }
    }

    private func weekPhotoGroup(_ group: (week: String, dateRange: String, photos: [ProgressPhoto])) -> some View {
        VStack(alignment: .leading, spacing: FH.Spacing.md) {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text(group.week)
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(FH.Colors.text)
                    Text(group.dateRange)
                        .font(.system(size: 12))
                        .foregroundStyle(FH.Colors.textMuted)
                }
                Spacer()
                Text("\(group.photos.count) photo\(group.photos.count == 1 ? "" : "s")")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundStyle(FH.Colors.textSubtle)
            }

            LazyVGrid(columns: [
                GridItem(.flexible(), spacing: FH.Spacing.sm),
                GridItem(.flexible(), spacing: FH.Spacing.sm),
                GridItem(.flexible(), spacing: FH.Spacing.sm)
            ], spacing: FH.Spacing.sm) {
                ForEach(group.photos) { photo in
                    Button {
                        FHHaptics.medium()
                        if let index = photos.firstIndex(where: { $0.id == photo.id }) {
                            viewerSelectedIndex = index
                            showPhotoViewer = true
                        }
                    } label: {
                        photoCard(photo)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .padding(FH.Spacing.base)
        .background(FH.Colors.surface)
        .clipShape(RoundedRectangle(cornerRadius: FH.Radius.lg))
        .overlay(
            RoundedRectangle(cornerRadius: FH.Radius.lg)
                .stroke(FH.Colors.border, lineWidth: 1)
        )
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

    // MARK: - Check-Ins Section

    private var checkInsSection: some View {
        VStack(spacing: FH.Spacing.xl) {
            // Week header
            HStack(spacing: FH.Spacing.md) {
                weekColumn(label: "Previous", week: "Week 7", date: "Mar 24")
                Divider().background(FH.Colors.border)
                weekColumn(label: "Current", week: "Week 8", date: "Mar 31", isCurrent: true)
            }
            .fhCard()

            // Weight comparison
            VStack(alignment: .leading, spacing: FH.Spacing.md) {
                Text("WEIGHT")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(FH.Colors.textSubtle)
                    .tracking(1.2)

                HStack(spacing: FH.Spacing.md) {
                    checkInValueColumn(value: "80.2", unit: "kg", label: "Previous")
                    Spacer()
                    Image(systemName: "arrow.right")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(FH.Colors.textSubtle)
                    Spacer()
                    checkInValueColumn(value: "79.8", unit: "kg", label: "Current", highlight: true)
                }

                HStack(spacing: FH.Spacing.sm) {
                    Image(systemName: "arrow.down")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundStyle(FH.Colors.success)
                    Text("0.4 kg")
                        .font(.system(size: 14, weight: .semibold, design: .rounded))
                        .foregroundStyle(FH.Colors.success)
                    Text("— on track for your goal")
                        .font(.system(size: 14))
                        .foregroundStyle(FH.Colors.textMuted)
                }
            }
            .fhCard()

            // Measurements comparison
            VStack(alignment: .leading, spacing: FH.Spacing.md) {
                Text("MEASUREMENTS")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(FH.Colors.textSubtle)
                    .tracking(1.2)

                VStack(spacing: FH.Spacing.sm) {
                    checkInMeasurementRow(name: "Chest", prev: "99.2", curr: "98.5", unit: "cm", lowerIsBetter: true)
                    checkInMeasurementRow(name: "Waist", prev: "84.5", curr: "82.0", unit: "cm", lowerIsBetter: true)
                    checkInMeasurementRow(name: "Hips", prev: "96.8", curr: "96.0", unit: "cm", lowerIsBetter: true)
                    checkInMeasurementRow(name: "Left Arm", prev: "35.8", curr: "36.5", unit: "cm", lowerIsBetter: false)
                    checkInMeasurementRow(name: "Right Arm", prev: "36.2", curr: "37.0", unit: "cm", lowerIsBetter: false)
                    checkInMeasurementRow(name: "Left Thigh", prev: "57.5", curr: "58.0", unit: "cm", lowerIsBetter: false)
                    checkInMeasurementRow(name: "Right Thigh", prev: "57.8", curr: "58.5", unit: "cm", lowerIsBetter: false)
                }
            }
            .fhCard()

            // Photos comparison
            VStack(alignment: .leading, spacing: FH.Spacing.md) {
                Text("PHOTOS")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(FH.Colors.textSubtle)
                    .tracking(1.2)

                HStack(spacing: FH.Spacing.md) {
                    photoPlaceholder(label: "Week 7", date: Calendar.current.date(byAdding: .day, value: -7, to: Date()), icon: "camera", color: FH.Colors.textSubtle)
                    photoPlaceholder(label: "Week 8", date: Date(), icon: "camera.fill", color: FH.Colors.primary)
                }
            }
            .fhCard()

            // Submit CTA
            Button {
                showSubmitCheckIn = true
            } label: {
                Text("Submit Check-In")
            }
            .buttonStyle(FHPrimaryButtonStyle())
            .padding(.top, FH.Spacing.md)
        }
        .alert("Check-In Submitted", isPresented: $showSubmitCheckIn) {
            Button("Great!", role: .cancel) { }
        } message: {
            Text("Your coach will review your progress and get back to you.")
        }
    }

    private func weekColumn(label: String, week: String, date: String, isCurrent: Bool = false) -> some View {
        VStack(spacing: FH.Spacing.sm) {
            Text(label)
                .font(.system(size: 11, weight: .semibold))
                .foregroundStyle(isCurrent ? FH.Colors.primary : FH.Colors.textSubtle)
                .tracking(1)
            Text(week)
                .font(.system(size: 18, weight: .bold))
                .foregroundStyle(FH.Colors.text)
            Text(date)
                .font(.system(size: 13))
                .foregroundStyle(FH.Colors.textMuted)
        }
        .frame(maxWidth: .infinity)
    }

    private func checkInValueColumn(value: String, unit: String, label: String, highlight: Bool = false) -> some View {
        VStack(spacing: FH.Spacing.xs) {
            HStack(alignment: .firstTextBaseline, spacing: 2) {
                Text(value)
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                    .foregroundStyle(highlight ? FH.Colors.primary : FH.Colors.text)
                    .monospacedDigit()
                Text(unit)
                    .font(.system(size: 13))
                    .foregroundStyle(FH.Colors.textMuted)
            }
            Text(label)
                .font(.system(size: 12))
                .foregroundStyle(FH.Colors.textSubtle)
        }
    }

    private func checkInMeasurementRow(name: String, prev: String, curr: String, unit: String, lowerIsBetter: Bool) -> some View {
        let previous = Double(prev) ?? 0
        let current = Double(curr) ?? 0
        let diff = current - previous
        let diffStr = String(format: "%+.1f", diff)

        let isImprovement: Bool = lowerIsBetter ? diff < 0 : diff > 0
        let deltaColor: Color = diff == 0 ? FH.Colors.textSubtle : (isImprovement ? FH.Colors.success : FH.Colors.danger)
        let arrow = diff < 0 ? "arrow.down" : (diff > 0 ? "arrow.up" : "minus")

        return HStack {
            Text(name)
                .font(.system(size: 15, weight: .medium))
                .foregroundStyle(FH.Colors.text)
                .frame(width: 80, alignment: .leading)

            Spacer()

            Text("\(prev) → \(curr) \(unit)")
                .font(.system(size: 15, weight: .semibold, design: .rounded))
                .foregroundStyle(FH.Colors.text)
                .monospacedDigit()

            HStack(spacing: 2) {
                Image(systemName: arrow)
                    .font(.system(size: 10, weight: .bold))
                Text(diffStr)
                    .font(.system(size: 13, weight: .semibold, design: .rounded))
            }
            .foregroundStyle(deltaColor)
            .frame(width: 60, alignment: .trailing)
            .monospacedDigit()
        }
        .padding(FH.Spacing.md)
        .background(FH.Colors.surface)
        .clipShape(RoundedRectangle(cornerRadius: FH.Radius.lg))
        .overlay(
            RoundedRectangle(cornerRadius: FH.Radius.lg)
                .stroke(FH.Colors.border, lineWidth: 1)
        )
    }
}

struct PhotoViewer: View {
    let photos: [ProgressPhoto]
    @Binding var selectedIndex: Int
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            FH.Colors.bg.ignoresSafeArea()

            TabView(selection: $selectedIndex) {
                ForEach(Array(photos.enumerated()), id: \.element.id) { index, photo in
                    VStack(spacing: FH.Spacing.lg) {
                        Spacer()

                        ZStack {
                            RoundedRectangle(cornerRadius: FH.Radius.xl)
                                .fill(photoColor(photo.colorName).opacity(0.15))
                            Image(systemName: photo.sfSymbol)
                                .font(.system(size: 80))
                                .foregroundStyle(photoColor(photo.colorName))
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 400)
                        .padding(.horizontal, FH.Spacing.base)

                        VStack(spacing: FH.Spacing.sm) {
                            Text(photo.label)
                                .font(.system(size: 22, weight: .bold))
                                .foregroundStyle(FH.Colors.text)
                            Text(photo.date.formatted(.dateTime.weekday(.wide).month(.wide).day().year()))
                                .font(.system(size: 15))
                                .foregroundStyle(FH.Colors.textMuted)
                        }

                        Spacer()
                    }
                    .tag(index)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .always))
            .indexViewStyle(.page(backgroundDisplayMode: .always))

            VStack {
                HStack {
                    Spacer()
                    Button {
                        FHHaptics.light()
                        dismiss()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 28))
                            .foregroundStyle(FH.Colors.textSubtle)
                    }
                }
                .padding(.horizontal, FH.Spacing.base)
                .padding(.top, FH.Spacing.lg)

                Spacer()
            }
        }
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
}

struct AddPhotoSheet: View {
    @Environment(\.dismiss) private var dismiss
    @State private var selectedLabel = "Progress"
    @State private var showPhotoPicker = false
    @State private var selectedPhotoItem: PhotosPickerItem?
    let labels = ["Progress", "Front", "Back", "Side", "Flexed"]
    let onPhotoSelected: ((ProgressPhoto) -> Void)?

    var body: some View {
        NavigationStack {
            ZStack {
                FH.Colors.bg.ignoresSafeArea()

                VStack(spacing: FH.Spacing.xl) {
                    Button {
                        FHHaptics.medium()
                        showPhotoPicker = true
                    } label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: FH.Radius.lg)
                                .fill(FH.Colors.surface)
                                .frame(height: 300)
                            VStack(spacing: FH.Spacing.md) {
                                Image(systemName: "camera.fill")
                                    .font(.system(size: 48))
                                    .foregroundStyle(FH.Colors.primary)
                                Text("Tap to select a photo")
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundStyle(FH.Colors.textMuted)
                            }
                        }
                        .overlay(
                            RoundedRectangle(cornerRadius: FH.Radius.lg)
                                .stroke(FH.Colors.primary.opacity(0.3), style: StrokeStyle(lineWidth: 1, dash: [8, 6]))
                        )
                    }
                    .buttonStyle(.plain)

                    VStack(alignment: .leading, spacing: FH.Spacing.md) {
                        Text("PHOTO LABEL")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundStyle(FH.Colors.textSubtle)
                            .tracking(1.2)

                        HStack(spacing: FH.Spacing.sm) {
                            ForEach(labels, id: \.self) { label in
                                Button {
                                    FHHaptics.selection()
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
                        FHHaptics.success()
                        let newPhoto = ProgressPhoto(
                            date: Date(),
                            label: selectedLabel,
                            sfSymbol: "figure.strengthtraining.traditional",
                            colorName: "primary"
                        )
                        onPhotoSelected?(newPhoto)
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
            .photosPicker(isPresented: $showPhotoPicker, selection: $selectedPhotoItem, matching: .images)
        }
    }
}

#Preview {
    ClientProgressView()
        .preferredColorScheme(.dark)
}
