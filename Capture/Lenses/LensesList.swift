import SwiftData
import SwiftUI

struct LensesList: View {
    @Query private var lenses: [Lens]
    @State private var isEditing: Bool = false
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(lenses) { lens in
                    NavigationLink("\(lens.make) \(lens.model)") {
                        LensEditor(lens: lens)
                    }
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
            NavigationStack {
                LensEditor(lens: nil)
            }
        }
    }
}
