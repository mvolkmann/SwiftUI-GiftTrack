import SwiftUI

struct SettingsView: View {
    @State var bgColor = Color(0x002D62)
    @State var textColor = Color.white
    @State var titleColor = Color(0xFFD17A)
    
    //TODO: Save the colors in a way that allows all views to access them.
    //TODO: Use environment?
    //TODO: Remove global color variables in util.swift.

    var body: some View {
        Page {
            Text("Settings")
                .font(.largeTitle)
                .foregroundColor(titleColor)
                .padding(.bottom, 20)

            VStack(spacing: 10) {
                ColorPicker(
                    "Background Color",
                    selection: $bgColor
                ).foregroundColor(textColor)
                ColorPicker(
                    "Title Color",
                    selection: $titleColor
                ).foregroundColor(textColor)
                ColorPicker(
                    "Text Color",
                    selection: $textColor
                ).foregroundColor(textColor)
            }
        }
    }
}
