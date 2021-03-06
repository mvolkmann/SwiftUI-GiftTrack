import CoreLocationUI
import MapKit
import SwiftUI

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    // MARK: - Constants

    private var manager = CLLocationManager()

    // MARK: - Properties

    @Published var location: CLLocationCoordinate2D?

    // MARK: - Initializer

    override init() {
        super.init()
        manager.delegate = self
    }

    // MARK: - Methods

    func locationManager(
        _ manager: CLLocationManager,
        didChangeAuthorization status: CLAuthorizationStatus
    ) {
        if status == .authorizedWhenInUse {
            manager.requestLocation()
        }
    }

    func locationManager(
        _: CLLocationManager,
        didFailWithError error: Swift.Error
    ) {
        print("LocationManager error: \(error.localizedDescription)")
    }

    func locationManager(
        _: CLLocationManager,
        didUpdateLocations locations: [CLLocation]
    ) {
        // This triggers the @Publish above.
        location = locations.first?.coordinate
    }

    func requestLocation() {
        manager.requestLocation()
    }
}

struct MapAnnotation: Identifiable {
    var coordinate: CLLocationCoordinate2D
    let id = UUID()
}

struct MyMap: View {
    // MARK: - State

    @State private var annotations: [MapAnnotation] = []
    @State private var gettingLocation = false
    @State private var region: MKCoordinateRegion = .init()

    @StateObject var locationManager = LocationManager()

    // MARK: - Initializer

    init(
        latitude: Binding<Double>,
        longitude: Binding<Double>,
        edit: Bool = true
    ) {
        _latitude = latitude
        _longitude = longitude
        self.edit = edit
        _region = State(initialValue: MKCoordinateRegion(center: coordinate, span: SPAN))
        _annotations = State(initialValue: [MapAnnotation(coordinate: coordinate)])
    }

    // MARK: - Constants

    private let SPAN = MKCoordinateSpan(
        latitudeDelta: 0.005,
        longitudeDelta: 0.005
    )

    // MARK: - Properties

    @Binding private var latitude: Double {
        didSet { updateMap() }
    }

    @Binding private var longitude: Double {
        didSet { updateMap() }
    }

    private let edit: Bool

    private var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }

    var body: some View {
        HStack {
            if edit {
                if latitude == 0 || longitude == 0 {
                    if gettingLocation {
                        if let loc = locationManager.location {
                            // TODO: Ask Brian Coyner if there is a better way to do this.
                            Text(getText(loc)) // only for side effect
                        } else if gettingLocation {
                            MyText("Getting map ...")
                            Spacer()
                            ProgressView()
                        }
                    } else {
                        LocationButton {
                            gettingLocation = true
                            locationManager.requestLocation()
                        }
                        .labelStyle(.titleAndIcon)
                        // .background(.red) How can you change the background color?
                        .foregroundColor(.white)
                        .cornerRadius(7)
                        Text("Tap for map")
                    }
                } else {
                    Map(
                        coordinateRegion: $region,
                        annotationItems: annotations
                    ) { annotation in
                        MapPin(coordinate: annotation.coordinate, tint: .red)
                    }
                    .frame(maxWidth: .infinity, minHeight: 200)
                    Spacer()
                    DeleteButton(action: clearLocation)
                }
            } else if latitude != 0 || longitude != 0 {
                Map(
                    coordinateRegion: $region,
                    annotationItems: annotations
                ) { annotation in
                    MapPin(coordinate: annotation.coordinate, tint: .red)
                }
                .frame(maxWidth: .infinity, minHeight: 200)
            }
        }
    }

    // MARK: - Methods

    func clearLocation() {
        latitude = 0
        longitude = 0
        gettingLocation = false
        // TODO: How can I force LocationManager to get the location again?
    }

    func getText(_ location: CLLocationCoordinate2D) -> String {
        if gettingLocation {
            // This avoids updating state during view rendering.
            DispatchQueue.main.async {
                latitude = location.latitude
                longitude = location.longitude
            }
        }
        return ""
    }

    func updateMap() {
        if latitude == 0 || longitude == 0 { return }
        region = MKCoordinateRegion(center: coordinate, span: SPAN)
        annotations = [MapAnnotation(coordinate: coordinate)]
    }
}
