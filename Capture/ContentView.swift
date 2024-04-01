import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            FilmList()
            CamerasList()
            LensesList()
        }
    }
}

#Preview {
    ContentView()
}
