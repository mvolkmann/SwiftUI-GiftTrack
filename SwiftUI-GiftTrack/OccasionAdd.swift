import SwiftUI

struct OccasionAdd: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.managedObjectContext) var moc
    @State private var date = Date.now
    @State private var name = ""

    func add(name: String, date: Date) {
        let occasion = OccasionEntity(context: moc)
        occasion.name = name
        occasion.date = date
        PersistenceController.shared.save()
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
                    dismiss()
                }
                .buttonStyle(.borderedProminent)
                .disabled(name.isEmpty)
                Button("Cancel", action: { dismiss() }).buttonStyle(.bordered)
            }.controlGroupStyle(.navigation)
        }
    }
}
