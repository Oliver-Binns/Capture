@testable import Capture
import CoreLocation
import XCTest

final class LocationFetcherTests: XCTestCase {
    private var sut: LocationFetcher!
    private var manager: FakeLocationManager!
    private var geocoder: FakeGeocoder!

    override func setUp() {
        super.setUp()

        manager = FakeLocationManager()
        geocoder = FakeGeocoder()
        sut = LocationFetcher(manager: manager, geocoder: geocoder)
    }

    func testDelegateGetsSet() {
        XCTAssertTrue(manager.delegate === sut)
    }

    func testCorrectlyCalculatesPermissionDenied() {
        XCTAssertFalse(sut.isPermissionDenied)

        sut.locationManagerDidChangeAuthorization(
            MockLocationManager(mockedAuthorizationStatus: .authorizedAlways)
        )
        XCTAssertFalse(sut.isPermissionDenied)

        #if !os(macOS)
        sut.locationManagerDidChangeAuthorization(
            MockLocationManager(mockedAuthorizationStatus: .authorizedWhenInUse)
        )
        XCTAssertFalse(sut.isPermissionDenied)
        #endif

        sut.locationManagerDidChangeAuthorization(
            MockLocationManager(mockedAuthorizationStatus: .restricted)
        )
        XCTAssertTrue(sut.isPermissionDenied)

        sut.locationManagerDidChangeAuthorization(
            MockLocationManager(mockedAuthorizationStatus: .denied)
        )
        XCTAssertTrue(sut.isPermissionDenied)
    }

    func testRequestLocationRequestsAuthorizationIfRequired() {
        Task {
            try await sut.requestLocation()
        }

        wait(for: self.sut.isLoading)
        XCTAssertTrue(manager.requestedAuthorization)
        XCTAssertFalse(manager.startedUpdatingLocation)
    }

    func testRequestLocationStartsTracking() {
        manager.authorizationStatus = .authorizedAlways

        Task {
            try await sut.requestLocation()
        }

        wait(for: self.sut.isLoading)
        XCTAssertFalse(manager.requestedAuthorization)
        XCTAssertTrue(manager.startedUpdatingLocation)
    }

    func testAcceptingLocationPermissionsStartsLocationTracking() {
        Task {
            _ = try await sut.requestLocation()
        }
        wait(for: self.sut.isLoading)

        sut.locationManagerDidChangeAuthorization(
            MockLocationManager(mockedAuthorizationStatus: .authorizedAlways)
        )

        XCTAssertTrue(manager.startedUpdatingLocation)
    }

    func testDenyingLocationPermissionsStopsLoadingIndicator() {
        sut.locationManagerDidChangeAuthorization(
            MockLocationManager(mockedAuthorizationStatus: .denied)
        )

        XCTAssertFalse(manager.startedUpdatingLocation)
        XCTAssertFalse(sut.isLoading)
    }

    func testFindingLocationStopsTracking() {
        let location = CLLocation(latitude: 0, longitude: 0)
        let manager = MockLocationManager()
        sut.locationManager(manager, didUpdateLocations: [location])

        XCTAssertTrue(manager.stoppedUpdatingLocation)
    }

    func testFindLocationNameCallsGeocoder() {
        let location = CLLocation(latitude: 0, longitude: 0)
        sut.locationManager(CLLocationManager(), didUpdateLocations: [location])

        wait(for: self.geocoder.didCallReverseGeocode)
    }

    func testSUTStopsLoadingWhenLocationFound() {
        manager.authorizationStatus = .authorizedAlways

        Task {
            let exp = expectation(description: "Ensure location assertions are run")
            let location = try await sut.requestLocation()

            XCTAssertFalse(sut.isLoading)
            XCTAssertEqual(location.name, "1 Infinite Loop")
            XCTAssertEqual(location.latitude, 0)
            XCTAssertEqual(location.longitude, 0)

            exp.fulfill()
        }

        wait(for: self.sut.isLoading)

        let location = CLLocation(latitude: 0, longitude: 0)
        sut.locationManager(CLLocationManager(), didUpdateLocations: [location])

        waitForExpectations(timeout: 3)
    }
}
