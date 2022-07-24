import SwiftUI

struct MyButtonStyle: ButtonStyle {
    @AppStorage("titleColor") var titleColor: String = "Title"

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(7)
            .background(
                configuration.role == .destructive ?
                    .red : Color.fromJSON(titleColor)
            )
            .foregroundColor(Color(UIColor.systemBackground))
            .cornerRadius(7)
    }
}
