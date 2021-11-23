import SwiftUI

struct GiftAdd: View {
    @Environment(\.managedObjectContext) var moc
    @Environment(\.presentationMode) var presentationMode

    // Core Data won't allow an attribute to be named "description".
    @State private var desc = ""
    @State private var location = ""
    @State private var name = ""
    @State private var price: Int = 0
    @State private var url = ""

    var person: PersonEntity?
    var occasion: OccasionEntity?

    func add() {
        let gift = GiftEntity(context: moc)
        gift.desc = desc
        gift.location = location
        gift.name = name
        gift.price = Int64(price)
        gift.url = URL(string: url)

        // TODO: Why aren't these relationship methods being generated by Core Data?
        // gift.addToPerson(person)
        // gift.addToOccasion(occasion)

        // This approach works!
        //person?.addToGifts(gift)
        //occasion?.addToGifts(gift)

        // This also works!
        gift.to = person
        gift.reason = occasion

        PersistenceController.shared.save()
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
                Button("Add") {
                    add()
                    desc = ""
                    location = ""
                    name = ""
                    price = 0
                    url = ""
                    back()
                }
                .buttonStyle(.borderedProminent)
                .disabled(name.isEmpty)
                Button("Cancel", action: back).buttonStyle(.bordered)
            }.controlGroupStyle(.navigation)
        }
    }
}
