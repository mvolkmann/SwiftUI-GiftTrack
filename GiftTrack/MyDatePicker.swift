import SwiftUI

struct MyDatePicker: View {
    let title: String
    let selection: Binding<Date>

    init(_ title: String, selection: Binding<Date>) {
        self.title = title
        self.selection = selection
    }

    var body: some View {
        DatePicker(
            title,
            selection: selection,
            displayedComponents: .date
        ).padding(.leading, -30)
    }
}
