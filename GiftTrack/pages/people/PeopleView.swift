import SwiftUI

struct PeopleView: View {
    @Environment(\.managedObjectContext) var moc
    @EnvironmentObject private var settings: Settings
    @EnvironmentObject private var store: StoreKitStore
    
    @State private var confirmDelete = false
    @State private var deleteSet: IndexSet = IndexSet()


    @FetchRequest(
        entity: PersonEntity.entity(),
        sortDescriptors: [
            NSSortDescriptor(key: "name", ascending: true)
        ]
    ) var people: FetchedResults<PersonEntity>

    private var dateFormatter = DateFormatter()

    private var allowMore: Bool {
        store.appPurchased || people.count < 2
    }
    
    init() {
        dateFormatter.dateFormat = "M/d/yyyy"
    }

    private func delete(indexSet: IndexSet) {
        for index in indexSet {
            moc.delete(people[index])
        }
        PersistenceController.shared.save()
    }

    private func format(date: Date?) -> String {
        guard let date = date else { return "" }
        return dateFormatter.string(from: date)
    }

    var body: some View {
        NavigationView {
            Page {
                List {
                    // The onDelete method exists on ForEach, but not on List
                    // because a List can include static rows.
                    ForEach(people, id: \.self) { person in
                        NavigationLink(
                            destination: PersonForm(person: person)
                        ) {
                            HStack {
                                MyText(person.name ?? "")
                                if let birthday = person.birthday {
                                    Spacer()
                                    MyText(format(date: birthday))
                                }
                            }
                        }
                    }
                    .onDelete() { indexSet in
                        confirmDelete = true
                        deleteSet = indexSet
                    }
                }
                .confirmationDialog(
                    "Deleting this person will also delete " +
                    "all their gifts.\nAre you sure?",
                    isPresented: $confirmDelete,
                    titleVisibility: .visible
                ) {
                    Button("Yes", role: .destructive) {
                        delete(indexSet: deleteSet)
                    }
                }
            }
            .toolbar {
                //ToolbarItem(placement: .navigationBarLeading) { EditButton() }
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(
                        "Add",
                        destination: PersonForm()
                            .environment(\.canAdd, allowMore)
                    )
                    .simultaneousGesture(TapGesture().onEnded {
                        if !allowMore { store.purchaseApp() }
                    })
            }
            }
            .navigationTitle("People")
            .accentColor(settings.titleColor)
        }
        .accentColor(settings.titleColor) // navigation back link color
        .onAppear {
            configureNavigationTitle(color: settings.titleColor)
        }
    }
}
