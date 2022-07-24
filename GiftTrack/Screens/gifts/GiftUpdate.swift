import SwiftUI

struct GiftUpdate: View {
    // MARK: - State

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

    @State private var mode = GiftMode.update
    @State private var occasionIndex = 0
    @State private var personIndex = 0

    // MARK: - Initializer

    init(personIndex: Int, occasionIndex: Int, gift: GiftEntity) {
        _personIndex = State(initialValue: personIndex)
        _occasionIndex = State(initialValue: occasionIndex)
        self.gift = gift
    }

    // MARK: - Constants

    private let pickerHeight = 200.0
    private let textHeight = 30.0

    // MARK: - Properties

    private var gift: GiftEntity

    var body: some View {
        VStack {
            GiftForm(
                person: people[personIndex],
                occasion: occasions[occasionIndex],
                gift: gift,
                mode: $mode
            )

            if mode != .update {
                HStack(spacing: 15) {
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

    // MARK: - Methods

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

    func move() {
        let newPerson = people[personIndex]
        let newOccasion = occasions[occasionIndex]
        gift.to = newPerson
        gift.reason = newOccasion
    }
}
