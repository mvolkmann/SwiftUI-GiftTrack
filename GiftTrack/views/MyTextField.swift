import SwiftUI

struct MyTextField: View {
    @EnvironmentObject var settings: Settings
    
    private let title: String
    @Binding private var text: String
    private let edit: Bool
    private let autocorrect: Bool
    private let showEmpty: Bool
    
    init(
        _ title: String,
        text: Binding<String>,
        edit: Bool = true,
        autocorrect: Bool = true,
        showEmpty: Bool = false
    ) {
        self.title = title
        _text = text
        self.edit = edit
        self.autocorrect = autocorrect
        self.showEmpty = showEmpty
    }
    
    var body: some View {
        if edit {
            HStack {
                TextField(title, text: $text)
                    .autocapitalization(.none)
                    .disableAutocorrection(!autocorrect)
                
                if !text.isEmpty {
                    Spacer()
                    IconButton(
                        icon: "xmark.circle.fill",
                        size: 15,
                        color: .gray
                    ) {
                        text = ""
                    }
                }
            }
        } else if !text.isEmpty || showEmpty {
            LabelledText(label: title, text: text)
        }
    }
}
