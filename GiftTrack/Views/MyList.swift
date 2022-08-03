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
            .listStyle(PlainListStyle())
            .cornerRadius(10)
            .border(.red)
            //.hideBackground() // defined in ViewExtension.swift
        }
    }
}
