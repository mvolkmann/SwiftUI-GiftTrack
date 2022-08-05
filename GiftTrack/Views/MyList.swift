import SwiftUI

struct MyList<Content: View>: View {
    @AppStorage("backgroundColor") var backgroundColor: String = "Background"

    let content: Content

    // This is needed to use @ViewBuilder.
    init(
        @ViewBuilder content: () -> Content
    ) {
        self.content = content()
    }

    var body: some View {
        ZStack {
            Color.fromJSON(backgroundColor)
            List {
                content
            }

            // TODO: This cuts off top list item in iOS 15.
            //.listStyle(PlainListStyle())

            .cornerRadius(10)
            .hideBackground() // defined in ViewExtension.swift
            .padding(.horizontal, -20)
            .trimTop()
        }
    }
}
