import SwiftUI

struct FilmView: View {
    @State var film: FilmRoll
    @State var isEditing: Bool = false
    
    var body: some View {
        GeometryReader { proxy in
            ScrollView(.horizontal) {
                VStack(spacing: 0) {
                    GuideHoles()
                        .frame(minWidth: proxy.size.width)

                    HStack {
                        ForEach(film.photos.sorted()) { photo in
                            NavigationLink {
                                PhotoEditor(roll: film, photo: photo)
                            } label: {
                                if let preview = photo.preview,
                                   let image = CIImage(data: preview)?.image {
                                    Color.clear
                                        .aspectRatio(3/2, contentMode: .fit)
                                        .overlay(
                                            image.resizable().scaledToFill()
                                        )
                                        .opacity(0.7)
                                        .clipped()
                                }
                            }
                        }

                        RoundedRectangle(cornerRadius: 3)
                            .foregroundStyle(.background)
                            .frame(width: 3)
                            .padding(.vertical, 4)

                        Button {
                            isEditing = true
                        } label: {
                            Label("Log New Photo", systemImage: "plus.circle.fill")
                        }
                        .buttonStyle(.borderedProminent)
                        .foregroundStyle(.black)
                    }
                    .scrollTargetLayout()

                    GuideHoles()
                        .frame(minWidth: proxy.size.width)
                }
                .padding(.horizontal, 8)
                .background(.film)
                .sheet(isPresented: $isEditing) {
                    NavigationStack {
                        PhotoEditor(roll: film, photo: nil)
                    }
                }
            }
            .scrollTargetBehavior(.viewAligned)
            .scrollIndicators(.hidden)
            .defaultScrollAnchor(.trailing)
        }.frame(height: 200)
    }
}
