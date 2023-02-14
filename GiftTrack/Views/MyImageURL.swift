import SwiftUI

struct MyImageURL: View {
    // MARK: - Initializer

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

    // MARK: - Constants

    private let imageSize = 150.0

    // MARK: - Properties

    private let edit: Bool
    private let onCommit: () -> Void
    private let title: String
    @Binding private var url: String

    var body: some View {
        if edit {
            HStack {
                TextField(title, text: $url, onCommit: onCommit)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    .onDisappear { url = addHTTP(url) }

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
                        image.square(size: imageSize)
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
