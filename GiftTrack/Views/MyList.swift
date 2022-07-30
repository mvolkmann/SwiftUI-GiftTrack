import SwiftUI

struct MyList<Content: View>: View {
    let content: Content

    // This is needed to use @ViewBuilder.
    init(
        @ViewBuilder content: () -> Content
    ) {
        self.content = content()
    }

    var body: some View {
        List {
            content
        }
        .padding(.horizontal, -20) // removes excess padding
        .padding(.top, -35) // removes excess padding
        .scrollContentBackground(.hidden)
    }
}
