import SwiftUI

struct GiftUpdate: View {
    @Environment(\.dismiss) var dismiss
    
    private enum Mode {
        case edit, copy, move
    }
    
    // Core Data won't allow an attribute to be named "description".
    @State private var desc = ""
    @State private var location = ""
    @State private var mode = Mode.edit
    @State private var name = ""
    @State private var price = NumbersOnly(0)
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
        _price = State(initialValue: NumbersOnly(gift.price))
        _url = State(initialValue: gift.url?.absoluteString ?? "")
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
                    Button("Done") {
                        gift.desc = desc.trim()
                        gift.location = location.trim()
                        gift.name = name.trim()
                        gift.price = Int64(Int(price.value)!)
                        gift.url = URL(string: url.trim())
                        PersistenceController.shared.save()
                        dismiss()
                    }
                    .prominent()
                    .disabled(name.isEmpty)
                    Button("Copy") { mode = .copy }
                    Button("Move") { mode = .move }
                    Button("Cancel") { dismiss() }
                }.controlGroupStyle(.navigation)
                
                if mode == .copy {
                    Text("in copy mode")
                    Button("Done") { mode = .edit }
                }
                if mode == .move {
                    Text("in move mode")
                    Button("Done") { mode = .edit }
                }
            }
        }
    }
}
