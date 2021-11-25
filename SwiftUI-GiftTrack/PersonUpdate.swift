import SwiftUI

struct PersonUpdate: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var birthday = Date.now
    @State private var includeBirthday = false
    @State private var name = ""
    
    var person: PersonEntity
    
    init(person: PersonEntity) {
        self.person = person
        // Preceding these property names with an underscore causes it
        // to refer to the underlying value of the binding
        // rather than the binding itself.
        // This is required to set the value of an @State property.
        _name = State(initialValue: person.name ?? "")
        _birthday = State(initialValue: person.birthday ?? Date.now)
        _includeBirthday = State(initialValue: person.birthday != nil)
    }
    
    var body: some View {
        Page {
            Form {
                TextField("Name", text: $name)
                Toggle("Include Birthday", isOn: $includeBirthday)
                if includeBirthday {
                    DatePicker(
                        "Birthday",
                        selection: $birthday,
                        displayedComponents: .date
                    )
                }
                ControlGroup {
                    Button("Done") {
                        person.name = name
                        person.birthday = includeBirthday ? birthday : nil
                        PersistenceController.shared.save()
                        dismiss()
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(name.isEmpty)
                    Button("Cancel", action: { dismiss() }).buttonStyle(.bordered)
                }.controlGroupStyle(.navigation)
            }
        }
    }
}
