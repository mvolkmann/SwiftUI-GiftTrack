import SwiftUI

struct OccasionAdd: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.managedObjectContext) var moc

    @State private var date = Date.now
    @State private var includeDate = false
    @State private var name = ""

    func add(name: String, date: Date) {
        let occasion = OccasionEntity(context: moc)
        occasion.name = name.trim()
        if includeDate { occasion.date = date }
        PersistenceController.shared.save()
    }

    var body: some View {
        Page {
            Form {
                TextField("Name", text: $name)
                Toggle("Include Date", isOn: $includeDate)
                if includeDate {
                    MyDatePicker("Date", selection: $date)
                }
                ControlGroup {
                    Button("Add") {
                        add(name: name, date: date)
                        name = ""
                        date = Date.now
                        dismiss()
                    }
                    .prominent()
                    .disabled(name.isEmpty)
                    Button("Cancel", action: { dismiss() })
                }
                .buttonStyle(MyButtonStyle())
                .controlGroupStyle(.navigation)
            }
        }
    }
}
