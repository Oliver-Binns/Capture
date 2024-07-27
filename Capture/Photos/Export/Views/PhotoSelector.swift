import Photos
import SwiftUI

struct PhotoSelector: View {
    @Environment(PhotoLibrary.self) private var photoLibrary

    let didSelect: (PHAsset) -> Void

    var body: some View {
        ScrollView {
            LazyVGrid(columns: .three, spacing: 7) {
                ForEach(photoLibrary.results, id: \.self) { asset in
                    Button {
                        didSelect(asset)
                    } label: {
                        ThumbnailView(localAssetID: asset.localIdentifier)
                    }
                }
            }
        }
    }
}
