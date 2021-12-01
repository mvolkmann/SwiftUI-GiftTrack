import SwiftUI

struct MyDatePicker: View {
    let selection: Binding<Date>

    init(selection: Binding<Date>) {
        self.selection = selection
    }

    var body: some View {
        DatePicker(
            "",
            selection: selection,
            displayedComponents: .date
        ).padding(.leading, -30)
    }
}
