import SwiftUI

struct MyText: View {
    @EnvironmentObject var settings: Settings

    private let bold: Bool
    private let text: String

    init(_ text: String, bold: Bool = false) {
        self.text = text
        self.bold = bold
    }

    var body: some View {
        Text(text)
            .font(.system(size: 18, weight: bold ? .bold : .regular))
            .foregroundColor(settings.textColor)
    }
}