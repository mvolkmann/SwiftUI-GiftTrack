import CodeScanner
import SwiftUI

struct GiftUpdate: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.managedObjectContext) var moc
    
    @FetchRequest(
        entity: OccasionEntity.entity(),
        sortDescriptors: [
            NSSortDescriptor(key: "name", ascending: true)
        ]
    ) var occasions: FetchedResults<OccasionEntity>

    @FetchRequest(
        entity: PersonEntity.entity(),
        sortDescriptors: [
            NSSortDescriptor(key: "name", ascending: true)
        ]
    ) var people: FetchedResults<PersonEntity>
    
    enum Mode {
        case copy, move, update
    }
    
    @State private var barScanError = ""
    // Core Data won't allow an attribute to be named "description".
    @State private var desc = ""
    @State private var image: UIImage? = nil
    @State private var imageUrl = ""
    @State private var location = ""
    @State private var mode = Mode.update
    @State private var name = ""
    @State private var openImagePicker = false
    @State private var purchased = false
    @State private var occasionIndex = 0
    @State private var openBarScanner = false
    @State private var openQRScanner = false
    @State private var personIndex = 0
    @State private var price = NumbersOnly(0)
    @State private var qrScanError = ""
    @State private var showBarScanError = false
    @State private var showQRScanError = false
    @State private var sourceType: UIImagePickerController.SourceType = .camera
    @State private var url = ""
    
    // TODO: Why does removing this line cause
    // TODO: "Failed to produce diagnostic for expression"?
    private let padding: CGFloat = 15
    private let pickerHeight: CGFloat = 200
    private let textHeight: CGFloat = 30
    
    private var gift: GiftEntity
    
    init(personIndex: Int, occasionIndex: Int, gift: GiftEntity) {
        self.gift = gift
        
        // Preceding these property names with an underscore causes it
        // to refer to the underlying value of the binding
        // rather than the binding itself.
        // This is required to set the value of an @State property.
        _desc = State(initialValue: gift.desc ?? "")
        _imageUrl = State(initialValue: gift.imageUrl ?? "")
        _location = State(initialValue: gift.location ?? "")
        _name = State(initialValue: gift.name ?? "")
        _occasionIndex = State(initialValue: occasionIndex)
        _personIndex = State(initialValue: personIndex)
        _purchased = State(initialValue: gift.purchased)
        _price = State(initialValue: NumbersOnly(gift.price))
        _url = State(initialValue: gift.url?.absoluteString ?? "")
        
        if let data = gift.image {
            _image = State(initialValue: UIImage(data: data))
        }
    }
    
    func copy() {
        let newGift = GiftEntity(context: moc)
        newGift.name = gift.name
        newGift.desc = gift.desc
        newGift.image = gift.image
        newGift.location = gift.location
        newGift.price = gift.price
        newGift.purchased = gift.purchased
        newGift.url = gift.url
        newGift.to = people[personIndex]
        newGift.reason = occasions[occasionIndex]
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
    
    func move() {
        let newPerson = people[personIndex]
        let newOccasion = occasions[occasionIndex]
        gift.to = newPerson
        gift.reason = newOccasion
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
                
                Group {
                TextField("Name", text: $name)
                    .autocapitalization(.none)
                TextField("Description", text: $desc)
                    .autocapitalization(.none)
                TextField("Location", text: $location)
                    .autocapitalization(.none)
                TextField("Price", text: $price.value)
                    .keyboardType(.decimalPad)
                Toggle("Purchased?", isOn: $purchased)
                }
                
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
                    Button("Done") {
                        gift.desc = desc.trim()
                        gift.image = image?.jpegData(compressionQuality: 1.0)
                        gift.location = location.trim()
                        gift.name = name.trim()
                        gift.price = Int64(Int(price.value)!)
                        gift.purchased = purchased
                        gift.url = URL(string: url.trim())
                        PersistenceController.shared.save()
                        dismiss()
                    }
                    .prominent()
                    .disabled(name.isEmpty)
                    
                    Button("Move") { mode = .move }
                    Button("Copy") { mode = .copy }
                    
                    Button("Cancel") { dismiss() }
                }
                .buttonStyle(MyButtonStyle())
                .controlGroupStyle(.navigation)
                
                if mode != .update {
                    HStack(spacing: padding) {
                        TitledWheelPicker(
                            title: "Person",
                            options: people,
                            property: "name",
                            selectedIndex: $personIndex
                        )
                        TitledWheelPicker(
                            title: "Occasion",
                            options: occasions,
                            property: "name",
                            selectedIndex: $occasionIndex
                        )
                    }
                    .frame(height: pickerHeight + textHeight)
                    
                    HStack {
                        Button(mode == .move ? "Move" : "Copy") {
                            if mode == .move {
                                move()
                            } else {
                                copy()
                            }
                            PersistenceController.shared.save()
                            dismiss()
                        }
                        Button("Close") { mode = .update }
                    }
                    .buttonStyle(MyButtonStyle())
                }
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
