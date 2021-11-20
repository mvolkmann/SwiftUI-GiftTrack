import SwiftUI

struct PersonUpdate: View {
    @Environment(\.managedObjectContext) var moc
    @Environment(\.presentationMode) var presentationMode
    @State private var name = ""
    @State private var birthday = Date.now
    
    var person: PersonEntity
    
    init(person: PersonEntity) {
        self.person = person
        // Preceding these property names with an underscore causes it
        // to refer to the underlying value of the binding
        // rather than the binding itself.
        // This is required to set the value of an @State property.
        _name = State(initialValue: person.name ?? "")
        _birthday = State(initialValue: person.birthday ?? Date.now)
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
                }
             */
            DatePicker(
                "Birthday",
                selection: $birthday,
                displayedComponents: .date
            )
            ControlGroup {
                Button("Done") {
                    person.name = name
                    person.birthday = birthday
                    PersistenceController.singleton.save()
                    back()
                }
                .buttonStyle(.borderedProminent)
                .disabled(name.isEmpty)
                Button("Cancel", action: back).buttonStyle(.bordered)
            }.controlGroupStyle(.navigation)
        }
    }
}
