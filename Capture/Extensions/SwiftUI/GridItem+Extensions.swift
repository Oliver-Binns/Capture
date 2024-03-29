import SwiftUI

extension Array where Element == GridItem {
    static var three: Self {
        [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    }
}
