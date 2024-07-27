import SwiftData
import SwiftUI

@Model
final class Lens {
    @Attribute(.unique) private(set) var id: UUID
    var make: String
    var model: String
    
    var maxAperture: Float?
    var minAperture: Int?
    var focalLength: Int?
    
    var description: String {
        "\(make) \(model)"
    }
    
    var details: String? {
        guard let maxAperture, let focalLength else {
            return nil
        }
        return "ƒ/\(maxAperture) • \(focalLength)mm"
    }
    
    init(id: UUID = UUID(),
         make: String, model: String,
         maxAperture: Float?, minAperture: Int?,
         focalLength: Int?) {
        self.id = id
        self.make = make
        self.model = model
        self.maxAperture = maxAperture
        self.minAperture = minAperture
        self.focalLength = focalLength
    }
}
