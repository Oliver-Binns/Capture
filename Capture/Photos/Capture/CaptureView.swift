import SwiftUI

struct CaptureView: View {
    var viewModel: CaptureViewModel
    
    var body: some View {
        ZStack {
            if let photo = viewModel.photo {
                Color.clear
                   .aspectRatio(3/2, contentMode: .fit)
                   .overlay(
                        photo.resizable().scaledToFill()
                   )
                   .clipped()
            }
            
            VStack(alignment: .trailing) {
                Spacer()
                HStack(alignment: .bottom) {
                    Spacer()
                    Button {
                        Task {
                            try await viewModel.takeOrResetPhoto()
                        }
                    } label: {
                        Image(systemName: viewModel.isPreviewing ?
                                "camera.circle.fill" :
                                "arrow.uturn.left.circle.fill"
                        ).font(.largeTitle)
                    }
                    .accessibilityLabel("Capture image")
                    .padding()
                }
            }
        }
    }
}
