import SwiftUI

struct MyToggle: View {
    @EnvironmentObject var settings: Settings

    private let title: String
    @Binding private var isOn: Bool
    private let edit: Bool

    init(
        _ title: String,
        isOn: Binding<Bool>,
        edit: Bool = true
    ) {
        self.title = title
        _isOn = isOn
        self.edit = edit
    }

    var body: some View {
        if edit {
            Toggle(title, isOn: $isOn)
        } else {
            LabelledText(label: title, text: isOn ? "Yes" : "No")
        }
    }
}
