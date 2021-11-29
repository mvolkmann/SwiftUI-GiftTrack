import SwiftUI

struct GiftAdd: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.managedObjectContext) var moc

    // Core Data won't allow an attribute to be named "description".
    @State private var desc = ""
    @State private var location = ""
    @State private var name = ""
    @State private var price = NumbersOnly(0)
    @State private var url = ""

    var person: PersonEntity?
    var occasion: OccasionEntity?

    func add() {
        let gift = GiftEntity(context: moc)
        gift.desc = desc.trim()
        gift.location = location.trim()
        gift.name = name.trim()
        gift.price = Int64(Int(price.value)!)
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
                TextField("URL", text: $url)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
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
    }
}
