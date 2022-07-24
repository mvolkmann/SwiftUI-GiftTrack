import SwiftUI

struct PeopleScreen: View {
    // MARK: - State

    @Environment(\.managedObjectContext) var moc
    @EnvironmentObject private var store: StoreKitStore

    @State private var confirmDelete = false
    @State private var deleteSet: IndexSet = .init()

    @FetchRequest(
        entity: PersonEntity.entity(),
        sortDescriptors: [
            NSSortDescriptor(key: "name", ascending: true)
        ]
    ) var people: FetchedResults<PersonEntity>

    // MARK: - Initializer

    // MARK: - Properties

    private var allowMore: Bool {
        // TODO: This temporarily makes in-app purchase unnecessary for debugging.
        // store.appPurchased || people.count < 2
        true
    }

    var body: some View {
        NavigationView {
            Screen {
                List {
                    ForEach(people, id: \.self) { person in
                        NavigationLink(
                            destination: PersonForm(person: person)
                        ) {
                            HStack {
                                MyText(person.name ?? "")
                                if let birthday = person.birthday {
                                    Spacer()
                                    MyText(birthday.monthDayYear)
                                }
                            }
                        }
                    }
                    .onDelete { indexSet in
                        confirmDelete = true
                        deleteSet = indexSet
                    }
                }
                .padding(.top)
                .padding(.horizontal, -20) // removes excess space
                .confirmationDialog(
                    "Deleting this person will also delete " +
                        "all of their gifts.\nAre you sure?",
                    isPresented: $confirmDelete,
                    titleVisibility: .visible
                ) {
                    Button("Yes", role: .destructive) {
                        delete(indexSet: deleteSet)
                    }
                }
            }
            .toolbar {
                // ToolbarItem(placement: .navigationBarLeading) { EditButton() }
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(
                        "Add",
                        destination: PersonForm()
                            .environment(\.canAdd, allowMore)
                    )
                    .navigationBarTitleDisplayMode(.inline)
                    .simultaneousGesture(TapGesture().onEnded {
                        if !allowMore { store.purchaseApp() }
                    })
                }
            }
            .navigationTitle("People")
            .accentColor(Color("Title"))
        }
    }

    // MARK: - Methods

    private func delete(indexSet: IndexSet) {
        for index in indexSet {
            moc.delete(people[index])
        }
        PersistenceController.shared.save()
    }
}
