import CodeScanner
import SwiftUI

struct GiftForm: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.managedObjectContext) var moc
    
    @State private var barScanError = ""
    // Core Data won't allow an attribute to be named "description".
    @State private var desc = ""
    @State private var image: UIImage? = nil
    @State private var imageUrl = ""
    @State private var location = ""
    @State private var name = ""
    @State private var openBarScanner = false
    @State private var openImagePicker = false
    @State private var openQRScanner = false
    @State private var price = NumbersOnly(0)
    @State private var purchased = false
    @State private var qrScanError = ""
    @State private var showBarScanError = false
    @State private var showQRScanError = false
    @State private var sourceType: UIImagePickerController.SourceType = .camera
    @State private var url = ""
    
    private let person: PersonEntity
    private let occasion: OccasionEntity
    private var gift: GiftEntity?
    
    init(
        person: PersonEntity,
        occasion: OccasionEntity,
        gift: GiftEntity? = nil
    ) {
        //TODO: Why is this called 4 times when an existing gift is tapped?
        self.person = person
        self.occasion = occasion
        self.gift = gift
        
        print("person name =", person.name ?? "no name")
        print("occasion name =", occasion.name ?? "no name")
        
        if let gift = gift {
            print("gift name =", gift.name ?? "no name")
            
            // Preceding these property names with an underscore causes it
            // to refer to the underlying value of the binding
            // rather than the binding itself.
            // This is required to set the value of an @State property.
            _desc = State(initialValue: gift.desc ?? "")
            _imageUrl = State(initialValue: gift.imageUrl ?? "")
            _location = State(initialValue: gift.location ?? "")
            _name = State(initialValue: gift.name ?? "")
            _purchased = State(initialValue: gift.purchased)
            _price = State(initialValue: NumbersOnly(gift.price))
            _url = State(initialValue: gift.url?.absoluteString ?? "")
            
            if let data = gift.image {
                _image = State(initialValue: UIImage(data: data))
            }
        }
    }
    
    func done() {
        if let gift = gift {
            // Update an existing gift.
            gift.desc = desc.trim()
            gift.image = image?.jpegData(compressionQuality: 1.0)
            gift.location = location.trim()
            gift.name = name.trim()
            gift.price = Int64(Int(price.value)!)
            gift.purchased = purchased
            gift.url = URL(string: url.trim())
        } else {
            // Add a new gift.
            let gift = GiftEntity(context: moc)
            gift.desc = desc.trim()
            gift.image = image?.jpegData(compressionQuality: 1.0)
            gift.imageUrl = imageUrl
            gift.location = location.trim()
            gift.name = name.trim()
            gift.price = Int64(Int(price.value)!)
            gift.purchased = purchased
            gift.url = URL(string: url.trim())
            
            gift.to = person
            gift.reason = occasion
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
        print("url =", url)
        
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
            } catch {
                print("error =", error.localizedDescription)
            }
        }
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
                TextField("Location", text: $location)
                    .autocapitalization(.none)
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
