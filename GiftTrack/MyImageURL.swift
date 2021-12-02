import SwiftUI

struct MyImageURL: View {
    @EnvironmentObject var settings: Settings

    private let title: String
    @Binding private var url: String
    private let edit: Bool

    init(
        _ title: String,
        url: Binding<String>,
        edit: Bool
    ) {
        self.title = title
        _url = url
        self.edit = edit
    }

    var body: some View {
        if edit {
            HStack {
                TextField(title, text: $url)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                
                if !url.isEmpty {
                    Spacer()
                    IconButton(icon: "xmark.circle", size: 20) { url = "" }
                }
            }
        } else if url.isEmpty {
            Text("\(title): none")
                .font(.system(size: 20))
                // The default foreground color is Color.primary.
                // It is set here so it can be overridden in Settings.
                .foregroundColor(settings.textColor)
        } else {
            AsyncImage(
                url: URL(string: url),
                content: { image in
                    image
                        .resizable()
                        .frame(
                            width: Settings.imageSize,
                            height: Settings.imageSize
                        )
                },
                placeholder: { ProgressView() } // spinner
            )
        }
    }
}
