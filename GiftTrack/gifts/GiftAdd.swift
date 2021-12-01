import CodeScanner
import SwiftUI

struct Product: Codable {
    var brand: String
    var category: String
    var description: String
    var images: [String]
    var manufacturer: String
    var title: String
}

struct Products: Codable {
    var products: [Product]
}

struct GiftAdd: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.managedObjectContext) var moc

    // Core Data won't allow an attribute to be named "description".
    @State private var barScanError = ""
    @State private var desc = ""
    @State private var image: UIImage? = nil
    @State private var imageUrl: String? = nil
    @State private var showBarScanError = false
    @State private var showQRScanError = false
    @State private var location = ""
    @State private var name = ""
    @State private var openBarScanner = false
    @State private var openImagePicker = false
    @State private var openQRScanner = false
    @State private var purchased = false
    @State private var price = NumbersOnly(0)
    @State private var qrScanError = ""
    @State private var sourceType: UIImagePickerController.SourceType = .camera
    @State private var url = ""

    var person: PersonEntity?
    var occasion: OccasionEntity?

    func add() {
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

        PersistenceController.shared.save()
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

    var body: some View {
        Page {
            Form {
                HStack {
                    Text("Bar Code Scan")
                    Button(action: { openBarScanner = true }) {
                        Image(systemName: "barcode").size(Settings.iconSize)
                    }
                    // This fixes the bug with multiple buttons in a Form.
                    .buttonStyle(.borderless)
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
                    Button(action: { openQRScanner = true }) {
                        Image(systemName: "qrcode").size(Settings.iconSize)
                    }
                    // This fixes the bug with multiple buttons in a Form.
                    .buttonStyle(.borderless)
                }
                .alert(
                    "QR Code Scan Failed",
                    isPresented: $showQRScanError,
                    actions: {}, // no custom buttons
                    message: { Text(qrScanError) }
                )
                
                HStack {
                    Button(action: {
                        sourceType = .camera
                        openImagePicker = true
                    }) {
                        Image(systemName: "camera").size(Settings.iconSize)
                    }

                    Button(action: {
                        sourceType = .photoLibrary
                        openImagePicker = true
                    }) {
                        Image(systemName: "photo.on.rectangle.angled")
                            .size(30)
                    }

                    if let image = image {
                        Image(uiImage: image).square(size: Settings.imageSize)
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
                

                ControlGroup {
                    Button("Add") {
                        add()
                        desc = ""
                        location = ""
                        name = ""
                        // price = ""
                        url = ""
                        dismiss()
                    }
                    .prominent()
                    .disabled(name.isEmpty)
                    Button("Cancel", action: { dismiss() })
                }
                .buttonStyle(MyButtonStyle())
                .controlGroupStyle(.navigation)
            }
        }
        
        // When this sheet is dismissed,
        // the openImagePicker binding is set to false.
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
