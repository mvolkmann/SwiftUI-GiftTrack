import SwiftUI

struct MyButtonStyle: ButtonStyle {
    @AppStorage("backgroundColor") var backgroundColor: String = "Background"
    @AppStorage("titleColor") var titleColor: String = "Title"

    func makeBody(configuration: Configuration) -> some View {
        return configuration.label
            .padding(7)
            .background(
                configuration.role == .destructive ? .red : Color(titleColor)
            )
            .foregroundColor(Color(UIColor.systemBackground))
            .cornerRadius(7)
    }
}
