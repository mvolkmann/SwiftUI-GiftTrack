import SwiftUI

struct MyURL: View {
    private let title: String
    @Binding var url: String
    private let edit: Bool

    @State private var tempUrl: String

    init(
        _ title: String,
        url: Binding<String>,
        edit: Bool = true
    ) {
        self.title = title
        _url = url
        self.edit = edit
        _tempUrl = State(initialValue: url.wrappedValue)
    }

    var body: some View {
        if edit {
            TextField(title, text: $tempUrl)
                .autocapitalization(.none)
                .disableAutocorrection(true)
                .onDisappear(perform: requireHTTP)
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

    private func requireHTTP() {
        if tempUrl.starts(with: "https://") { return }
        if tempUrl.starts(with: "http://") { return }
        url = "https://" + tempUrl
    }
}
