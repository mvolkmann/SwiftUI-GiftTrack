import SwiftUI

struct Page<Content: View>: View {
    let spacing: CGFloat = 0
    @ViewBuilder let content: () -> Content

    // let spacing: CGFloat = 0

    var body: some View {
        ZStack {
            bgColor.ignoresSafeArea()
            VStack(alignment: .leading, spacing: spacing) {
                content()
                Spacer()
            }
            .padding(.horizontal)
        }
    }
}
