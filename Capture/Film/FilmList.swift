import SwiftData
import SwiftUI

struct FilmList: View {
    @Query var rolls: [FilmRoll]
    @Environment(\.modelContext) private var modelContext
    
    func guideHoles(width: CGFloat = 34) -> some View {
        let height = width * 9 / 16
        
        return GeometryReader { geometry in
            // width * 2 to account for spacing!
            let spaces = Int(geometry.size.width / (width * 2)) + 1
            
            HStack(spacing: width) {
                ForEach(0..<spaces, id: \.self) { _ in
                    RoundedRectangle(cornerRadius: height * 0.1)
                        .foregroundStyle(.white)
                        .frame(width: width, height: height)
                }
            }
        }
        .frame(height: height)
        .padding(.vertical)
    }
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(rolls) { roll in
                    ScrollView(.horizontal) {
                        VStack {
                            guideHoles()
                            
                            HStack {
                                RoundedRectangle(cornerRadius: 3)
                                    .foregroundStyle(.white)
                                    .frame(width: 5, height: 150)
                                
                                Text("\(roll.id)").foregroundStyle(.white)
                            }
                        
                            guideHoles()
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .background(.black)
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
