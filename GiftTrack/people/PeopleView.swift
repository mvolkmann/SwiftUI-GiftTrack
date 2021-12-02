import SwiftUI

struct PeopleView: View {
    @State private var newColor: Color = .red

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
                // If the iteration is done with List instead of ForEach,
                // we can't use onDelete or onMove.
                // List(vm.people, id: \.self) { person in
                List {
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
                    .onDelete(perform: delete)
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    EditButton()
                }
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
