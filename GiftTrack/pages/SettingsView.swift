import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var settings: Settings
    
    enum Pages: String, CaseIterable {
        case about = "About"
        case people = "People"
        case occasions = "Occasions"
        case gifts = "Gifts"
        case settings = "Settings"
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
                        ColorPicker("Background Color", selection: $settings.bgColor)
                        
                        ColorPicker("Title Color", selection: $settings.titleColor)
                        
                        HStack {
                            Text("Start Page")
                            Spacer()
                            Picker("Start Page", selection: $settings.startPageTag) {
                                ForEach(Pages.allCases.indices, id: \.self) { index in
                                    Text("\(Pages.allCases[index].rawValue)").tag(index)
                                }
                            }
                            .pickerStyle(.menu)
                        }
                        
                        Button("Reset") {
                            deleteData(for: "bgColor")
                            deleteData(for: "startPageTag")
                            deleteData(for: "titleColor")
                            Settings.reset()
                        }
                    }
                    .buttonStyle(MyButtonStyle())
                }
            }
        }
    }
}
