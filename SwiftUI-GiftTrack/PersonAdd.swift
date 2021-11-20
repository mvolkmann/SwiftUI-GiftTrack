import SwiftUI

struct PersonAdd: View {
    @Environment(\.managedObjectContext) var moc
    @Environment(\.presentationMode) var presentationMode
    @State private var birthday = Date.now
    @State private var name = ""

    func add(name: String, birthday: Date) {
        let person = PersonEntity(context: moc)
        person.name = name
        person.birthday = birthday
        PersistenceController.shared.save()
    }

    func back() {
        presentationMode.wrappedValue.dismiss()
    }

    var body: some View {
        Form {
            TextField("Name", text: $name)
            DatePicker(
                "Birthday",
                selection: $birthday,
                displayedComponents: .date
            )
            ControlGroup {
                Button("Add") {
                    add(name: name, birthday: birthday)
                    name = ""
                    birthday = Date.now
                    back()
                }
                .buttonStyle(.borderedProminent)
                .disabled(name.isEmpty)
                Button("Cancel", action: back).buttonStyle(.bordered)
            }.controlGroupStyle(.navigation)
        }
    }
}
