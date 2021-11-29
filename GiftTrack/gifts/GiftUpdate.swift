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
    
    // Core Data won't allow an attribute to be named "description".
    @State private var desc = ""
    @State private var location = ""
    @State private var mode = Mode.update
    @State private var name = ""
    @State private var purchased = false
    @State private var occasionIndex = 0
    @State private var personIndex = 0
    @State private var price = NumbersOnly(0)
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
        _location = State(initialValue: gift.location ?? "")
        _name = State(initialValue: gift.name ?? "")
        _occasionIndex = State(initialValue: occasionIndex)
        _personIndex = State(initialValue: personIndex)
        _purchased = State(initialValue: gift.purchased)
        _price = State(initialValue: NumbersOnly(gift.price))
        _url = State(initialValue: gift.url?.absoluteString ?? "")
    }
    
    func copy() {
        let newGift = GiftEntity(context: moc)
        newGift.name = gift.name
        newGift.desc = gift.desc
        newGift.location = gift.location
        newGift.price = gift.price
        newGift.purchased = gift.purchased
        newGift.url = gift.url
        newGift.to = people[personIndex]
        newGift.reason = occasions[occasionIndex]
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
                ControlGroup {
                    Button("Done") {
                        gift.desc = desc.trim()
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
    }
}
