import SwiftUI

struct OccasionUpdate: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var date = Date.now
    @State private var includeDate = false
    @State private var name = ""
    
    var occasion: OccasionEntity
    
    init(occasion: OccasionEntity) {
        self.occasion = occasion
        // Preceding these property names with an underscore causes it
        // to refer to the underlying value of the binding
        // rather than the binding itself.
        // This is required to set the value of an @State property.
        _name = State(initialValue: occasion.name ?? "")
        _date = State(initialValue: occasion.date ?? Date.now)
        _includeDate = State(initialValue: occasion.date != nil)
    }
    
    var body: some View {
        Page {
            Form {
                TextField("Name", text: $name)
                Toggle("Include Date", isOn: $includeDate)
                if includeDate {
                    DatePicker(
                        "date",
                        selection: $date,
                        displayedComponents: .date
                    )
                }
                ControlGroup {
                    Button("Done") {
                        occasion.name = name
                        occasion.date = includeDate ? date : nil
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
