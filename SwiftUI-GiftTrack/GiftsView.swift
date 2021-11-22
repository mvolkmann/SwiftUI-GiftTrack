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
    @State var occasion: OccasionEntity? = nil
    @State var person: PersonEntity? = nil

    init() {
        fetchGifts()
    }

    private func delete(indexSet: IndexSet) {
        for index in indexSet {
            moc.delete(people[index])
        }
        PersistenceController.shared.save()
    }

    private func fetchGifts() {
        let request = NSFetchRequest<GiftEntity>(entityName: "GiftEntity")
        request.sortDescriptors = [
            NSSortDescriptor(key: "name", ascending: true)
        ]
        request.predicate = NSPredicate(
            format: "to.name == %@ and reason.name == %@",
            person?.name ?? "",
            occasion?.name ?? ""
        )
        do {
            // gifts here must be the name of the
            // @Published property declared above.
            gifts = try moc.fetch(request)
        } catch {
            print("fetchGifts error:", error.localizedDescription)
        }
    }

    var body: some View {
        NavigationView {
            // Page {
            VStack(alignment: .leading, spacing: 0) {
                // See MenuPicker.swift which attempts to generalize this.
                GeometryReader { geometry in
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
                }

                Button("Show Report") {
                    print("Show Report is not implemented yet")
                }
                .buttonStyle(.bordered)
                .padding()

                List {
                    ForEach(gifts, id: \.self) { gift in
                        NavigationLink(
                            destination: GiftUpdate(gift: gift)
                        ) {
                            HStack {
                                Text(gift.name ?? "")
                                // Show more gift properties here?
                            }
                        }
                    }
                    .onDelete(perform: delete)
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
