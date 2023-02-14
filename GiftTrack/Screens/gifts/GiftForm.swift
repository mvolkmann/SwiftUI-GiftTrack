// Everything related to bar code and QR scanning is commented out.
// It works, but it is not free to use.
// import CodeScanner

import CoreLocation
import MapKit
import SwiftUI

struct GiftForm: View {
    // MARK: - State

    @Environment(\.managedObjectContext) var moc

    @FocusState private var focus: AnyKeyPath?

    // @State private var barScanError = ""
    // Core Data won't allow an attribute to be named "description".
    @State private var desc = ""
    @State private var edit = false
    @State private var image: UIImage?
    @State private var imageUrl = ""
    @State private var latitude = 0.0
    @State private var location = ""
    @State private var longitude = 0.0
    @State private var message = ""
    @State private var name = ""
    // @State private var openBarScanner = false
    // @State private var openQRScanner = false
    @State private var price = ""
    @State private var purchased = false
    @State private var region: MKCoordinateRegion = .init()
    // @State private var qrScanError = ""
    // @State private var showBarScanError = false
    @State private var showMessage = false
    // @State private var showQRScanError = false
    @State private var sourceType: UIImagePickerController.SourceType = .camera
    @State private var websiteUrl = ""

    @Binding var mode: GiftMode

    // MARK: - Constants

    private let SPAN = MKCoordinateSpan(
        latitudeDelta: 0.005,
        longitudeDelta: 0.005
    )

    // MARK: - Initializer

    init(
        person: PersonEntity,
        occasion: OccasionEntity,
        gift: GiftEntity? = nil,
        mode: Binding<GiftMode>
    ) {
        // TODO: Why is this called 4 times when an existing gift is tapped?
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
            _price = State(initialValue: gift.price ?? "")
            _websiteUrl = State(initialValue: gift.url?.absoluteString ?? "")

            if let data = gift.image {
                _image = State(initialValue: UIImage(data: data))
            }
        }
    }

    // MARK: - Properties

    private let person: PersonEntity
    private let occasion: OccasionEntity
    private var gift: GiftEntity?

    private var barCodeView: some View {
        /*
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
         */
        EmptyView()
    }

    /*
     private var qrCodeView: some View {
          IconButton(icon: "qrcode") { openQRScanner = true }
              .alert(
                  "QR Code Scan Failed",
                  isPresented: $showQRScanError,
                  actions: {}, // no custom buttons
                  message: { Text(qrScanError) }
              )
     }
     */

    var body: some View {
        Screen {
            MyTitle(
                "\(occasion.name!) gift for \(person.name!)",
                small: true,
                pad: true
            )

            Form {
                // if edit { barCodeView }

                MyTextField(
                    "Gift Name",
                    text: $name,
                    edit: edit,
                    onCommit: nextFocus
                )
                .focused($focus, equals: \Self.name)

                MyTextField(
                    "Description",
                    text: $desc,
                    edit: edit,
                    canDismissKeyboard: false,
                    onCommit: nextFocus
                )
                .focused($focus, equals: \Self.desc)

                MyTextField(
                    "Price",
                    text: $price,
                    valuePrefix: "$",
                    edit: edit,
                    autocorrect: false,
                    keyboard: .decimalPad,
                    canDismissKeyboard: false,
                    onCommit: nextFocus
                )
                .focused($focus, equals: \Self.price)
                .onChange(of: price) { _ in
                    price = formatPrice(price)
                }

                MyToggle("Purchased?", isOn: $purchased, edit: edit)

                if edit || !websiteUrl.isEmpty {
                    HStack {
                        MyURL(
                            "Website URL",
                            url: $websiteUrl,
                            edit: edit,
                            onCommit: nextFocus
                        ).focused($focus, equals: \Self.websiteUrl)

                        /*
                         if edit {
                             Spacer()
                             qrCodeView
                         }
                         */
                    }
                }

                Group {
                    MyPhoto("Photo", image: $image, edit: edit)
                    if edit || !imageUrl.isEmpty {
                        MyImageURL(
                            "Image URL",
                            url: $imageUrl,
                            edit: edit,
                            onCommit: nextFocus
                        )
                        .focused($focus, equals: \Self.imageUrl)
                    }
                }

                if edit || !location.isEmpty {
                    MyTextField(
                        "Location",
                        text: $location,
                        edit: edit,
                        canDismissKeyboard: false,
                        onCommit: nextFocus
                    )
                    .focused($focus, equals: \Self.location)
                }

                if edit || (latitude != 0.0 || longitude != 0.0) {
                    MyMap(
                        latitude: $latitude,
                        longitude: $longitude,
                        edit: edit
                    )
                }

                if mode == .update {
                    ControlGroup {
                        Button("Move") { mode = .move }
                        Button("Copy") { mode = .copy }
                    }
                    .buttonStyle(MyButtonStyle())
                    .controlGroupStyle(.navigation)
                }
            }
            .hideBackground() // defined in ViewExtension.swift
        }

        .navigationBarItems(
            trailing: Button(edit ? "Done" : "Edit") {
                price = fixDecimalPlaces(price)
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

    // MARK: - Methods

    private func clearLocation() {
        latitude = 0
        longitude = 0
        location = ""
    }

    private func fixDecimalPlaces(_ price: String) -> String {
        var text = price

        // If price ends with a period, remove it.
        if text.hasSuffix(".") {
            text = String(text.dropLast())
        }

        // If price ends with one decimal place,
        // add a zero so there are two decimal places.
        let parts = text.split(separator: ".")
        if parts.count == 2, parts[1].count == 1 {
            text += "0"
        }

        return text
    }

    private func formatPrice(_ price: String) -> String {
        // Remove all characters that are not a period or digit.
        var text = price.filter { char in char == "." || char.isNumber }

        // If begins with a period, add leading zero.
        if text.hasPrefix(".") { text = "0" + text }

        var parts = text.split(
            separator: ".",
            omittingEmptySubsequences: false
        )

        // If there is no decimal point, return.
        if parts.count < 2 { return text }

        // If the last character is a decimal point
        // and it is not the only decimal point,
        // remove the last part.
        if text.last == ".", parts.count > 2 {
            parts.removeLast()
        }

        // Re-form the price String
        // with a limit of two decimal places.
        return parts[0] + "." + parts[1].prefix(2)
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

     private func loadProductData(productCode: String) {
         // This uses the UPC Database API at https://upcdatabase.org/api.
         let key = Bundle.main.object(
             forInfoDictionaryKey: "UPC_DATABASE_KEY"
         ) as? String
         let url = "https://api.upcdatabase.org/product/" +
             productCode + "?apikey=\(key!)"

         Task(priority: .medium) {
             do {
                 let product = try await HTTPUtil.get(
                     from: url,
                     type: UPCProduct.self
                 ) as UPCProduct
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
     */

    private func save() {
        let adding = gift == nil
        let toSave = adding ? GiftEntity(context: moc) : gift!

        toSave.desc = desc.trim()
        toSave.image = image?.jpegData(compressionQuality: 1.0)
        toSave.imageUrl = imageUrl
        toSave.latitude = latitude
        toSave.location = location.trim()
        toSave.longitude = longitude
        toSave.name = name.trim()
        toSave.price = price
        toSave.purchased = purchased
        toSave.url = URL(string: websiteUrl.trim())

        if adding {
            toSave.to = person
            toSave.reason = occasion
        }

        PersistenceController.shared.save()
    }

    private func nextFocus() {
        switch focus {
        case \Self.name: focus = \Self.desc
        case \Self.desc: focus = \Self.price
        case \Self.price: focus = \Self.websiteUrl
        case \Self.websiteUrl: focus = \Self.imageUrl
        case \Self.imageUrl: focus = \Self.location
        case \Self.location: focus = \Self.name
        default: break
        }
    }
}
