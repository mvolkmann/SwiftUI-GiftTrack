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
        .fixListHeight() // defined in ViewExtension.swift
    }
}
