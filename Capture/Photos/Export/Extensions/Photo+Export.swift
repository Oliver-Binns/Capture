import Photos

extension Photo {
    private var tiffDictionary: [CFString: String] {
        [
            kCGImagePropertyTIFFMake: camera?.make,
            kCGImagePropertyTIFFModel: camera?.model
        ].compactMapValues { $0 }
    }
    
    private var exifDictionary: [CFString: String] {
        [
            kCGImagePropertyExifLensMake: lens?.make,
            kCGImagePropertyExifLensModel: lens?.model,
            kCGImagePropertyExifISOSpeed: filmSpeed.rawValue.description,
            kCGImagePropertyExifFocalLength: lens?.focalLength?.description,
            kCGImagePropertyExifMaxApertureValue: lens?.maxAperture?.description,
        ].compactMapValues { $0 }
    }
    
    var metadata: CFDictionary {
        [
            kCGImagePropertyTIFFDictionary as String: tiffDictionary,
            kCGImagePropertyExifDictionary as String: exifDictionary
        ] as CFDictionary
    }
}
