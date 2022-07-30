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
            TextField(title, text: $tempUrl, onEditingChanged: editingChanged)
                .autocapitalization(.none)
                .disableAutocorrection(true)
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

    private func editingChanged(hasFocus: Bool) {
        // TODO: This is not called if only "Done" is tapped.
        print("MyURL.editingChanged: hasFocus = \(hasFocus)")
        guard !hasFocus else { return }

        if !tempUrl.starts(with: "https://"), !tempUrl.starts(with: "http://") {
            tempUrl = "https://" + tempUrl
        }
        url = tempUrl // TODO: THIS LINE IS WRONG!
    }
}
