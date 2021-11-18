import SwiftUI

struct PersonUpdate: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var vm: ViewModel
    
    @State private var name = ""
    @State private var birthday = Date.now
    
    var person: PersonEntity
    
    init(person: PersonEntity) {
        self.person = person
        // TODO: Why do I need so much syntax to do this?
        self._name = State(
            initialValue: person.value(forKey: "name") as? String ?? ""
        )
        self._birthday = State(
            initialValue: person.value(forKey: "birthday") as? Date ?? Date.now
        )
    }
    
    func back() {
        presentationMode.wrappedValue.dismiss()
    }
    
    var body: some View {
        Form {
            TextField("Name", text: $name)
            /* to persist immediately ...
                .onChange(of: name) { newName in
                    person.name = newName
                    vm.saveContext()
                    vm.fetchPeople()
                }
             */
            DatePicker(
                "Birthday",
                selection: $birthday,
                displayedComponents: .date
            )
            ControlGroup {
                // TODO: Try to persist changes as they are made
                // TODO: so an Update button isn't needed.
                Button("Done") {
                    person.name = name
                    person.birthday = birthday
                    print("person =", person)
                    vm.saveContext()
                    
                    // TODO: Can I update a single person in the ViewModel
                    // TODO: without refetching all of them again?
                    vm.fetchPeople()
                    back()
                }
                .buttonStyle(.borderedProminent)
                .disabled(name.isEmpty)
                Button("Cancel", action: back).buttonStyle(.bordered)
            }.controlGroupStyle(.navigation)
        }
    }
}