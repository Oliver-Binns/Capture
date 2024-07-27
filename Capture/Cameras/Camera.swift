import SwiftData
import SwiftUI

@Model
final class Camera {
    @Attribute(.unique) private(set) var id: UUID
    var make: String
    var model: String
    
    init(id: UUID = UUID(),
         make: String,
         model: String) {
        self.id = id
        self.make = make
        self.model = model
    }
}
