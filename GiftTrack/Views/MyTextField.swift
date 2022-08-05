import SwiftUI

struct MyTextField: View {
    // MARK: - Initializer

    init(
        _ title: String,
        text: Binding<String>,
        valuePrefix: String = "",
        edit: Bool = true,
        autocorrect: Bool = true,
        capitalizationType: UITextAutocapitalizationType = .none,
        keyboard: UIKeyboardType = .default
    ) {
        self.title = title
        _text = text
        self.valuePrefix = valuePrefix
        self.edit = edit
        self.autocorrect = autocorrect
        self.capitalizationType = capitalizationType
        self.keyboard = keyboard
    }

    // MARK: - Properties

    private let title: String
    @Binding private var text: String
    private let edit: Bool
    private let autocorrect: Bool
    private let capitalizationType: UITextAutocapitalizationType
    private let keyboard: UIKeyboardType
    private let valuePrefix: String

    var body: some View {
        if edit {
            HStack {
                Text(valuePrefix)
                TextField(title, text: $text)
                    .autocapitalization(capitalizationType)
                    .disableAutocorrection(!autocorrect)
                    .keyboardType(keyboard)

                if !text.isEmpty {
                    Spacer()
                    DeleteButton { text = "" }
                }
            }
        } else if !text.isEmpty {
            LabelledText(label: title, text: valuePrefix + text)
        }
    }
}
