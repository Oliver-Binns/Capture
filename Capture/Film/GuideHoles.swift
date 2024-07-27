import SwiftUI

struct GuideHoles: View {
    let width: CGFloat = 10
    var height: CGFloat {
        width * 16 / 9
    }

    var body: some View {
        GeometryReader { geometry in
            // width * 2 to account for spacing!
            let spaces = Int(geometry.size.width / (width * 2)) + 1

            HStack(spacing: width) {
                ForEach(0..<spaces, id: \.self) { _ in
                    RoundedRectangle(cornerRadius: height * 0.15)
                        .foregroundStyle(.background)
                        .frame(width: width, height: height)
                }
            }
        }
        .frame(height: height)
        .padding(.vertical, 8)
    }
}
