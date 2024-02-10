import SwiftData
import SwiftUI

@Model
final class Lens {
    @Attribute(.unique) let id: UUID
    var make: String
    var model: String
    
    init(id: UUID = UUID(), make: String, model: String) {
        self.id = id
        self.make = make
        self.model = model
    }
}
