import SwiftUI

struct PeopleScreen: View {
    // MARK: - State

    @AppStorage("titleColor") var titleColor: String = "Title"

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

    // MARK: - Properties

    private var addItem: some View {
        NavigationLink(
            "Add",
            destination: PersonForm()
                .environment(\.canAdd, allowMore)
        )
        .simultaneousGesture(TapGesture().onEnded {
            if !allowMore { store.purchaseApp() }
        })
    }

    private var allowMore: Bool {
        // TODO: This temporarily makes in-app purchase unnecessary for debugging.
        // true

        store.appPurchased || people.count < 2
    }

    var body: some View {
        NavigationView {
            Screen {
                MyList {
                    ForEach(people, id: \.self) { person in
                        link(person: person)
                    }
                    .onDelete { indexSet in
                        confirmDelete = true
                        deleteSet = indexSet
                    }
                }
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
                ToolbarItem(placement: .navigationBarLeading) {
                    addItem
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
            }
            .navigationTitle("People")
            .navigationBarTitleDisplayMode(.inline)
            .accentColor(Color.fromJSON(titleColor))
        }
    }

    // MARK: - Methods

    private func delete(indexSet: IndexSet) {
        for index in indexSet {
            moc.delete(people[index])
        }
        PersistenceController.shared.save()
    }

    private func link(person: PersonEntity) -> some View {
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
}
