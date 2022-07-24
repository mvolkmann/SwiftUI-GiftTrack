import SwiftUI

struct MyTextField: View {
    // MARK: - Initializer

    init(
        _ title: String,
        text: Binding<String>,
        edit: Bool = true,
        autocorrect: Bool = true,
        capitalizationType: UITextAutocapitalizationType = .none,
        keyboard: UIKeyboardType = .default
    ) {
        self.title = title
        _text = text
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

    var body: some View {
        if edit {
            HStack {
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
            LabelledText(label: title, text: text)
        }
    }
}
