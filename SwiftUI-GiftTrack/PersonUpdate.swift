import SwiftUI

struct PersonUpdate: View {
    @Environment(\.presentationMode) var presentationMode
    
    @Binding var person: PersonEntity
    
    func back() {
        presentationMode.wrappedValue.dismiss()
    }
    
    var body: some View {
        Form {
            /* TODO: Fix compile errors here.
            TextField("Name", text: $person.name)
            DatePicker(
                "Birthday",
                selection: $person.birthday,
                displayedComponents: .date
            )
            */
            ControlGroup {
                Button("Update") {
                    back()
                }
                .buttonStyle(.borderedProminent)
                //.disabled(name.isEmpty)
                Button("Cancel", action: back).buttonStyle(.bordered)
            }.controlGroupStyle(.navigation)
        }
    }
}
