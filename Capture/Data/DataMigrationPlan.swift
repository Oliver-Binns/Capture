import SwiftData

typealias FilmRoll = PhotosSchemaV3.FilmRoll
typealias Photo = PhotosSchemaV3.Photo

enum PhotosMigrationPlan: SchemaMigrationPlan {
    static var schemas: [any VersionedSchema.Type] {
        [PhotosSchemaV1.self, PhotosSchemaV2.self, PhotosSchemaV3.self]
    }
    
    static var stages: [MigrationStage] {
        [
            .custom(fromVersion: PhotosSchemaV1.self,
                    toVersion: PhotosSchemaV2.self,
                    willMigrate: nil, didMigrate: nil),
            
            .custom(fromVersion: PhotosSchemaV2.self,
                    toVersion: PhotosSchemaV3.self,
                    willMigrate: { context in
                        let filmRoll = PhotosSchemaV2.FilmRoll()
                        context.insert(filmRoll)
                        
                        let photos = try context.fetch(FetchDescriptor<PhotosSchemaV2.Photo>())
                        photos.forEach {
                            $0.roll = filmRoll
                        }
                        
                        try context.save()
                    }, didMigrate: nil)
        ]
    }
}
