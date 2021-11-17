import SwiftUI

struct PeopleView: View {
    @EnvironmentObject var vm: ViewModel

    private var dateFormatter = DateFormatter()

    init() {
        dateFormatter.dateFormat = "M/d/yyyy"
    }

    func format(date: Date) -> String {
        dateFormatter.string(from: date)
    }

    func update(person: PersonEntity) {
        print("ready to update", person.name ?? "")
    }

    var body: some View {
        NavigationView {
            // If the iteration is done with List instead of ForEach,
            // we can't use onDelete or onMove.
            // List(vm.people, id: \.self) { person in
            List {
                ForEach(vm.people, id: \.self) { person in
                    NavigationLink(
                        destination: PersonUpdate(person: person)
                    ) {
                        HStack {
                            Text(person.name ?? "")
                            if let birthday = person.birthday {
                                Spacer()
                                // Text(dateFormatter.string(from: birthday))
                                Text(format(date: birthday))
                            }
                        }
                    }
                }
                .onDelete(perform: vm.deletePeople)
                .onMove(perform: vm.movePeople)
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
