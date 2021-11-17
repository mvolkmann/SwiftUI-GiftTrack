import SwiftUI

struct PersonAdd: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var vm: ViewModel
    @State private var birthday = Date.now
    @State private var name = ""

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
                    vm.addPerson(name: name, birthday: birthday)
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
