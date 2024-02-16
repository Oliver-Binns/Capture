import CoreLocation

protocol Geocoder: AnyObject {
    func reverseGeocodeLocation(_ location: CLLocation) async throws -> [CLPlacemark]
}

extension CLGeocoder: Geocoder { }
