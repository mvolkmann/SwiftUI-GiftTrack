import SwiftUI

struct PeopleView: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(
        entity: PersonEntity.entity(),
        sortDescriptors: [
            NSSortDescriptor(key: "name", ascending: true)
        ]
    ) var people: FetchedResults<PersonEntity>

    private var dateFormatter = DateFormatter()

    init() {
        configureNavigationTitle()
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

    private func move(indexSet: IndexSet, to: Int) {
        // TODO: How can you implement this when using @FetchRequest?
        // This updates the UI, but doesn't save the order.
        // If you navigate to another page and then return to this page,
        // the people will return to alphabetical order.
        // $people.move(fromOffsets: indexSet, toOffset: to)
    }

    var body: some View {
        NavigationView {
            Page {
                // If the iteration is done with List instead of ForEach,
                // we can't use onDelete or onMove.
                // List(vm.people, id: \.self) { person in
                List {
                    ForEach(people, id: \.self) { person in
                        NavigationLink(
                            destination: PersonUpdate(person: person)
                        ) {
                            HStack {
                                Text(person.name ?? "")
                                if let birthday = person.birthday {
                                    Spacer()
                                    Text(format(date: birthday))
                                }
                            }
                        }
                    }
                    .onDelete(perform: delete)
                    .onMove(perform: move)
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    EditButton()
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink("Add", destination: PersonAdd())
                }
            }
            .navigationTitle("People")
        }
    }
}
