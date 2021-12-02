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
            TextField(title, text: $url).disableAutocorrection(true)
        } else if url.isEmpty {
            Text("\(title): none")
                .font(.system(size: 20))
                // The default foreground color is Color.primary.
                // It is set here so it can be overridden in Settings.
                .foregroundColor(settings.textColor)
        } else {
            if let linkURL = URL(string: url) {
                Link(destination: linkURL) {
                    Text("website")
                        .foregroundColor(settings.bgColor)
                        .underline()
                }
                .buttonStyle(.borderless)
            } else {
                Text("invalid URL")
            }
        }
    }
}
