import SwiftUI

struct MyDatePicker: View {
    let selection: Binding<Date>
    let hideYear: Bool

    init(selection: Binding<Date>, hideYear: Bool = false) {
        self.selection = selection
        self.hideYear = hideYear
    }

    var body: some View {
        ZStack {
            DatePicker(
                "",
                selection: selection,
                displayedComponents: .date
            ).padding(.leading, -30)

            if hideYear {
                HStack {
                    Spacer()
                    Rectangle()
                        .fill(.white)
                        .frame(width: 110, height: 180)
                }
            }
        }
    }
}
