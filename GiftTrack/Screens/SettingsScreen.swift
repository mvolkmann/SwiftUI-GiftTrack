import SwiftUI

struct SettingsScreen: View {
    // MARK: - State

    @AppStorage("backgroundColor") var backgroundColor: String = "Background"
    @AppStorage("titleColor") var titleColor: String = "Title"
    @AppStorage("startScreen") var startScreen: String = "About"

    // These are both modified in the initializer.
    @State private var selectedBackgroundColor: Color = .clear
    @State private var selectedTitleColor: Color = .clear

    // MARK: - Nested Types

    enum Screens: String, CaseIterable {
        case about = "About"
        case people = "People"
        case occasions = "Occasions"
        case gifts = "Gifts"
        case settings = "Settings"
    }

    // MARK: - Initializer

    init() {
        _selectedBackgroundColor =
            State(initialValue: Color.fromJSON(backgroundColor))
        _selectedTitleColor =
            State(initialValue: Color.fromJSON(titleColor))
    }

    // MARK: - Properties

    var body: some View {
        Screen {
            MyTitle("Settings")

            Form {
                VStack(spacing: 10) {
                    ColorPicker(
                        "Background Color",
                        selection: $selectedBackgroundColor,
                        supportsOpacity: false
                    )
                    .onChange(of: selectedBackgroundColor) { _ in
                        backgroundColor = selectedBackgroundColor.toJSON()
                        updateColors(backgroundColor: backgroundColor)
                    }

                    ColorPicker(
                        "Title Color",
                        selection: $selectedTitleColor,
                        supportsOpacity: false
                    )
                    .onChange(of: selectedTitleColor) { _ in
                        titleColor = selectedTitleColor.toJSON()
                    }

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
