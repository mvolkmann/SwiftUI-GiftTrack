import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var settings: Settings
    
    @State private var newColor: Color = .red
    
    func save() {
        setData(for: "bgColor", to: settings.bgColor)
        setData(for: "titleColor", to: settings.titleColor)
    }
    
    var body: some View {
        Page {
            VStack(alignment: .leading) {
                Text("Settings")
                    .font(.largeTitle)
                    .foregroundColor(settings.titleColor)
                    .padding(.horizontal)
                    .padding(.bottom, 20)
                
                Form {
                    VStack(spacing: 10) {
                        ColorPicker(
                            "Background Color",
                            selection: $settings.bgColor
                        )
                        
                        ColorPicker(
                            "Title Color",
                            selection: $settings.titleColor
                        )
                        
                        Button("Reset") {
                            deleteData(for: "bgColor")
                            deleteData(for: "titleColor")
                            Settings.reset()
                        }
                    }
                    .buttonStyle(MyButtonStyle())
                }
            }
        }
        .onDisappear(perform: save)
    }
}
