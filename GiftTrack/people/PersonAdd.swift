import SwiftUI

struct PersonAdd: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.managedObjectContext) var moc

    @State private var birthday = Date.now
    @State private var includeBirthday = false
    @State private var name = ""

    func add(name: String, birthday: Date) {
        let person = PersonEntity(context: moc)
        person.name = name.trim()
        if includeBirthday { person.birthday = birthday }
        PersistenceController.shared.save()
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
                    Button("Add") {
                        add(name: name, birthday: birthday)
                        name = ""
                        birthday = Date.now
                        dismiss()
                    }
                    .prominent()
                    .disabled(name.isEmpty)
                    Button("Cancel", action: { dismiss() })
                }.controlGroupStyle(.navigation)
            }
        }
    }
}