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
    
    @State private var mode = GiftMode.update
    @State private var occasionIndex = 0
    @State private var personIndex = 0
    
    // TODO: Why does removing this line cause
    // TODO: "Failed to produce diagnostic for expression"?
    private let padding: CGFloat = 15
    private let pickerHeight: CGFloat = 200
    private let textHeight: CGFloat = 30
    
    var gift: GiftEntity
    
    init(personIndex: Int, occasionIndex: Int, gift: GiftEntity) {
        _personIndex = State(initialValue: personIndex)
        _occasionIndex = State(initialValue: occasionIndex)
        self.gift = gift
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
    
    func move() {
        let newPerson = people[personIndex]
        let newOccasion = occasions[occasionIndex]
        gift.to = newPerson
        gift.reason = newOccasion
    }
    
    var body: some View {
        VStack {
            GiftForm(
                person: people[personIndex],
                occasion: occasions[occasionIndex],
                gift: gift,
                mode: $mode
            )
            
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
