import SwiftUI

struct OccasionAdd: View {
    @Environment(\.managedObjectContext) var moc
    @Environment(\.presentationMode) var presentationMode
    @State private var date = Date.now
    @State private var name = ""

    func add(name: String, date: Date) {
        let occasion = OccasionEntity(context: moc)
        occasion.name = name
        occasion.date = date
        PersistenceController.shared.save()
    }

    func back() {
        presentationMode.wrappedValue.dismiss()
    }

    var body: some View {
        Form {
            TextField("Name", text: $name)
            DatePicker(
                "Date",
                selection: $date,
                displayedComponents: .date
            )
            ControlGroup {
                Button("Add") {
                    add(name: name, date: date)
                    name = ""
                    date = Date.now
                    back()
                }
                .buttonStyle(.borderedProminent)
                .disabled(name.isEmpty)
                Button("Cancel", action: back).buttonStyle(.bordered)
            }.controlGroupStyle(.navigation)
        }
    }
}
