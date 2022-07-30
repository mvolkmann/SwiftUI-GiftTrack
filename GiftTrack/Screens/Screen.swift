import SwiftUI

struct Screen<Content: View>: View {
    // MARK: - State

    @AppStorage("backgroundColor") var backgroundColor: String = "Background"

    // MARK: - Properties

    @ViewBuilder let content: () -> Content

    var body: some View {
        ZStack {
            Color.fromJSON(backgroundColor)
            VStack(alignment: .leading) {
                content()
                    .padding(.horizontal)
                Spacer() // pushes content to top
            }
        }
    }
}
