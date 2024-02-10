import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            PhotosList()
            CamerasList()
            LensesList()
        }
    }
}

#Preview {
    ContentView()
}
