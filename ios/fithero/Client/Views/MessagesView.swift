import SwiftUI
import PhotosUI

struct MessagesView: View {
    let partnerName: String
    let partnerInitial: String
    let isTrainerContext: Bool
    var onBack: (() -> Void)? = nil

    @State private var messages: [ChatMessage]
    @State private var inputText = ""
    @State private var showVideoCallAlert = false
    @State private var showPhotoPicker = false
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var showImagePreview = false
    @State private var previewStartIndex = 0
    @FocusState private var isInputFocused: Bool

    private var imageMessages: [ChatMessage] {
        messages.filter { $0.imageData != nil }
    }

    init(partnerName: String? = nil, partnerInitial: String? = nil, isTrainerContext: Bool = false, onBack: (() -> Void)? = nil) {
        self.partnerName = partnerName ?? SampleData.trainerName
        self.partnerInitial = partnerInitial ?? SampleData.trainerAvatar
        self.isTrainerContext = isTrainerContext
        self.onBack = onBack
        _messages = State(initialValue: SampleData.messages)
    }

    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                chatHeader
                Divider().background(FH.Colors.border)
                chatBody
                Divider().background(FH.Colors.border)
                inputBar
            }
            .background(FH.Colors.bg)

            if showImagePreview {
                ChatImageGallery(
                    imageMessages: imageMessages,
                    startIndex: previewStartIndex,
                    onDismiss: { showImagePreview = false }
                )
                .ignoresSafeArea()
                .transition(.opacity)
            }
        }
        .alert("Video Call", isPresented: $showVideoCallAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("Starting video call with \(partnerName)...")
        }
        .photosPicker(isPresented: $showPhotoPicker, selection: $selectedPhoto, matching: .images)
        .onChange(of: selectedPhoto) { _, newItem in
            guard let newItem else { return }
            Task { await loadAndSendImage(from: newItem) }
        }
    }

    // MARK: - Header

    private var chatHeader: some View {
        HStack(spacing: FH.Spacing.md) {
            if let onBack = onBack {
                Button {
                    FHHaptics.light()
                    onBack()
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundStyle(FH.Colors.text)
                        .frame(width: 36, height: 36)
                }
            }

            ZStack {
                Circle()
                    .fill(FH.Colors.accent.opacity(0.15))
                    .frame(width: 40, height: 40)
                Text(partnerInitial)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(FH.Colors.accent)
            }

            VStack(alignment: .leading, spacing: 2) {
                Text(partnerName)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(FH.Colors.text)
                HStack(spacing: 4) {
                    Circle()
                        .fill(FH.Colors.success)
                        .frame(width: 7, height: 7)
                    Text("Online")
                        .font(.system(size: 12))
                        .foregroundStyle(FH.Colors.success)
                }
            }

            Spacer()

            Button {
                FHHaptics.light()
                showVideoCallAlert = true
            } label: {
                Image(systemName: "video.fill")
                    .font(.system(size: 16))
                    .foregroundStyle(FH.Colors.textMuted)
                    .frame(width: 40, height: 40)
                    .background(FH.Colors.surface2)
                    .clipShape(Circle())
            }
        }
        .padding(.horizontal, FH.Spacing.base)
        .padding(.vertical, FH.Spacing.md)
    }

    // MARK: - Chat Body

    private var chatBody: some View {
        ScrollViewReader { proxy in
            ScrollView {
                LazyVStack(spacing: FH.Spacing.md) {
                    Text("Today")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundStyle(FH.Colors.textSubtle)
                        .padding(.vertical, FH.Spacing.sm)
                        .id("top")

                    ForEach(messages) { message in
                        messageBubble(message)
                            .id(message.id)
                    }

                    Color.clear
                        .frame(height: 1)
                        .id("bottom")
                }
                .padding(.horizontal, FH.Spacing.base)
                .padding(.vertical, FH.Spacing.base)
            }
            .onChange(of: messages.count) { _, _ in
                scrollToBottom(proxy: proxy)
            }
            .onAppear {
                scrollToBottom(proxy: proxy)
            }
        }
    }

    private func scrollToBottom(proxy: ScrollViewProxy) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
            withAnimation(.easeOut(duration: 0.25)) {
                proxy.scrollTo("bottom", anchor: .bottom)
            }
        }
    }

    // MARK: - Message Bubble

    private func messageBubble(_ message: ChatMessage) -> some View {
        let isTrainer = message.isFromTrainer
        let alignment: HorizontalAlignment = isTrainer ? .leading : .trailing

        return VStack(alignment: alignment, spacing: FH.Spacing.xs) {
            HStack {
                if !isTrainer { Spacer(minLength: 40) }

                VStack(alignment: isTrainer ? .leading : .trailing, spacing: 4) {
                    if let imageData = message.imageData, let uiImage = UIImage(data: imageData) {
                        chatImageBubble(uiImage: uiImage, message: message)
                    } else {
                        Text(message.text)
                            .font(.system(size: 15))
                            .foregroundStyle(isTrainer ? FH.Colors.text : FH.Colors.primaryInk)
                            .padding(.horizontal, FH.Spacing.md)
                            .padding(.vertical, FH.Spacing.md)
                            .background(isTrainer ? FH.Colors.surface : FH.Colors.primary)
                            .clipShape(RoundedRectangle(cornerRadius: FH.Radius.lg))
                    }

                    Text(message.timestamp.formatted(.dateTime.hour().minute()))
                        .font(.system(size: 11))
                        .foregroundStyle(FH.Colors.textSubtle)
                }

                if isTrainer { Spacer(minLength: 40) }
            }
        }
    }

    private func chatImageBubble(uiImage: UIImage, message: ChatMessage) -> some View {
        Image(uiImage: uiImage)
            .resizable()
            .scaledToFill()
            .frame(width: 200, height: 260)
            .clipShape(RoundedRectangle(cornerRadius: FH.Radius.lg))
            .overlay(
                RoundedRectangle(cornerRadius: FH.Radius.lg)
                    .stroke(FH.Colors.border, lineWidth: 1)
            )
            .contentShape(RoundedRectangle(cornerRadius: FH.Radius.lg))
            .onTapGesture {
                FHHaptics.medium()
                if let index = imageMessages.firstIndex(where: { $0.id == message.id }) {
                    previewStartIndex = index
                    showImagePreview = true
                }
            }
    }

    // MARK: - Input Bar

    private var inputBar: some View {
        HStack(spacing: FH.Spacing.md) {
            Button {
                FHHaptics.light()
                showPhotoPicker = true
            } label: {
                Image(systemName: "photo")
                    .font(.system(size: 18))
                    .foregroundStyle(FH.Colors.textMuted)
            }

            HStack {
                TextField("Message", text: $inputText)
                    .font(.system(size: 15))
                    .foregroundStyle(FH.Colors.text)
                    .padding(.horizontal, FH.Spacing.md)
                    .padding(.vertical, FH.Spacing.md)
                    .focused($isInputFocused)
            }
            .background(FH.Colors.surface)
            .clipShape(RoundedRectangle(cornerRadius: FH.Radius.pill))
            .overlay(
                RoundedRectangle(cornerRadius: FH.Radius.pill)
                    .stroke(FH.Colors.border, lineWidth: 1)
            )

            Button {
                sendMessage()
            } label: {
                Image(systemName: "arrow.up.circle.fill")
                    .font(.system(size: 32))
                    .foregroundStyle(inputText.isEmpty ? FH.Colors.textSubtle : FH.Colors.primary)
            }
            .disabled(inputText.isEmpty)
        }
        .padding(.horizontal, FH.Spacing.base)
        .padding(.vertical, FH.Spacing.md)
    }

    // MARK: - Actions

    private func sendMessage() {
        guard !inputText.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        FHHaptics.medium()

        let newMessage = ChatMessage(
            senderName: isTrainerContext ? partnerName : SampleData.clientName,
            isFromTrainer: isTrainerContext,
            text: inputText.trimmingCharacters(in: .whitespaces),
            timestamp: Date()
        )

        withAnimation(.easeOut(duration: 0.2)) {
            messages.append(newMessage)
            inputText = ""
        }
    }

    private func loadAndSendImage(from item: PhotosPickerItem) async {
        guard let data = try? await item.loadTransferable(type: Data.self),
              let image = UIImage(data: data),
              let jpegData = image.jpegData(compressionQuality: 0.85) else { return }

        await MainActor.run {
            FHHaptics.medium()
            let newMessage = ChatMessage(
                senderName: isTrainerContext ? partnerName : SampleData.clientName,
                isFromTrainer: isTrainerContext,
                text: "",
                timestamp: Date(),
                isImageAttachment: true,
                imageData: jpegData
            )

            withAnimation(.easeOut(duration: 0.2)) {
                messages.append(newMessage)
                selectedPhoto = nil
            }
        }
    }
}

// MARK: - Full-Screen Image Gallery (UIKit-backed)

struct ChatImageGallery: View {
    let imageMessages: [ChatMessage]
    let startIndex: Int
    let onDismiss: () -> Void

    var body: some View {
        ZStack {
            ImageGalleryUIView(
                images: imageMessages.compactMap { $0.imageData.flatMap(UIImage.init) },
                startIndex: startIndex,
                onDismiss: onDismiss
            )
            .ignoresSafeArea()

            VStack {
                HStack {
                    Spacer()
                    Button {
                        onDismiss()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 28))
                            .foregroundStyle(.white.opacity(0.8))
                    }
                }
                .padding(.horizontal, FH.Spacing.base)
                .padding(.top, FH.Spacing.lg)

                Spacer()
            }
        }
    }
}

// MARK: - UIViewRepresentable Gallery

struct ImageGalleryUIView: UIViewRepresentable {
    let images: [UIImage]
    let startIndex: Int
    let onDismiss: () -> Void

    func makeUIView(context: Context) -> UIScrollView {
        let scrollView = UIScrollView()
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.backgroundColor = .black
        scrollView.delegate = context.coordinator
        context.coordinator.hostScrollView = scrollView

        // Vertical pan for dismiss
        let pan = UIPanGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handleVerticalPan(_:)))
        pan.delegate = context.coordinator
        scrollView.addGestureRecognizer(pan)
        context.coordinator.dismissPan = pan

        for (i, image) in images.enumerated() {
            let page = ZoomingImagePage(image: image, tag: i)
            page.scrollView.delegate = context.coordinator
            scrollView.addSubview(page)
            context.coordinator.pages[i] = page
        }

        return scrollView
    }

    func updateUIView(_ scrollView: UIScrollView, context: Context) {
        let w = scrollView.bounds.width
        let h = scrollView.bounds.height
        guard w > 0, h > 0 else { return }

        for (i, page) in context.coordinator.pages.sorted(by: { $0.key < $1.key }) {
            page.frame = CGRect(x: CGFloat(i) * w, y: 0, width: w, height: h)
            page.layoutImageView()
        }

        scrollView.contentSize = CGSize(width: w * CGFloat(images.count), height: h)
        scrollView.contentOffset = CGPoint(x: CGFloat(startIndex) * w, y: 0)
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UIScrollViewDelegate, UIGestureRecognizerDelegate {
        let parent: ImageGalleryUIView
        weak var hostScrollView: UIScrollView?
        fileprivate var pages: [Int: ZoomingImagePage] = [:]
        weak var dismissPan: UIPanGestureRecognizer?

        private var dismissStartY: CGFloat = 0
        private var currentDismissOffset: CGFloat = 0

        init(_ parent: ImageGalleryUIView) {
            self.parent = parent
        }

        func viewForZooming(in scrollView: UIScrollView) -> UIView? {
            if let page = pages[scrollView.tag] {
                return page.imageView
            }
            return nil
        }

        func scrollViewDidZoom(_ scrollView: UIScrollView) {
            if let page = pages[scrollView.tag] {
                page.centerImage()
            }
        }

        func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
            // Allow vertical pan to work alongside scroll view
            if gestureRecognizer == dismissPan {
                return true
            }
            return false
        }

        func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
            guard gestureRecognizer == dismissPan,
                  let pan = gestureRecognizer as? UIPanGestureRecognizer,
                  let host = hostScrollView else { return true }

            let translation = pan.translation(in: host)
            let velocity = pan.velocity(in: host)

            // Only start vertical dismiss if:
            // 1. Movement is more vertical than horizontal
            // 2. Current page is not zoomed
            let currentPageIndex = Int(round(host.contentOffset.x / host.bounds.width))
            let isZoomed = pages[currentPageIndex]?.scrollView.zoomScale ?? 1.0 > 1.05

            return !isZoomed && abs(translation.y) > abs(translation.x) && abs(velocity.y) > abs(velocity.x)
        }

        @objc func handleVerticalPan(_ pan: UIPanGestureRecognizer) {
            guard let host = hostScrollView else { return }
            let translation = pan.translation(in: host)

            switch pan.state {
            case .began:
                dismissStartY = host.transform.ty
                currentDismissOffset = 0

            case .changed:
                currentDismissOffset = translation.y
                let progress = min(abs(currentDismissOffset) / (host.bounds.height * 0.4), 1.0)

                host.transform = CGAffineTransform(translationX: 0, y: currentDismissOffset * 0.6)
                host.alpha = 1.0 - progress * 0.5
                for page in pages.values {
                    page.scrollView.alpha = 1.0 - progress * 0.3
                }

            case .ended, .cancelled:
                let velocity = pan.velocity(in: host)
                let shouldDismiss = abs(currentDismissOffset) > 120 || (abs(currentDismissOffset) > 40 && abs(velocity.y) > 800)

                if shouldDismiss {
                    UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseOut, animations: {
                        host.transform = CGAffineTransform(translationX: 0, y: host.bounds.height * (self.currentDismissOffset > 0 ? 1 : -1))
                        host.alpha = 0
                    }) { _ in
                        self.parent.onDismiss()
                    }
                } else {
                    UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseOut, animations: {
                        host.transform = .identity
                        host.alpha = 1
                        for page in self.pages.values {
                            page.scrollView.alpha = 1
                        }
                    })
                }

            default:
                break
            }
        }
    }
}

// MARK: - Zooming Image Page

private class ZoomingImagePage: UIView {
    let scrollView = UIScrollView()
    let imageView = UIImageView()

    init(image: UIImage, tag: Int) {
        super.init(frame: .zero)
        self.tag = tag
        scrollView.tag = tag
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 4.0
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.decelerationRate = .fast
        scrollView.backgroundColor = .clear

        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true

        scrollView.addSubview(imageView)
        addSubview(scrollView)

        // Double-tap to zoom
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap(_:)))
        doubleTap.numberOfTapsRequired = 2
        imageView.addGestureRecognizer(doubleTap)
    }

    required init?(coder: NSCoder) { fatalError() }

    func layoutImageView() {
        scrollView.frame = bounds
        imageView.frame = bounds
        scrollView.contentSize = bounds.size
        centerImage()
    }

    func centerImage() {
        let offsetX = max((scrollView.bounds.width - scrollView.contentSize.width) * 0.5, 0)
        let offsetY = max((scrollView.bounds.height - scrollView.contentSize.height) * 0.5, 0)
        imageView.center = CGPoint(
            x: scrollView.contentSize.width * 0.5 + offsetX,
            y: scrollView.contentSize.height * 0.5 + offsetY
        )
    }

    @objc private func handleDoubleTap(_ gesture: UITapGestureRecognizer) {
        if scrollView.zoomScale > 1.05 {
            scrollView.setZoomScale(1.0, animated: true)
        } else {
            let point = gesture.location(in: imageView)
            let rect = zoomRect(for: point, scale: 2.5)
            scrollView.zoom(to: rect, animated: true)
        }
    }

    private func zoomRect(for point: CGPoint, scale: CGFloat) -> CGRect {
        let size = CGSize(width: scrollView.bounds.width / scale, height: scrollView.bounds.height / scale)
        let origin = CGPoint(x: point.x - size.width / 2, y: point.y - size.height / 2)
        return CGRect(origin: origin, size: size)
    }
}

#Preview {
    MessagesView()
        .preferredColorScheme(.dark)
}
