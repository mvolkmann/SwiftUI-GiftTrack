import CoreLocationUI
import MapKit
import SwiftUI

struct MapAnnotation: Identifiable {
    var coordinate: CLLocationCoordinate2D
    let id = UUID()
}

struct MyMap: View {
    // MARK: - State

    @State private var annotations: [MapAnnotation] = []
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
                    if locationManager.isBusy {
                        MyText("Getting map ...")
                        Spacer()
                        ProgressView()
                    } else {
                        LocationButton {
                            locationManager.requestLocation()
                        }
                        .labelStyle(.titleAndIcon)
                        // .background(.red) How can you change the background color?
                        .foregroundColor(.white)
                        .cornerRadius(7)
                        .disabled(locationManager.isBusy)

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
        .onChange(of: locationManager.location) { location in
            if let location = location {
                latitude = location.latitude
                longitude = location.longitude
            } else {
                latitude = 0
                longitude = 0
            }
        }
    }

    // MARK: - Methods

    func clearLocation() {
        latitude = 0
        longitude = 0
        // TODO: How can I force LocationManager to get the location again?
    }

    func updateMap() {
        guard latitude != 0 || longitude != 0 else { return }

        region = MKCoordinateRegion(center: coordinate, span: SPAN)
        annotations = [MapAnnotation(coordinate: coordinate)]
    }
}
