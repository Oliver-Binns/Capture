import Photos

extension Photo {
    var metadata: CFDictionary {
        [
            kCGImagePropertyTIFFDictionary as String: [
                kCGImagePropertyTIFFMake: camera?.make,
                kCGImagePropertyTIFFModel: camera?.model
            ],
            kCGImagePropertyExifDictionary as String: [
                kCGImagePropertyExifLensMake: lens?.make,
                kCGImagePropertyExifLensModel: lens?.model,
                
            ]
        ] as CFDictionary
    }
}
