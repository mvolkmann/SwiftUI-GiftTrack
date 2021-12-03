import SwiftUI

struct MyImageURL: View {
    @EnvironmentObject var settings: Settings

    private let title: String
    @Binding private var url: String
    private let edit: Bool
    private let showEmpty: Bool

    init(
        _ title: String,
        url: Binding<String>,
        edit: Bool = true,
        showEmpty: Bool = false
    ) {
        self.title = title
        _url = url
        self.edit = edit
        self.showEmpty = showEmpty
    }

    var body: some View {
        if edit {
            HStack {
                TextField(title, text: $url)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                
                if !url.isEmpty {
                    Spacer()
                    DeleteButton() { url = "" }
                }
            }
        } else if url.isEmpty {
            if showEmpty { LabelledText(label: title, text: "none") }
        } else {
            VStack(alignment: .leading) {
                Text(url)
                AsyncImage(url: URL(string: url)) { phase in
                    switch phase {
                    case .empty:
                        ProgressView() // spinner
                    case .success(let image):
                        image
                            .resizable()
                            .frame(
                                width: Settings.imageSize,
                                height: Settings.imageSize
                            )
                        
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
