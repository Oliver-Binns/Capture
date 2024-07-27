import CoreImage
import SwiftUI

extension CIImage {
    var image: Image? {
        let ciContext = CIContext()
        guard let cgImage = ciContext.createCGImage(self, from: self.extent) else { return nil }
        return Image(decorative: cgImage, scale: 1, orientation: .up)
    }

    var exportOptions: [CIImageRepresentationOption: Any] {
        [kCGImageDestinationLossyCompressionQuality as CIImageRepresentationOption: 0.7]
    }

    var data: Data? {
        let ciContext = CIContext()

        guard let colorSpace = CGColorSpace(name: CGColorSpace.sRGB),
              let data = ciContext.jpegRepresentation(of: self,
                                                      colorSpace: colorSpace,
                                                      options: exportOptions) else {
            return nil
        }

        return data
    }
}
