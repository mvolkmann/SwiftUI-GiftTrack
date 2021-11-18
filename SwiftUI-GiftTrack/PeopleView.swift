import SwiftUI

struct PeopleView: View {
    @EnvironmentObject var vm: ViewModel
    /* TODO: Why doesn't this retrieve anything?
    @FetchRequest(
        entity: PersonEntity.entity(),
        sortDescriptors: [
            NSSortDescriptor(key: "name", ascending: true)
        ]
    ) var people: FetchedResults<PersonEntity>
    */

    private var dateFormatter = DateFormatter()

    init() {
        //print("people =", people)
        //print("people.count =", people.count)
        dateFormatter.dateFormat = "M/d/yyyy"
    }

    func format(date: Date) -> String {
        dateFormatter.string(from: date)
    }

    func update(person: PersonEntity) {
        print("ready to update", person.name ?? "")
    }
    
    func viewDidLoad() {
        print("PeopleView: viewDidLoad entered")
    }

    var body: some View {
        NavigationView {
            // If the iteration is done with List instead of ForEach,
            // we can't use onDelete or onMove.
            // List(vm.people, id: \.self) { person in
            List {
                ForEach(vm.people, id: \.self) { person in
                //ForEach(people, id: \.self) { person in
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
