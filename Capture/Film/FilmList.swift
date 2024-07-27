import SwiftData
import SwiftUI

struct FilmList: View {
    @Query var rolls: [FilmRoll]
    @Environment(\.modelContext) private var modelContext


    var body: some View {
        NavigationStack {
            Group {
                if rolls.count == 0 {
                    List {
                        ContentUnavailableView("Add a film roll to get started!",
                                               systemImage: "film.stack.fill")
                    }
                } else {
                    List {
                        ForEach(rolls) { roll in
                            FilmView(film: roll)
                                .frame(maxWidth: .infinity)
                                .listRowSeparator(.hidden)
                                .listRowInsets(EdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 0))
                        }
                    }.listStyle(.plain)
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
        .background(.secondary)
        .tabItem {
            Label("Photos", systemImage: "film.stack.fill")
        }
    }
}
