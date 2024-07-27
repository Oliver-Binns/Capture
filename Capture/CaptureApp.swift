import SwiftData
import SwiftUI

@main
struct CaptureApp: App {
    let modelContainer: ModelContainer
    
    init() {
        do {
            modelContainer = try ModelContainer(
                for: FilmRoll.self, Photo.self, Lens.self, Camera.self,
                migrationPlan: PhotosMigrationPlan.self
            )
        } catch {
            fatalError("Failed to initialize model container.")
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(modelContainer)
        }
    }
}
