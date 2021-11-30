import SwiftUI

struct GiftAdd: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.managedObjectContext) var moc

    // Core Data won't allow an attribute to be named "description".
    @State private var desc = ""
    @State private var image: UIImage? = nil
    @State private var location = ""
    @State private var name = ""
    @State private var needImage = false
    @State private var purchased = false
    @State private var price = NumbersOnly(0)
    @State private var url = ""

    var person: PersonEntity?
    var occasion: OccasionEntity?

    func add() {
        let gift = GiftEntity(context: moc)
        gift.desc = desc.trim()
        gift.image = image?.jpegData(compressionQuality: 1.0)
        gift.location = location.trim()
        gift.name = name.trim()
        gift.price = Int64(Int(price.value)!)
        gift.purchased = purchased
        gift.url = URL(string: url.trim())

        gift.to = person
        gift.reason = occasion

        PersistenceController.shared.save()
    }

    var body: some View {
        Page {
            Form {
                TextField("Name", text: $name)
                    .autocapitalization(.none)
                TextField("Description", text: $desc)
                    .autocapitalization(.none)
                TextField("Location", text: $location)
                    .autocapitalization(.none)
                TextField("Price", text: $price.value)
                    .keyboardType(.decimalPad)
                Toggle("Purchased?", isOn: $purchased)
                TextField("URL", text: $url)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)

                HStack {
                    Button(
                        action: { needImage = true },
                        label: {
                            Image(systemName: "camera").font(.system(size: 30))
                        }
                    )
                    if let image = image {
                        Image(uiImage: image).square(size: 100)
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
        // the needImage binding is set to false.
        .sheet(isPresented: $needImage) {
            ImagePicker(sourceType: .camera, image: $image)
        }
    }
}
