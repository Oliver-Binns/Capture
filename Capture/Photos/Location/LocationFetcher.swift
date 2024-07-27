import CoreLocation
import Observation

@Observable
final class LocationFetcher: NSObject {
    private let manager: LocationManager
    private let geocoder: Geocoder
    private var authorizationStatus: CLAuthorizationStatus

    var isPermissionDenied: Bool {
        switch authorizationStatus {
        case .denied, .restricted:
            true
        default:
            false
        }
    }

    private var continuation: CheckedContinuation<Location, Error>?

    private(set) var isLoading: Bool = false

    init(manager: LocationManager = CLLocationManager(),
         geocoder: Geocoder = CLGeocoder()) {
        self.manager = manager
        self.geocoder = geocoder
        self.authorizationStatus = manager.authorizationStatus
        super.init()
        self.manager.delegate = self
    }

    func requestLocation() async throws -> Location {
        if manager.authorizationStatus == .notDetermined {
            manager.requestWhenInUseAuthorization()
        } else {
            manager.startUpdatingLocation()
        }

        isLoading = true
        return try await withCheckedThrowingContinuation { continuation in
            self.continuation = continuation
        }
    }
}

extension LocationFetcher: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        self.authorizationStatus = manager.authorizationStatus

        switch authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            self.manager.startUpdatingLocation()
        default:
            isLoading = false
        }
    }

    func locationManager(_ manager: CLLocationManager,
                         didUpdateLocations locations: [CLLocation]) {
        manager.stopUpdatingLocation()

        guard let location = locations.first else {
            preconditionFailure("At least one location should always be provided.")
        }
        Task {
            await findLocationName(location)
        }
    }

    private func findLocationName(_ clLocation: CLLocation) async {
        let locationName = try? await geocoder
            .reverseGeocodeLocation(clLocation)
            .first?.name

        let location = Location(name: locationName,
                                latitude: clLocation.coordinate.latitude,
                                longitude: clLocation.coordinate.longitude)
        continuation?.resume(returning: location)

        self.isLoading = false
    }
}
