import CoreData
import SwiftUI

struct GiftsView: View {
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

    @State var occasionIndex = 0
    @State var personIndex = 0

    private var occasion: OccasionEntity? {
        occasions.isEmpty ? nil : occasions[occasionIndex]
    }

    private var person: PersonEntity? {
        people.isEmpty ? nil : people[personIndex]
    }

    func pickerWidth(_ geometry: GeometryProxy) -> CGFloat {
        min(170, geometry.size.width / 2)
    }

    init() {
        configureNavigationTitle()
    }

    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                Page {
                    // See MenuPicker.swift which attempts to generalize this.
                    HStack(spacing: 0) {
                        VStack(spacing: 0) {
                            Text("Person")
                                .font(.title2)
                                .foregroundColor(titleColor)
                            Picker("Person", selection: $personIndex) {
                                ForEach(people.indices) { index in
                                    Text(name(people[index])).tag(index)
                                        .foregroundColor(textColor)
                                }
                            }
                            .pickerStyle(.wheel)
                            .padding(.vertical, -10)
                        }
                        .frame(maxWidth: pickerWidth(geometry))

                        VStack(spacing: 0) {
                            Text("Occasion")
                                .font(.title2)
                                .foregroundColor(titleColor)
                            Picker("Occasion", selection: $occasionIndex) {
                                ForEach(occasions.indices) { index in
                                    Text(name(occasions[index])).tag(index)
                                        .foregroundColor(textColor)
                                }
                            }
                            .pickerStyle(.wheel)
                            .padding(.vertical, -10)
                        }
                        .frame(maxWidth: pickerWidth(geometry))
                    }
                    GiftsList(person: person, occasion: occasion)
                    Spacer()
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    EditButton()
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(
                        "Add",
                        destination: GiftAdd(person: person, occasion: occasion)
                    )
                }
            }
            .navigationTitle("Gifts")
            .accentColor(titleColor) // navigation links color
        }
        .accentColor(titleColor) // navigation back link color
    }
}
