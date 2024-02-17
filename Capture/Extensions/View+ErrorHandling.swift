import SwiftUI

extension View {
    func showPermissionDeniedError(
        _ errorOccurred: Binding<Bool>,
        reason: String
    )
    -> some View {
        alert("Permission Denied",
               isPresented: errorOccurred) {
            Button("Cancel", role: .cancel) { }
            
            #if !os(macOS)
            Button("Open Settings") {
                if let url = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(url)
                }
            }
            #endif
        } message: {
            Text(reason)
        }
    }
}
