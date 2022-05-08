import SwiftUI

struct PersonForm: View {
    @Environment(\.canAdd) var canAdd
    @Environment(\.dismiss) var dismiss
    @Environment(\.managedObjectContext) var moc
    
    @State private var birthday = Date.now
    @State private var includeBirthday = false
    @State private var name = ""
    @State private var showAlert = false
    
    @FetchRequest(
        entity: PersonEntity.entity(),
        sortDescriptors: [
            NSSortDescriptor(key: "name", ascending: true)
        ]
    ) var people: FetchedResults<PersonEntity>
    
    var person: PersonEntity?
    
    init(person: PersonEntity? = nil) {
        self.person = person
        
        if let person = person {
            // Preceding these property names with an underscore causes it
            // to refer to the underlying value of the binding
            // rather than the binding itself.
            // This is required to set the value of an @State property.
            _name = State(initialValue: person.name ?? "")
            _birthday = State(initialValue: person.birthday ?? Date.now)
            _includeBirthday = State(initialValue: person.birthday != nil)
        }
    }
    
    private func save() {
        let adding = person == nil
        
        if adding && people.contains(where: {
            $0.name?.caseInsensitiveCompare(name) == .orderedSame
        }) {
            showAlert = true
            return
        }
        
        let p = adding ? PersonEntity(context: moc) : person!
        
        p.name = name.trim()
        p.birthday = includeBirthday ? birthday : nil
        
        PersistenceController.shared.save()
        dismiss()
    }
    
    var body: some View {
        Page {
            if canAdd {
                Form {
                    MyTextField("Name", text: $name)
                    MyToggle("Include Birthday", isOn: $includeBirthday)
                    if includeBirthday {
                        MyDatePicker(selection: $birthday)
                    }
                }
                .buttonStyle(MyButtonStyle())
                .navigationBarItems(
                    trailing: Button("Done") { save() }.disabled(name.isEmpty)
                )
            } else {
                MyText("""
                An in-app purchase is required to \
                create more than two people.
                """, bold: true)
                    .padding(.horizontal)
            }
        }
        .alert(
            "Duplicate Person",
            isPresented: $showAlert,
            actions: {},
            message: {
                Text("A person with the name \"\(name)\" already exists.")
            }
        )
    }
}
