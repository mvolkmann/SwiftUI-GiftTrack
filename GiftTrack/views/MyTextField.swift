import SwiftUI

struct MyTextField: View {
    @EnvironmentObject var settings: Settings
    
    private let title: String
    @Binding private var text: String
    private let edit: Bool
    private let autocorrect: Bool
    
    init(
        _ title: String,
        text: Binding<String>,
        edit: Bool = true,
        autocorrect: Bool = true
    ) {
        self.title = title
        _text = text
        self.edit = edit
        self.autocorrect = autocorrect
    }
    
    var body: some View {
        if edit {
            HStack {
                TextField(title, text: $text)
                    .autocapitalization(.none)
                    .disableAutocorrection(!autocorrect)
                
                if !text.isEmpty {
                    Spacer()
                    IconButton(icon: "xmark.circle", size: 20) {
                        text = ""
                    }
                }
            }
        } else {
            Text("\(title): \(text.isEmpty ? "none" : text)")
                .font(.system(size: 20))
                // The default foreground color is Color.primary.
                // It is set here so it can be overridden in Settings.
                .foregroundColor(settings.textColor)
        }
    }
}
