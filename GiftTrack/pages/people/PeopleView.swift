import SwiftUI

struct PeopleView: View {
    @State private var confirmDelete = false
    @State private var deleteSet: IndexSet = IndexSet()

    @Environment(\.managedObjectContext) var moc
    @EnvironmentObject var settings: Settings

    @FetchRequest(
        entity: PersonEntity.entity(),
        sortDescriptors: [
            NSSortDescriptor(key: "name", ascending: true)
        ]
    ) var people: FetchedResults<PersonEntity>

    private var dateFormatter = DateFormatter()

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
                /*
                ToolbarItem(placement: .navigationBarLeading) {
                    EditButton()
                }
                */
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink("Add", destination: PersonForm())
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
