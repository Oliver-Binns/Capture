import SwiftData
import SwiftUI

@Model
final class Photo {
    @Attribute(.unique) let id: UUID
    
    let timestamp: Date
    let location: Location
    
    //@Relationship var camera: Camera?
    //@Relationship var lens: Lens?
    
    let filmSpeed: FilmSpeed
    
    let inCameraRoll: UUID? = nil
    
    init(id: UUID = UUID(),
         timestamp: Date = Date(),
         location: Location,
         camera: Camera,
         lens: Lens,
         filmSpeed: FilmSpeed) {
        self.id = id
        self.timestamp = timestamp
        self.location = location
        //self.camera = camera
        // self.lens = lens
        self.filmSpeed = filmSpeed
    }
}
