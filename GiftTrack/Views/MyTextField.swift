import SwiftUI

struct MyTextField: View {
    @FocusState private var isFocused: Bool
    @StateObject private var viewModel = ViewModel.shared

    // MARK: - Initializer

    init(
        _ title: String,
        text: Binding<String>,
        valuePrefix: String = "",
        edit: Bool = true,
        autocorrect: Bool = true,
        capitalizationType: UITextAutocapitalizationType = .none,
        keyboard: UIKeyboardType = .default,
        canDismissKeyboard: Bool = true,
        onCommit: @escaping () -> Void = {}
    ) {
        self.title = title
        _text = text
        self.valuePrefix = valuePrefix
        self.edit = edit
        self.autocorrect = autocorrect
        self.canDismissKeyboard = canDismissKeyboard
        self.capitalizationType = capitalizationType
        self.keyboard = keyboard
        self.onCommit = onCommit
    }

    // MARK: - Properties

    private let canDismissKeyboard: Bool
    private let edit: Bool
    private let autocorrect: Bool
    private let capitalizationType: UITextAutocapitalizationType
    private let keyboard: UIKeyboardType
    private let onCommit: () -> Void
    @Binding private var text: String
    private let title: String
    private let valuePrefix: String

    var body: some View {
        if edit {
            HStack {
                Text(valuePrefix)

                TextField(title, text: $text, onCommit: onCommit)
                    .autocapitalization(capitalizationType)
                    .disableAutocorrection(!autocorrect)
                    .keyboardType(keyboard)
                    .focused($isFocused)
                    .if(canDismissKeyboard) { view in
                        view.toolbar {
                            ToolbarItem(placement: .keyboard) {
                                Button(action: dismissKeyboard) {
                                    Image(
                                        systemName: "keyboard.chevron.compact.down"
                                    )
                                }
                            }
                        }
                    }
                    .onChange(of: isFocused) { _ in
                        viewModel.isKeyboardShown = isFocused
                    }

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
