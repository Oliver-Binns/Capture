import SwiftUI

struct ThumbnailView: View {
    @Environment(PhotoLibrary.self) private var photoLibrary
    @State private var image: Image?
    
    let localAssetID: String
    
    var body: some View {
        ZStack {
            if let image = image {
                GeometryReader { proxy in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(
                            width: proxy.size.width,
                            height: proxy.size.width
                        )
                        .clipped()
                }
                .aspectRatio(1, contentMode: .fit)
            } else {
                Rectangle()
                    .foregroundColor(.gray)
                    .aspectRatio(1, contentMode: .fit)
                ProgressView()
            }
        }
        .task {
            await loadImageAsset()
        }
        .onDisappear {
            image = nil
        }
    }
    
    func loadImageAsset() async {
        guard let uiImage = await photoLibrary
            .fetchImage(localIdentifier: localAssetID) else {
            return
        }
        image = Image(uiImage: uiImage)
    }
}

