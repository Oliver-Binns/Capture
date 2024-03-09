import SwiftUI

struct CaptureView: View {
    var viewModel: CaptureViewModel
    
    var body: some View {
        ZStack {
            if let photo = viewModel.photo {
                photo
                    .resizable()
                    .background(Color.red)
            }
            
            VStack(alignment: .trailing) {
                Spacer()
                HStack(alignment: .bottom) {
                    Spacer()
                    Button {
                        viewModel.takeOrResetPhoto()
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
