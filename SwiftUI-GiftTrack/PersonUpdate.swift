import SwiftUI

struct PersonUpdate: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var vm: ViewModel
    
    @ObservedObject var person: PersonEntity
    
    func back() {
        presentationMode.wrappedValue.dismiss()
    }
    
    var body: some View {
        Form {
            TextField("Name", text: person.name)
            DatePicker(
                "Birthday",
                selection: person.birthday,
                displayedComponents: .date
            )
            ControlGroup {
                Button("Update") {
                    print("person =", person)
                    vm.saveContext()
                    back()
                }
                .buttonStyle(.borderedProminent)
                .disabled((person.name ?? "").isEmpty)
                Button("Cancel", action: back).buttonStyle(.bordered)
            }.controlGroupStyle(.navigation)
        }
    }
}
