import CodeScanner
import CoreLocation
import MapKit
import SwiftUI

struct GiftForm: View {
    @Environment(\.managedObjectContext) var moc
    
    @State private var barScanError = ""
    // Core Data won't allow an attribute to be named "description".
    @State private var desc = ""
    @State private var edit = false
    @State private var image: UIImage? = nil
    @State private var imageUrl = ""
    @State private var latitude = 0.0
    @State private var location = ""
    @State private var longitude = 0.0
    @State private var name = ""
    @State private var openBarScanner = false
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
        _edit = State(initialValue: mode.wrappedValue == GiftMode.add)
        
        if let gift = gift {
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
        }
    }
    
    func clearLocation() {
        latitude = 0
        longitude = 0
        location = ""
    }
    
    func handleBarScan(result: Result<String, CodeScannerView.ScanError>) {
        self.openBarScanner = false
        
        switch result {
        case .success(let code):
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
                //print("products =", products)
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
    
    func save() {
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
    }
    
    var body: some View {
        Page {
            Form {
                if edit {
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
                }
                
                MyTextField("Name", text: $name, edit: edit)
                MyTextField("Description", text: $desc, edit: edit)
                
                MyTextField("Price", text: $price.value, edit: edit)
                MyToggle("Purchased?", isOn: $purchased, edit: edit)
                
                HStack {
                    MyURL("Website URL", url: $url, edit: edit)
                    if edit {
                        Spacer()
                        IconButton(icon: "qrcode") { openQRScanner = true }
                            .alert(
                                "QR Code Scan Failed",
                                isPresented: $showQRScanError,
                                actions: {}, // no custom buttons
                                message: { Text(qrScanError) }
                            )
                    }
                }
                
                Group {
                    MyPhoto("Photo", image: $image, edit: edit)
                    MyImageURL("Image URL", url: $imageUrl, edit: edit)
                }
            
                Group {
                    MyTextField("Location", text: $location, edit: edit)
                    MyMap(
                        latitude: $latitude,
                        longitude: $longitude,
                        edit: edit
                    )
                }
                
                ControlGroup {
                    Button("Move") { mode = .move }
                    Button("Copy") { mode = .copy }
                }
                .buttonStyle(MyButtonStyle())
                .controlGroupStyle(.navigation)
            }
        }
        
        .navigationBarItems(
            trailing: Button(edit ? "Done" : "Edit") {
                if edit { save() }
                edit = !edit
            }
        )
        
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
