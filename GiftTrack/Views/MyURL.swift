import SwiftUI

struct MyURL: View {
    init(
        _ title: String,
        url: Binding<String>,
        edit: Bool = true,
        onCommit: @escaping () -> Void = {}
    ) {
        self.title = title
        _url = url
        self.edit = edit
        self.onCommit = onCommit
    }

    private let edit: Bool
    private let onCommit: () -> Void
    private let title: String
    @Binding var url: String

    var body: some View {
        if edit {
            TextField(title, text: $url, onCommit: onCommit)
                .autocapitalization(.none)
                .disableAutocorrection(true)
                .onDisappear { url = addHTTP(url) }
        } else if !url.isEmpty {
            if let linkURL = URL(string: url) {
                Link(destination: linkURL) {
                    Text("website")
                        .foregroundColor(Color("Link"))
                        .underline()
                }
                .buttonStyle(.borderless)
            } else {
                LabelledText(label: title, text: "invalid URL")
            }
        }
    }
}
