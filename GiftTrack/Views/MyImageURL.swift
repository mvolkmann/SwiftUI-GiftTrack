import SwiftUI

struct MyImageURL: View {
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
            HStack {
                TextField(title, text: $url)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)

                if !url.isEmpty {
                    Spacer()
                    DeleteButton { url = "" }
                }
            }
        } else if !url.isEmpty {
            VStack(alignment: .leading) {
                Text(url)
                AsyncImage(url: URL(string: url)) { phase in
                    switch phase {
                    case .empty:
                        ProgressView() // spinner
                    case let .success(image):
                        image.square(size: Settings.imageSize)
                    case .failure:
                        Text("Failed to fetch image.").foregroundColor(.red)
                    @unknown default:
                        fatalError()
                    }
                }
            }
        }
    }
}
