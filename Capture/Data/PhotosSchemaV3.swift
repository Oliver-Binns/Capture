import Foundation
import SwiftData

enum PhotosSchemaV3: VersionedSchema {
    static var versionIdentifier = Schema.Version(2, 0, 1)

    static var models: [any PersistentModel.Type] {
        [Photo.self, FilmRoll.self]
    }
    
    @Model
    final class FilmRoll {
        @Attribute(.unique) let id: UUID
        @Relationship(deleteRule: .cascade, inverse: \Photo.roll) var photos: [Photo]
        
        init(id: UUID = UUID()) {
            self.id = id
            self.photos = []
        }
    }
    
    @Model
    final class Photo {
        @Attribute(.unique) let id: UUID
        
        @Attribute(.externalStorage)
        var preview: Data?
        
        var timestamp: Date
        var location: Location?
        
        @Relationship var camera: Camera?
        @Relationship var lens: Lens?
        
        var filmSpeed: FilmSpeed
        
        @Relationship var roll: FilmRoll
        
        init(id: UUID = UUID(),
             preview: Data?,
             timestamp: Date,
             location: Location?,
             camera: Camera?,
             lens: Lens?,
             filmSpeed: FilmSpeed,
             roll: FilmRoll) {
            self.id = id
            self.preview = preview
            self.timestamp = timestamp
            self.location = location
            self.camera = camera
            self.lens = lens
            self.filmSpeed = filmSpeed
            self.roll = roll
        }
    }

}
