#if canImport(UIKit)
import UIKit
typealias PlatformImage = UIImage
#elseif canImport(AppKit)
import AppKit
typealias PlatformImage = NSImage
#endif
import SwiftUI

extension PlatformImage {
    var image: Image {
        #if canImport(AppKit)
        Image(nsImage: self)
        #elseif canImport(UIKit)
        Image(uiImage: self)
        #endif
    }
}
