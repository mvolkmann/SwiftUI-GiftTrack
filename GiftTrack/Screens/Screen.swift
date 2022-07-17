import SwiftUI

struct Screen<Content: View>: View {
    //TODO: CANNOT STORE ADAPTIVE COLORS IN AppStorage!
    @AppStorage("backgroundColor") var backgroundColor: String = "Background"

    let spacing: CGFloat = 0
    @ViewBuilder let content: () -> Content

    var body: some View {
        ZStack {
            Color(backgroundColor).ignoresSafeArea()
            VStack(alignment: .leading, spacing: spacing) {
                content()
                Spacer()
            }
            .padding(.horizontal)
        }
    }
}
