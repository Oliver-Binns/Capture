import SwiftUI

struct LocationButton: View {
    @Binding var location: Location?
    
    @State private var showLocationPermissionError: Bool = false
    @State private var locationFetcher = LocationFetcher()
    
    private var displayText: String {
        if let name = location?.name {
            name
        } else if let location {
            "\(location.latitude.formatted(.number)), \(location.longitude.formatted(.number))"
        } else {
            "Add Location"
        }
    }
    
    var body: some View {
        Button {
            Task {
                await fetchLocation()
            }
        } label: {
            Label {
                Text(displayText)
            } icon: {
                if locationFetcher.isLoading {
                    ProgressView()
                } else {
                    Image(systemName: "location")
                }
            }
        }
        .disabled(locationFetcher.isLoading)
        .alert("Permission Denied",
               isPresented: $showLocationPermissionError) {
            Button("Cancel", role: .cancel) { }
            
            #if !os(macOS)
            Button("Open Settings") {
                if let url = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(url)
                }
            }
            #endif
        } message: {
            Text("You must grant access to location data in the Settings app.")
        }
    }
    
    
    func fetchLocation() async {
        if locationFetcher.isPermissionDenied {
            showLocationPermissionError = true
        } else {
            self.location = try? await locationFetcher.requestLocation()
        }
    }
}
