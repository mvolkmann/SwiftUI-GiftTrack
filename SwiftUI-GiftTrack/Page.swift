import SwiftUI

struct Page<Content: View>: View {
    @ViewBuilder let content: () -> Content

    var body: some View {
        ZStack {
            bgColor.ignoresSafeArea()
            VStack(alignment: .leading) {
                content()
            }
            .padding(.horizontal)
        }
    }
}
