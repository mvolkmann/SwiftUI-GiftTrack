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

    @State var gifts: [GiftEntity] = []
    @State var occasionIndex = 0
    @State var personIndex = 0

    private var occasion: OccasionEntity? { occasions[occasionIndex] }
    private var person: PersonEntity? { people[personIndex] }

    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                // Page {
                VStack(alignment: .leading, spacing: 0) {
                    // See MenuPicker.swift which attempts to generalize this.
                    HStack(spacing: 0) {
                        VStack(spacing: 0) {
                            Text("Person").font(.title2)
                            Picker("Person", selection: $personIndex) {
                                ForEach(people.indices) { index in
                                    Text(people[index].name ?? "").tag(index)
                                }
                            }
                            .padding()
                            // .pickerStyle(.menu)
                            .pickerStyle(.wheel)
                        }
                        .frame(maxWidth: geometry.size.width / 2)
                        VStack(spacing: 0) {
                            Text("Occasion").font(.title2)
                            Picker("Occasion", selection: $occasionIndex) {
                                ForEach(occasions.indices) { index in
                                    Text(occasions[index].name ?? "").tag(index)
                                }
                            }
                            .padding()
                            .pickerStyle(.wheel)
                        }
                        .frame(maxWidth: geometry.size.width / 2)
                    }
                    GiftsList(person: person, occasion: occasion)
                    /*
                     Button("Show Report") {
                         print("Show Report is not implemented yet")
                     }
                     .buttonStyle(.bordered)
                     .padding()
                     */
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    EditButton()
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink("Add", destination: GiftAdd())
                }
            }
            .navigationTitle("Gifts")
        }
    }
}
