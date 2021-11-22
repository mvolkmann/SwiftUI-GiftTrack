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

    var body: some View {
        NavigationView {
            // Page {
            VStack {
                VStack {
                    Text("Person").font(.title2)
                    Picker("Person", selection: $person) {
                        ForEach(people, id: \.self) { person in
                            Text(person.name ?? "").tag(person)
                        }
                    }.pickerStyle(.wheel)
                }
                VStack {
                    Text("Occasion").font(.title2)
                    Picker("Occasion", selection: $occasion) {
                        ForEach(occasions, id: \.self) { occasion in
                            Text(occasion.name ?? "").tag(occasion)
                        }
                    }.pickerStyle(.wheel)
                }
                Spacer()
            }
            // List {}
            // }
            .navigationTitle("Gifts")
        }
    }
}
