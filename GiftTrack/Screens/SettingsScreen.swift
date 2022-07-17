import SwiftUI

struct SettingsScreen: View {
    @AppStorage("backgroundColor") var backgroundColor: String = "Background"
    @AppStorage("titleColor") var titleColor: String = "Title"
    @AppStorage("startScreen") var startScreen: String = "About"

    enum Screens: String, CaseIterable {
        case about = "About"
        case people = "People"
        case occasions = "Occasions"
        case gifts = "Gifts"
        case settings = "Settings"
    }
    
    var body: some View {
        Screen {
            MyTitle("Settings")

            Form {
                VStack(spacing: 10) {
                    //ColorPicker("Background Color", selection: $backgroundColor)

                    //ColorPicker("Title Color", selection: $titleColor)

                    HStack {
                        Text("Start Page")
                        Spacer()
                        Picker("Start Screen", selection: $startScreen) {
                            ForEach(Screens.allCases.indices, id: \.self) { index in
                                let rawValue = Screens.allCases[index].rawValue
                                Text(rawValue).tag(rawValue)
                                    .foregroundColor(Color("Background"))
                            }
                        }
                        .pickerStyle(.menu)
                        .accentColor(Color("Title"))
                    }

                    Button("Reset") {
                        backgroundColor = "Background"
                        titleColor = "Title"
                        startScreen = "About"
                    }
                }
                .buttonStyle(MyButtonStyle())
            }
        }
    }
}
