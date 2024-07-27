import SwiftData
import SwiftUI

struct FilmList: View {
    @Query var rolls: [FilmRoll]
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(rolls) { roll in
                    FilmView(film: roll)
                        .frame(maxWidth: .infinity)
                        .listRowSeparator(.hidden)
                        .listRowInsets(EdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 0))
                }
            }
            .navigationTitle("Photos")
            .toolbar {
                Button {
                    modelContext.insert(FilmRoll())
                    try? modelContext.save()
                } label: {
                    Label("Add", systemImage: "plus")
                }
            }
        }
        .listStyle(.plain)
        .background(.secondary)
        .tabItem {
            Label("Photos", systemImage: "film.stack.fill")
        }
    }
}
