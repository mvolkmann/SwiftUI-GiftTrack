import SwiftUI

struct MyTextField: View {
    @EnvironmentObject var settings: Settings
    
    private let title: String
    @Binding private var text: String
    private let edit: Bool
    private let autocorrect: Bool
    private let keyboard: UIKeyboardType
    
    init(
        _ title: String,
        text: Binding<String>,
        edit: Bool = true,
        autocorrect: Bool = true,
        keyboard: UIKeyboardType = .default
    ) {
        self.title = title
        _text = text
        self.edit = edit
        self.autocorrect = autocorrect
        self.keyboard = keyboard
    }
    
    var body: some View {
        if edit {
            HStack {
                TextField(title, text: $text)
                    .textInputAutocapitalization(.words)
                    .disableAutocorrection(!autocorrect)
                    .keyboardType(keyboard)
                
                if !text.isEmpty {
                    Spacer()
                    DeleteButton() { text = "" }
                }
            }
        } else if !text.isEmpty {
            LabelledText(label: title, text: text)
        }
    }
}
