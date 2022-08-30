import CoreLocation

// Make this class Equatable so it can be used in .onChange(of:) in MyMap.swift.
extension CLLocationCoordinate2D: Equatable {}
public func == (
    lhs: CLLocationCoordinate2D,
    rhs: CLLocationCoordinate2D
) -> Bool {
    return lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
}

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    // MARK: - Constants

    private let manager = CLLocationManager()

    // MARK: - Properties

    @Published var isBusy = false
    @Published var location: CLLocationCoordinate2D?

    var requested = false

    // MARK: - Initializer

    override init() {
        super.init()
        isBusy = false
        manager.delegate = self
    }

    // MARK: - Methods

    func locationManager(
        _ manager: CLLocationManager,
        didChangeAuthorization status: CLAuthorizationStatus
    ) {
        guard requested else { return }

        if status == .authorizedAlways || status == .authorizedWhenInUse {
            isBusy = true
            manager.requestLocation()
        }
    }

    func locationManager(
        _: CLLocationManager,
        didFailWithError error: Swift.Error
    ) {
        print("LocationManager error: \(error.localizedDescription)")
        isBusy = false
        requested = false
    }

    func locationManager(
        _: CLLocationManager,
        didUpdateLocations locations: [CLLocation]
    ) {
        location = locations.first?.coordinate
        isBusy = false
        requested = false
    }

    func requestLocation() {
        requested = true
        if manager.authorizationStatus == .notDetermined {
            // This call is required to display the message in the Info key
            // "Privacy - Location When In Use Usage Description".
            manager.requestWhenInUseAuthorization()

            // After the user grants or denies authorization, the "locationManager"
            // function that takes "didChangeAuthorization" is called.
        } else {
            isBusy = true
            manager.requestLocation()
        }
    }
}
