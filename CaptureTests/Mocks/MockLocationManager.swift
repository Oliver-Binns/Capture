import CoreLocation

final class MockLocationManager: CLLocationManager {
    private let mockedAuthorizationStatus: CLAuthorizationStatus
    private(set) var stoppedUpdatingLocation: Bool = false

    init(mockedAuthorizationStatus: CLAuthorizationStatus = .notDetermined) {
        self.mockedAuthorizationStatus = mockedAuthorizationStatus
    }

    override var authorizationStatus: CLAuthorizationStatus {
        mockedAuthorizationStatus
    }

    override func stopUpdatingLocation() {
        stoppedUpdatingLocation = true
    }
}
