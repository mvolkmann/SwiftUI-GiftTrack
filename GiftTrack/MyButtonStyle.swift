import SwiftUI

// For prominent buttons, apply the custom .prominent() view modifier.
struct MyButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        var fgColor = bgColor
        if let role = configuration.role, role == .destructive {
            fgColor = .red
        }
        return configuration.label
            .padding(7)
            .background(titleColor)
            .foregroundColor(fgColor)
            .cornerRadius(7)
    }
}
