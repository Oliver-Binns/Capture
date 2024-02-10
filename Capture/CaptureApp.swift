import SwiftUI

@main
struct CaptureApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(for: [Photo.self, Lens.self, Camera.self])
        }
    }
}
