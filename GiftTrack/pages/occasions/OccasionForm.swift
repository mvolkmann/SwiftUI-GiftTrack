import SwiftUI

struct OccasionForm: View {
    @Environment(\.canAdd) var canAdd
    @Environment(\.dismiss) var dismiss
    @Environment(\.managedObjectContext) var moc
    
    @State private var date = Date.now
    @State private var includeDate = false
    @State private var name = ""
    @State private var showAlert = false
    
    @FetchRequest(
        entity: OccasionEntity.entity(),
        sortDescriptors: [
            NSSortDescriptor(key: "name", ascending: true)
        ]
    ) var occasions: FetchedResults<OccasionEntity>
    
    var occasion: OccasionEntity?
    
    init(occasion: OccasionEntity? = nil) {
        self.occasion = occasion
        
        if let occasion = occasion {
            _name = State(initialValue: occasion.name ?? "")
            _date = State(initialValue: occasion.date ?? Date.now)
            _includeDate = State(initialValue: occasion.date != nil)
        }
    }
    
    private func save() {
        if occasions.contains(where: {
            $0.name?.caseInsensitiveCompare(name) == .orderedSame
        }) {
            showAlert = true
            return
        }
        
        let adding = occasion == nil
        let o = adding ? OccasionEntity(context: moc) : occasion!
        
        o.name = name.trim()
        o.date = includeDate ? date : nil
        
        PersistenceController.shared.save()
        dismiss()
    }
    
    var body: some View {
        Page {
            if canAdd {
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
            } else {
                MyText("""
                An in-app purchase is required to \
                create more than two occasions.
                """, bold: true)
                    .padding(.horizontal)
            }
        }
        .alert(
            "Duplicate Occasion",
            isPresented: $showAlert,
            actions: {},
            message: {
                Text("An occasion with the name \"\(name)\" already exists.")
            }
        )
    }
}
