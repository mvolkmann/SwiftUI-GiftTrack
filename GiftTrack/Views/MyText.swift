import SwiftUI

struct MyText: View {
    private let bold: Bool
    private let text: String

    init(_ text: String, bold: Bool = false) {
        self.text = text
        self.bold = bold
    }

    var body: some View {
        Text(text)
            .sysFont(20, weight: bold ? .bold : .regular)
            .foregroundColor(Color("Text"))
    }
}
