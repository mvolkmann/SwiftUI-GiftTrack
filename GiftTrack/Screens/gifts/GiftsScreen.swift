import CoreData
import SwiftUI

struct GiftsScreen: View {
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

    @State private var occasionIndex = 0
    @State private var personIndex = 0

    private let padding: CGFloat = 15
    private let pickerHeight: CGFloat = 200
    private let textHeight: CGFloat = 30

    private var occasion: OccasionEntity? {
        occasions.isEmpty ? nil : occasions[occasionIndex]
    }

    private var person: PersonEntity? {
        people.isEmpty ? nil : people[personIndex]
    }

    func pickerWidth(_ geometry: GeometryProxy) -> CGFloat {
        let width = geometry.size.width
        return width == 0 ? 0 : (width - padding * 3) / 2
    }

    var body: some View {
        NavigationView {
            GeometryReader { _ in
                Screen {
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
                    .padding(.top)

                    GiftsList(
                        person: person,
                        personIndex: personIndex,
                        occasion: occasion,
                        occasionIndex: occasionIndex
                    )
                }
            }
            .toolbar {
                /*
                ToolbarItem(placement: .navigationBarLeading) {
                    EditButton()
                }
                */
                ToolbarItem(placement: .navigationBarTrailing) {
                    if person != nil && occasion != nil {
                        NavigationLink(
                            "Add",
                            destination: GiftAdd(
                                // A person and occasion are always selected,
                                // so these force unwraps are safe.
                                person: person!,
                                occasion: occasion!
                            )
                        )
                        .navigationBarTitleDisplayMode(.inline)
                    }
                }
            }
            .navigationBarTitle("Gifts")
        }
    }
}
