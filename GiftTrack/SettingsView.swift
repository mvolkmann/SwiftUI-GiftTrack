import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var settings: Settings

    var body: some View {
        Page {
            Text("Settings")
                .font(.largeTitle)
                .foregroundColor(settings.titleColor)
                .padding(.bottom, 20)

            Form {
                VStack(spacing: 10) {
                    ColorPicker(
                        "Background Color",
                        selection: $settings.bgColor
                    ).foregroundColor(settings.textColor)
                    ColorPicker(
                        "Title Color",
                        selection: $settings.titleColor
                    ).foregroundColor(settings.textColor)
                    ColorPicker(
                        "Text Color",
                        selection: $settings.textColor
                    ).foregroundColor(settings.textColor)
                }
            }
        }
    }
}
