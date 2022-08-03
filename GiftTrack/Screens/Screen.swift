import SwiftUI

struct Screen<Content: View>: View {
    // MARK: - State

    @AppStorage("backgroundColor") var backgroundColor: String = "Background"
    @AppStorage("titleColor") var titleColor: String = "Title"

    // MARK: - Properties

    @ViewBuilder let content: () -> Content

    var body: some View {
        ZStack {
            Color.fromJSON(backgroundColor).ignoresSafeArea()
            VStack(alignment: .leading) {
                Spacer().frame(height: 20)
                content()
                    .padding(.horizontal)
                Spacer() // pushes content to top
            }
        }
        .accentColor(Color.fromJSON(titleColor))
    }
}
