import SwiftData
import SwiftUI

@Model
final class Photo {
    @Attribute(.unique) let id: UUID
    
    @Attribute(.externalStorage)
    var preview: Data?
    
    var timestamp: Date
    var location: Location?
    
    @Relationship var camera: Camera?
    @Relationship var lens: Lens?
    
    var filmSpeed: FilmSpeed?
    
    init(id: UUID = UUID(),
         preview: Data?,
         timestamp: Date,
         location: Location?,
         camera: Camera?,
         lens: Lens?,
         filmSpeed: FilmSpeed) {
        self.id = id
        self.preview = preview
        self.timestamp = timestamp
        self.location = location
        self.camera = camera
         self.lens = lens
        self.filmSpeed = filmSpeed
    }
}
