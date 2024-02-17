import SwiftUI

extension View {
    func macOSSheet() -> some View {
        #if os(macOS)
        padding().frame(minWidth: 400)
        #else
        self
        #endif
    }
}
