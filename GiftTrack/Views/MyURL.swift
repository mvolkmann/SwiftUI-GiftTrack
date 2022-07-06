import SwiftUI

struct MyURL: View {
    @EnvironmentObject var settings: Settings

    private let title: String
    @Binding private var url: String
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
        } else if !url.isEmpty {
            if let linkURL = URL(string: url) {
                Link(destination: linkURL) {
                    Text("website")
                        .foregroundColor(Color("link-color"))
                        .underline()
                }
                .buttonStyle(.borderless)
            } else {
                LabelledText(label: title, text: "invalid URL")
            }
        }
    }
}
