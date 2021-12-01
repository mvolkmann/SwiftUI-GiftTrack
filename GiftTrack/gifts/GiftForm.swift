import CodeScanner
import CoreLocation
import MapKit
import SwiftUI

struct MapAnnotation: Identifiable {
    var coordinate: CLLocationCoordinate2D
    let id = UUID()
}

struct GiftForm: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.managedObjectContext) var moc
    
    @State private var barScanError = ""
    // Core Data won't allow an attribute to be named "description".
    @State private var desc = ""
    @State private var image: UIImage? = nil
    @State private var imageUrl = ""
    @State private var latitude = 0.0
    @State private var location = ""
    @State private var longitude = 0.0
    @State private var mapAnnotations: [MapAnnotation] = []
    @State private var name = ""
    @State private var openBarScanner = false
    @State private var openImagePicker = false
    @State private var openQRScanner = false
    @State private var price = NumbersOnly(0)
    @State private var purchased = false
    @State private var region: MKCoordinateRegion = MKCoordinateRegion()
    @State private var qrScanError = ""
    @State private var showBarScanError = false
    @State private var showQRScanError = false
    @State private var sourceType: UIImagePickerController.SourceType = .camera
    @State private var url = ""
    
    @Binding var mode: GiftMode
    
    private let person: PersonEntity
    private let occasion: OccasionEntity
    private var gift: GiftEntity?
    
    private let SPAN = MKCoordinateSpan(
        latitudeDelta: 0.005,
        longitudeDelta: 0.005
    )
    
    init(
        person: PersonEntity,
        occasion: OccasionEntity,
        gift: GiftEntity? = nil,
        mode: Binding<GiftMode>
    ) {
        //TODO: Why is this called 4 times when an existing gift is tapped?
        self.person = person
        self.occasion = occasion
        self.gift = gift
        _mode = mode
        
        if let gift = gift {
            // Preceding these property names with an underscore causes it
            // to refer to the underlying value of the binding
            // rather than the binding itself.
            // This is required to set the value of an @State property.
            _desc = State(initialValue: gift.desc ?? "")
            _imageUrl = State(initialValue: gift.imageUrl ?? "")
            _latitude = State(initialValue: gift.latitude)
            _location = State(initialValue: gift.location ?? "")
            _longitude = State(initialValue: gift.longitude)
            _name = State(initialValue: gift.name ?? "")
            _purchased = State(initialValue: gift.purchased)
            _price = State(initialValue: NumbersOnly(gift.price))
            _url = State(initialValue: gift.url?.absoluteString ?? "")
            
            if let data = gift.image {
                _image = State(initialValue: UIImage(data: data))
            }
            
            let coordinate = CLLocationCoordinate2D(
                latitude: gift.latitude,
                longitude: gift.longitude
            )
            _region = State(
                initialValue: MKCoordinateRegion(center: coordinate, span: SPAN)
            )
            _mapAnnotations = State(
                initialValue: [MapAnnotation(coordinate: coordinate)]
            )
        }
    }
    
    func done() {
        let adding = gift == nil
        let g = adding ? GiftEntity(context: moc) : gift!
        
        g.desc = desc.trim()
        g.image = image?.jpegData(compressionQuality: 1.0)
        g.imageUrl = imageUrl
        g.latitude = latitude
        g.location = location.trim()
        g.longitude = longitude
        g.name = name.trim()
        g.price = Int64(Int(price.value)!)
        g.purchased = purchased
        g.url = URL(string: url.trim())
    
        if adding {
            g.to = person
            g.reason = occasion
        }
        
        PersistenceController.shared.save()
        dismiss()
    }
    
    func handleBarScan(result: Result<String, CodeScannerView.ScanError>) {
        self.openBarScanner = false
        
        switch result {
        case .success(let code):
            print("handleBarScan: code =", code)
            loadProductData(productCode: code)
        case .failure(let error):
            showBarScanError = true
            qrScanError = "bar code scan failed: \(error)"
        }
    }
    
    func handleQRScan(result: Result<String, CodeScannerView.ScanError>) {
        self.openQRScanner = false
        
        switch result {
        case .success(let code):
            url = code
        case .failure(let error):
            showQRScanError = true
            qrScanError = "QR code scan failed: \(error)"
        }
    }
    
    func loadProductData(productCode: String) {
        let key = Bundle.main.object(
            forInfoDictionaryKey: "BARCODE_LOOKUP_KEY"
        ) as? String
        let url = "https://api.barcodelookup.com/v3/products" +
        "?barcode=\(productCode)&formatted=y&key=\(key!)"
        print("product url =", url)
        
        Task(priority: .medium) {
            do {
                let products = try await HttpUtil.get(
                    from: url,
                    type: Products.self
                ) as Products
                print("products =", products)
                let product = products.products.first
                
                DispatchQueue.main.async {
                    if let title = product?.title {
                        self.name = title
                    }
                    if let category = product?.category {
                        self.desc = category
                    }
                    if let imageUrl = product?.images.first {
                        self.imageUrl = imageUrl
                    }
                }
            } catch HTTPError.badStatus(let status) {
                barScanError = status == 404 ?
                    "Product not found" : "Bad status \(status)"
                showBarScanError = true
            } catch {
                print("error =", error.localizedDescription)
            }
        }
    }
    
    func updateLocation(coordinate: CLLocationCoordinate2D) {
        // Assigning directly doesn't work.
        // There must be a timing issue with updating @State variables.
        let lat = coordinate.latitude
        latitude = lat
        let long = coordinate.longitude
        longitude = long
        let loc = "\(String(format: "%.6f", lat)), \(String(format: "%.6f", long))"
        location = loc
        
        let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
        region = MKCoordinateRegion(center: coordinate, span: SPAN)
        mapAnnotations = [MapAnnotation(coordinate: coordinate)]
    }
    
    var body: some View {
        Page {
            Form {
                HStack {
                    Text("Bar Code Scan")
                    IconButton(icon: "barcode") { openBarScanner = true }
                }
                .alert(
                    "Bar Code Scan Failed",
                    isPresented: $showBarScanError,
                    actions: {}, // no custom buttons
                    message: { Text(barScanError) }
                )
                
                TextField("Name", text: $name)
                    .autocapitalization(.none)
                TextField("Description", text: $desc)
                    .autocapitalization(.none)
                
                HStack {
                    TextField("Location", text: $location)
                        .autocapitalization(.none)
                    if location.isEmpty {
                        Location(action: updateLocation)
                    } else {
                        IconButton(icon: "xmark.circle", size: 20) {
                            latitude = 0
                            longitude = 0
                            location = ""
                        }
                    }
                }
                
                if latitude != 0 && longitude != 0 {
                    Map(
                        coordinateRegion: $region,
                        annotationItems: mapAnnotations
                    ) { annotation in
                        MapPin(coordinate: annotation.coordinate, tint: .red)
                    }
                        .frame(maxWidth: .infinity, minHeight: 300)
                }
                
                TextField("Price", text: $price.value)
                    .keyboardType(.decimalPad)
                Toggle("Purchased?", isOn: $purchased)
                
                HStack {
                    TextField("URL", text: $url)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                    Spacer()
                    IconButton(icon: "qrcode") { openQRScanner = true }
                }
                .alert(
                    "QR Code Scan Failed",
                    isPresented: $showQRScanError,
                    actions: {}, // no custom buttons
                    message: { Text(qrScanError) }
                )
                
                HStack {
                    IconButton(icon: "camera") {
                        sourceType = .camera
                        openImagePicker = true
                    }
                    IconButton(icon: "photo.on.rectangle.angled") {
                        sourceType = .photoLibrary
                        openImagePicker = true
                    }
                    
                    if let unwrappedImage = image {
                        Image(uiImage: unwrappedImage)
                            .square(size: Settings.imageSize)
                        
                        IconButton(icon: "xmark.circle") {
                            image = nil
                            openImagePicker = false // TODO: Why needed?
                        }
                    }
                    
                    if let imageUrl = imageUrl, !imageUrl.isEmpty {
                        AsyncImage(
                            url: URL(string: imageUrl),
                            content: { image in
                                image
                                    .resizable()
                                    .frame(
                                        width: Settings.imageSize,
                                        height: Settings.imageSize
                                    )
                            },
                            placeholder: { ProgressView() } // spinner
                        )
                    }
                }
                // This fixes the bug with multiple buttons in a Form.
                .buttonStyle(.borderless)
                
                ControlGroup {
                    Button("Done", action: done)
                        .prominent()
                        .disabled(name.isEmpty)
                    Button("Move") { mode = .move }
                    Button("Copy") { mode = .copy }
                    Button("Cancel") { dismiss() }
                }
                .buttonStyle(MyButtonStyle())
                .controlGroupStyle(.navigation)
            }
        }
        
        .sheet(isPresented: $openImagePicker) {
            ImagePicker(sourceType: sourceType, image: $image)
        }
        
        .sheet(isPresented: $openBarScanner) {
            CodeScannerView(
                codeTypes: [.ean8, .ean13, .upce],
                simulatedData: "product info goes here",
                completion: handleBarScan
            )
        }
        
        .sheet(isPresented: $openQRScanner) {
            ZStack {
                CodeScannerView(
                    codeTypes: [.qr],
                    simulatedData: "https://apple.com",
                    completion: handleQRScan
                )
                Button("Cancel") {
                    openQRScanner = false
                }.buttonStyle(.borderedProminent)
            }
        }
    }
}
