import SwiftUI

struct OccasionForm: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.managedObjectContext) var moc
    
    @State private var date = Date.now
    @State private var includeDate = false
    @State private var name = ""
    
    var occasion: OccasionEntity?
    
    init(occasion: OccasionEntity? = nil) {
        self.occasion = occasion
        
        if let occasion = occasion {
            // Preceding these property names with an underscore causes it
            // to refer to the underlying value of the binding
            // rather than the binding itself.
            // This is required to set the value of an @State property.
            _name = State(initialValue: occasion.name ?? "")
            _date = State(initialValue: occasion.date ?? Date.now)
            _includeDate = State(initialValue: occasion.date != nil)
        }
    }
    
    private func save() {
        let adding = occasion == nil
        let o = adding ? OccasionEntity(context: moc) : occasion!
        
        o.name = name.trim()
        o.date = includeDate ? date : nil
        
        PersistenceController.shared.save()
        dismiss()
    }
    
    var body: some View {
        Page {
            Form {
                MyTextField("Name", text: $name)
                MyToggle("Include Date", isOn: $includeDate)
                if includeDate {
                    MyDatePicker(selection: $date)
                }
            }
            .navigationBarItems(
                trailing: Button("Done") { save() }.disabled(name.isEmpty)
            )
        }
    }
}
