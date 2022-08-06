import SwiftUI

struct Screen<Content: View>: View {
    // MARK: - State

    @AppStorage("backgroundColor") var backgroundColor: String = "Background"
    @AppStorage("titleColor") var titleColor: String = "Title"

    // MARK: - Properties

    let pad: Bool
    let content: Content

    init(
        pad: Bool = false,
        @ViewBuilder content: () -> Content
    ) {
        self.pad = pad
        self.content = content()
    }

    var body: some View {
        ZStack {
            Color.fromJSON(backgroundColor).ignoresSafeArea()
            VStack(alignment: .leading) {
                Spacer().frame(height: 20)
                content
                    .if(pad) { view in
                        view.padding(.horizontal)
                    }
                Spacer() // pushes content to top
            }
        }
        .accentColor(Color.fromJSON(titleColor))
    }
}
