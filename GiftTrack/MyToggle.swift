import SwiftUI

struct MyToggle: View {
    @EnvironmentObject var settings: Settings

    private let title: String
    @Binding private var isOn: Bool
    private let edit: Bool

    init(
        _ title: String,
        isOn: Binding<Bool>,
        edit: Bool
    ) {
        self.title = title
        _isOn = isOn
        self.edit = edit
    }

    var body: some View {
        if edit {
            Toggle(title, isOn: $isOn)
        } else {
            Text("\(title): \(isOn ? "Yes" : "No")")
                .font(.system(size: 20))
                // The default foreground color is Color.primary.
                // It is set here so it can be overridden in Settings.
                .foregroundColor(settings.textColor)
        }
    }
}
