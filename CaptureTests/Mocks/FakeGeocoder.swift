@testable import Capture
import CoreLocation
import MapKit

final class FakeGeocoder: Geocoder {
    private(set) var didCallReverseGeocode: Bool = false

    func reverseGeocodeLocation(_ location: CLLocation) async throws -> [CLPlacemark] {
        didCallReverseGeocode = true

        let coordinate = CLLocationCoordinate2D(latitude: 37.331686,
                                                longitude: -122.030656)
        let mkPlacemark = MockPlacemark(
            coordinate: coordinate,
            addressDictionary: ["name": "1 Infinite Loop"]
        )

        return [
            mkPlacemark
        ]
    }
}
