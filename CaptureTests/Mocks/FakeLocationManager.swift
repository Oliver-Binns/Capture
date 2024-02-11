@testable import Capture
import CoreLocation

final class FakeLocationManager: LocationManager {
    var delegate: (CLLocationManagerDelegate)?
    var authorizationStatus: CLAuthorizationStatus = .notDetermined
    
    private(set) var requestedAuthorization: Bool = false
    private(set) var startedUpdatingLocation: Bool = false
    private(set) var stoppedUpdatingLocation: Bool = false
    
    func requestWhenInUseAuthorization() {
        requestedAuthorization = true
    }
    
    func startUpdatingLocation() {
        startedUpdatingLocation = true
    }
    
    func stopUpdatingLocation() {
        stoppedUpdatingLocation = true
    }
}
