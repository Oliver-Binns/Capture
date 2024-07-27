import SwiftData
import SwiftUI

struct LensesList: View {
    @Environment(\.modelContext) private var modelContext

    @Query private var lenses: [Lens]
    @State private var isEditing: Bool = false

    var body: some View {
        NavigationStack {
            List {
                ForEach(lenses) { lens in
                    NavigationLink {
                        LensEditor(lens: lens)
                    } label: {
                        VStack(alignment: .leading) {
                            Text(lens.description)

                            if let details = lens.details {
                                Text(details)
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                            }
                        }.swipeActions(edge: .trailing) {
                            Button(role: .destructive) {
                                modelContext.delete(lens)
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                    }
                }

                if lenses.count == 0 {
                    ContentUnavailableView("Add a lens to get started!",
                                           systemImage: "camera.aperture")
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
