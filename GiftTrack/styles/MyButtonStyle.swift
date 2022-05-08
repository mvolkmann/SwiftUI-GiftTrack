import SwiftUI

struct MyButtonStyle: ButtonStyle {
    @EnvironmentObject var settings: Settings

    func makeBody(configuration: Configuration) -> some View {
        var fgColor = settings.bgColor
        if let role = configuration.role, role == .destructive {
            fgColor = .red
        }
        return configuration.label
            .padding(7)
            .background(settings.titleColor)
            .foregroundColor(fgColor)
            .cornerRadius(7)
    }
}
