import SwiftData
import SwiftUI

struct LensesList: View {
    @Query var lenses: [Lens]
    @State var isEditing: Bool = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(lenses) { lens in
                    Text("\(lens.make) \(lens.model)")
                }
            }
            .navigationTitle("Lenses")
            .toolbar {
                Button {
                    isEditing = true
                } label: {
                    Label("Add", systemImage: "plus")
                }
            }
        }.tabItem {
            Label("Lenses", systemImage: "camera.aperture")
        }.sheet(isPresented: $isEditing) {
            LensEditor(lens: nil)
        }
    }
}
