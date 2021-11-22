import SwiftUI

struct GiftUpdate: View {
    @Environment(\.presentationMode) var presentationMode
    
    // Core Data won't allow an attribute to be named "description".
    @State private var desc = ""
    @State private var location = ""
    @State private var name = ""
    @State private var price: Int = 0
    @State private var url = ""
    
    var gift: GiftEntity
    
    init(gift: GiftEntity) {
        self.gift = gift
        // Preceding these property names with an underscore causes it
        // to refer to the underlying value of the binding
        // rather than the binding itself.
        // This is required to set the value of an @State property.
        _desc = State(initialValue: gift.desc ?? "")
        _location = State(initialValue: gift.location ?? "")
        _name = State(initialValue: gift.name ?? "")
        _price = State(initialValue: Int(gift.price))
        _url = State(initialValue: gift.url?.absoluteString ?? "")
    }
    
    func back() {
        presentationMode.wrappedValue.dismiss()
    }
    
    var body: some View {
        Form {
            TextField("Name", text: $name)
                .autocapitalization(.none)
            TextField("Description", text: $desc)
                .autocapitalization(.none)
            TextField("Location", text: $location)
                .autocapitalization(.none)
            TextField("Price", value: $price, format: .number)
            TextField("URL", text: $url)
                .autocapitalization(.none)
                .disableAutocorrection(true)
            ControlGroup {
                Button("Done") {
                    gift.desc = desc
                    gift.location = location
                    gift.name = name
                    gift.price = Int64(price)
                    gift.url = URL(string: url)
                    PersistenceController.shared.save()
                    back()
                }
                .buttonStyle(.borderedProminent)
                .disabled(name.isEmpty)
                Button("Cancel", action: back).buttonStyle(.bordered)
            }.controlGroupStyle(.navigation)
        }
    }
}
