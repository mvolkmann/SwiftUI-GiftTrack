import SwiftUI

struct OccasionUpdate: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var name = ""
    @State private var date = Date.now
    
    var occasion: OccasionEntity
    
    init(occasion: OccasionEntity) {
        self.occasion = occasion
        // Preceding these property names with an underscore causes it
        // to refer to the underlying value of the binding
        // rather than the binding itself.
        // This is required to set the value of an @State property.
        _name = State(initialValue: occasion.name ?? "")
        _date = State(initialValue: occasion.date ?? Date.now)
    }
    
    func back() {
        presentationMode.wrappedValue.dismiss()
    }
    
    var body: some View {
        Form {
            TextField("Name", text: $name)
            DatePicker(
                "date",
                selection: $date,
                displayedComponents: .date
            )
            ControlGroup {
                Button("Done") {
                    occasion.name = name
                    occasion.date = date
                    PersistenceController.shared.save()
                    back()
                }
                .buttonStyle(.borderedProminent)
                .disabled(name.isEmpty)
                Button("Cancel", action: back).buttonStyle(.bordered)
            }.controlGroupStyle(.navigation)
        }
    }
}
