import CoreLocation
import CoreLocationUI
import SwiftUI

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    let manager = CLLocationManager()

    @Published var location: CLLocationCoordinate2D?

    override init() {
        super.init()
        manager.delegate = self
    }

    func requestLocation() {
        manager.requestLocation()
    }

    func locationManager(
        _ manager: CLLocationManager,
        didChangeAuthorization status: CLAuthorizationStatus
    ) {
        if status == .authorizedWhenInUse {
            manager.requestLocation()
        }
    }
    
    func locationManager(
        _ manager: CLLocationManager,
        didFailWithError error: Swift.Error
    ) {
        print("LocationManager error: \(error.localizedDescription)")
    }
    
    func locationManager(
        _ manager: CLLocationManager,
        didUpdateLocations locations: [CLLocation]
    ) {
        location = locations.first?.coordinate
    }
}

struct Location: View {
    @EnvironmentObject var settings: Settings
    @StateObject var locationManager = LocationManager()
    @State private var gettingLocation = false
    
    typealias Callback = (CLLocationCoordinate2D) -> Void
    private let action: Callback
    
    init(action: @escaping Callback) {
        self.action = action
    }
    
    func getText(_ loc: CLLocationCoordinate2D) -> String {
        action(loc)
        return ""
    }
    
    var body: some View {
        VStack {
            if let loc = locationManager.location {
                Text(getText(loc)) // only for side effect
            } else if gettingLocation {
                ProgressView()
            } else {
                LocationButton {
                    gettingLocation = true
                    locationManager.requestLocation()
                }
                //.symbolVariant(.circle)
                //.labelStyle(.titleAndIcon)
                //.background(.red) How can you change the background color?
                .foregroundColor(.white)
                .cornerRadius(7)
            }
        }
    }
}
