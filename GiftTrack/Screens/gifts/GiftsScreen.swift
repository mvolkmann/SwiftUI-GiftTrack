import CoreData
import SwiftUI

struct GiftsScreen: View {
    // MARK: - State

    @AppStorage("titleColor") var titleColor: String = "Title"

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

    // MARK: - Constants

    private let padding: CGFloat = 15
    private let pickerHeight: CGFloat = 200
    private let textHeight: CGFloat = 30

    // MARK: - Properties

    private var occasion: OccasionEntity? {
        occasions.isEmpty ? nil : occasions[occasionIndex]
    }

    private var person: PersonEntity? {
        people.isEmpty ? nil : people[personIndex]
    }

    var body: some View {
        NavigationView {
            GeometryReader { _ in
                Screen(pad: true) {
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

                    GiftsList(
                        person: person,
                        personIndex: personIndex,
                        occasion: occasion,
                        occasionIndex: occasionIndex
                    )
                    .padding(.top, 5)
                    .padding(.bottom)
                    .padding(.horizontal, -20)
                }
            }
            .toolbar {
                /*
                 ToolbarItem(placement: .navigationBarLeading) {
                     EditButton()
                 }
                 */
                ToolbarItem(placement: .navigationBarTrailing) {
                    if person != nil, occasion != nil {
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
            .accentColor(Color.fromJSON(titleColor))
        }
    }

    // MARK: - Methods

    func pickerWidth(_ geometry: GeometryProxy) -> CGFloat {
        let width = geometry.size.width
        return width == 0 ? 0 : (width - padding * 3) / 2
    }
}
