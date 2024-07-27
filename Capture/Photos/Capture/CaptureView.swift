import SwiftUI

struct CaptureView: View {
    var viewModel: CaptureViewModel

    var body: some View {
        Button {
            Task {
                try await viewModel.takeOrResetPhoto()
            }
        } label: {
            if let photo = viewModel.photo {
                ZStack {
                    Color.clear
                        .aspectRatio(3/2, contentMode: .fit)
                        .overlay(
                            photo.resizable().scaledToFill()
                        )
                        .clipped()

                    VStack(alignment: .trailing) {
                        Spacer()
                        HStack(alignment: .bottom) {
                            Spacer()

                            Image(systemName: viewModel.isPreviewing ?
                                  "camera.circle.fill" :
                                    "arrow.uturn.left.circle.fill"
                            ).font(.largeTitle)
                                .accessibilityLabel("Capture image")
                                .padding()
                        }
                    }
                }
            } else {
                ContentUnavailableView("Tap to save a preview",
                                       systemImage: "camera.circle.fill")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
    }
}
