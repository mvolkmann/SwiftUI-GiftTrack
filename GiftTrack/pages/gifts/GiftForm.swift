// Everything related to bar code and QR scanning is commented out.
// It works, but it is not free to use.
//import CodeScanner

import CoreLocation
import MapKit
import SwiftUI

struct GiftForm: View {
    @Environment(\.managedObjectContext) var moc
    
    //@State private var barScanError = ""
    // Core Data won't allow an attribute to be named "description".
    @State private var desc = ""
    @State private var edit = false
    @State private var image: UIImage? = nil
    @State private var imageUrl = ""
    @State private var latitude = 0.0
    @State private var location = ""
    @State private var longitude = 0.0
    @State private var message = ""
    @State private var name = ""
    //@State private var openBarScanner = false
    //@State private var openQRScanner = false
    @State private var price = NumbersOnly(0)
    @State private var purchased = false
    @State private var region: MKCoordinateRegion = MKCoordinateRegion()
    @State private var qrScanError = ""
    //@State private var showBarScanError = false
    @State private var showMessage = false
    //@State private var showQRScanError = false
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
    
    /*
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
    */
    
    func loadProductData(productCode: String) {
        // This uses the UPC Database API at https://upcdatabase.org/api.
        let key = Bundle.main.object(
            forInfoDictionaryKey: "UPC_DATABASE_KEY"
        ) as? String
        let url = "https://api.upcdatabase.org/product/" +
            productCode + "?apikey=\(key!)"
        
        Task(priority: .medium) {
            do {
                let product = try await HttpUtil.get(
                    from: url,
                    type: Product.self
                ) as Product
                DispatchQueue.main.async {
                    self.name = product.title
                    self.desc = product.category
                    if let images = product.images {
                        if images.count > 0 {
                            if let imageUrl = images.first {
                                self.imageUrl = imageUrl
                            }
                        } else {
                            print("no images")
                        }
                    }
                }
            } catch {
                message = error.localizedDescription
                showMessage = true
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
                /*
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
                    .alert(
                        "Barcode Lookup Failed",
                        isPresented: $showMessage,
                        actions: {}, // no custom buttons
                        message: { Text(message) }
                    )
                }
                */
                
                MyTextField("Name", text: $name, edit: edit)
                MyTextField("Description", text: $desc, edit: edit)
                
                if edit || price.value != "0" {
                    MyTextField(
                        "Price",
                        text: $price.value,
                        edit: edit,
                        autocorrect: false,
                        keyboard: .decimalPad
                    )
                }
                MyToggle("Purchased?", isOn: $purchased, edit: edit)
                
                if edit || !url.isEmpty {
                    HStack {
                        MyURL("Website URL", url: $url, edit: edit)
                        /*
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
                        */
                    }
                }
                
                Group {
                    MyPhoto("Photo", image: $image, edit: edit)
                    if edit || !imageUrl.isEmpty {
                        MyImageURL("Image URL", url: $imageUrl, edit: edit)
                    }
                }
            
                if edit || !location.isEmpty {
                    MyTextField("Location", text: $location, edit: edit)
                }
                
                if edit || (latitude != 0.0 || longitude != 0.0) {
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
        
        /*
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
        */
    }
}
