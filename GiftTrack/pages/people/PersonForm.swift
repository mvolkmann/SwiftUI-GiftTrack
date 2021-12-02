import SwiftUI

struct PersonForm: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.managedObjectContext) var moc
    
    @State private var birthday = Date.now
    @State private var includeBirthday = false
    @State private var name = ""
    
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
        let p = adding ? PersonEntity(context: moc) : person!
        
        p.name = name.trim()
        p.birthday = includeBirthday ? birthday : nil
        
        PersistenceController.shared.save()
        dismiss()
    }
    
    var body: some View {
        Page {
            Form {
                MyTextField("Name", text: $name)
                MyToggle("Include Birthday", isOn: $includeBirthday)
                if includeBirthday {
                    MyDatePicker(selection: $birthday)
                }
            }
            .buttonStyle(MyButtonStyle())
        }
        .navigationBarItems(
            trailing: Button("Done") { save() }.disabled(name.isEmpty)
        )
    }
}
