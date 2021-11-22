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

    @State var occasion: OccasionEntity? = nil
    @State var person: PersonEntity? = nil

    private func addGift() {
        print("GiftsView addGift: entered")
    }

    var body: some View {
        NavigationView {
            // Page {
            GeometryReader { geometry in
                VStack(alignment: .leading, spacing: 0) {
                    // See MenuPicker.swift which attempts to generalize this.
                    HStack(spacing: 0) {
                        VStack(spacing: 0) {
                            Text("Person").font(.title2)
                            Picker("Person", selection: $person) {
                                ForEach(people, id: \.self) { person in
                                    Text(person.name ?? "").tag(person)
                                }
                            }
                            .padding()
                            .pickerStyle(.menu)
                        }
                        .frame(maxWidth: geometry.size.width / 2)
                        VStack(spacing: 0) {
                            Text("Occasion").font(.title2)
                            Picker("Occasion", selection: $occasion) {
                                ForEach(occasions, id: \.self) { occasion in
                                    Text(occasion.name ?? "").tag(occasion)
                                }
                            }
                            .padding()
                            .pickerStyle(.menu)
                        }
                        .frame(maxWidth: geometry.size.width / 3)
                    }
                    // .border(.red)

                    Button(action: addGift) {
                        Image(systemName: "plus").font(.system(size: 24))
                    }.padding()

                    Button("Show Report") {
                        print("Show Report is not implemented yet")
                    }
                    .buttonStyle(.bordered)
                    .padding()

                    Spacer()
                }
            }
            // List {}
            // }
            .navigationTitle("Gifts")
        }
    }
}
