import SwiftUI

struct MyURL: View {
    private let title: String
    @Binding var url: String
    private let edit: Bool

    init(
        _ title: String,
        url: Binding<String>,
        edit: Bool = true
    ) {
        self.title = title
        _url = url
        self.edit = edit
    }

    var body: some View {
        if edit {
            TextField(title, text: $url)
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
