import SwiftUI

// MARK: - Sign in with Apple

struct SignInWithAppleButton: View {
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                Spacer()

                HStack(spacing: FH.Spacing.md) {
                    Image(systemName: "apple.logo")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundStyle(.black)

                    Text("Continue with Apple")
                        .font(.system(size: 17, weight: .medium))
                        .foregroundStyle(.black)
                }

                Spacer()
            }
            .frame(height: 44)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 8))
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Sign in with Google

struct SignInWithGoogleButton: View {
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                Spacer()

                HStack(spacing: FH.Spacing.md) {
                    GoogleGLogo()
                        .frame(width: 18, height: 18)

                    Text("Sign in with Google")
                        .font(.system(size: 17, weight: .medium))
                        .foregroundStyle(Color(hex: 0x3C4043))
                }

                Spacer()
            }
            .frame(height: 44)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 8))
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Google G Logo

private struct GoogleGLogo: View {
    var body: some View {
        Canvas { context, size in
            let center = CGPoint(x: size.width / 2, y: size.height / 2)
            let radius = min(size.width, size.height) / 2 - 1
            let lineWidth: CGFloat = 2.5

            // Blue arc (top-right quadrant extending)
            var bluePath = Path()
            bluePath.addArc(
                center: center,
                radius: radius,
                startAngle: .degrees(0),
                endAngle: .degrees(90),
                clockwise: false
            )
            context.stroke(bluePath, with: .color(Color(hex: 0x4285F4)), lineWidth: lineWidth)

            // Red arc (right-bottom)
            var redPath = Path()
            redPath.addArc(
                center: center,
                radius: radius,
                startAngle: .degrees(90),
                endAngle: .degrees(180),
                clockwise: false
            )
            context.stroke(redPath, with: .color(Color(hex: 0xEA4335)), lineWidth: lineWidth)

            // Yellow arc (bottom-left)
            var yellowPath = Path()
            yellowPath.addArc(
                center: center,
                radius: radius,
                startAngle: .degrees(180),
                endAngle: .degrees(270),
                clockwise: false
            )
            context.stroke(yellowPath, with: .color(Color(hex: 0xFBBC05)), lineWidth: lineWidth)

            // Green arc (left-top)
            var greenPath = Path()
            greenPath.addArc(
                center: center,
                radius: radius,
                startAngle: .degrees(270),
                endAngle: .degrees(360),
                clockwise: false
            )
            context.stroke(greenPath, with: .color(Color(hex: 0x34A853)), lineWidth: lineWidth)

            // Blue horizontal bar (the crossbar of G)
            let barWidth = radius * 0.65
            let barHeight = lineWidth
            let barRect = CGRect(
                x: center.x,
                y: center.y - barHeight / 2,
                width: barWidth,
                height: barHeight
            )
            context.fill(Path(barRect), with: .color(Color(hex: 0x4285F4)))
        }
    }
}

#Preview {
    VStack(spacing: 12) {
        SignInWithAppleButton { }
        SignInWithGoogleButton { }
    }
    .padding()
    .background(Color.black)
}
