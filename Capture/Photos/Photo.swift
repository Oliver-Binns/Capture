import SwiftData
import SwiftUI

@Model
final class Photo {
    @Attribute(.unique) let id: UUID
    
    var timestamp: Date
    var location: Location?
    
    @Relationship var camera: Camera?
    @Relationship var lens: Lens?
    
    var filmSpeed: FilmSpeed?
    
    init(id: UUID = UUID(),
         timestamp: Date,
         location: Location?,
         camera: Camera?,
         lens: Lens?,
         filmSpeed: FilmSpeed) {
        self.id = id
        self.timestamp = timestamp
        self.location = location
        self.camera = camera
         self.lens = lens
        self.filmSpeed = filmSpeed
    }
}
