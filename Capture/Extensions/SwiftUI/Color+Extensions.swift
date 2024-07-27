import SwiftUI

extension Color {
    static var systemGray4: Color {
        #if canImport(UIKit)
        Color(.systemGray4)
        #else
        Color(.lightGray)
        #endif
    }

    static var label: Color {
        #if canImport(UIKit)
        Color(.label)
        #else
        Color(.labelColor)
        #endif
    }
}
