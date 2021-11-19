import SwiftUI

struct PeopleView: View {
    @EnvironmentObject var personStorage: PersonStorage

    private var dateFormatter = DateFormatter()

    init() {
        dateFormatter.dateFormat = "M/d/yyyy"
    }

    private func format(date: Date) -> String {
        dateFormatter.string(from: date)
    }

    var body: some View {
        NavigationView {
            // If the iteration is done with List instead of ForEach,
            // we can't use onDelete or onMove.
            // List(vm.people, id: \.self) { person in
            List {
                ForEach(personStorage.people, id: \.self) { person in
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
                .onDelete(perform: personStorage.delete)
                .onMove(perform: personStorage.move)
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
