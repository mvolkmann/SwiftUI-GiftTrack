import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var settings: Settings

    @State private var newColor: Color = .red

    func save() {
        setData(for: "bgColor", to: settings.bgColor)
        setData(for: "titleColor", to: settings.titleColor)
        setData(for: "textColor", to: settings.textColor)
    }

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

                    Button("Reset") {
                        deleteData(for: "bgColor")
                        deleteData(for: "titleColor")
                        deleteData(for: "textColor")
                        Settings.reset()
                    }
                }
            }
            .buttonStyle(MyButtonStyle())
        }
        .onDisappear(perform: save)
    }
}
