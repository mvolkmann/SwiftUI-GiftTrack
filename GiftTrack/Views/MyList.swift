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
        .listStyle(PlainListStyle())
        .cornerRadius(10)
        // This makes it so only occupied rows take up vertical space.
        .scrollContentBackground(.hidden) // requires iOS 16
        /*
         if #available(iOS 16.0, *) {
             .scrollContentBackground(.hidden) // requires iOS 16
         }
         */
    }
}
