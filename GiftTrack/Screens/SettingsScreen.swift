import SwiftUI

struct SettingsScreen: View {
    // MARK: - State

    @AppStorage("backgroundColor") var backgroundColor: String = "Background"
    @AppStorage("titleColor") var titleColor: String = "Title"
    @AppStorage("startScreen") var startScreen: String = "About"

    @EnvironmentObject var csManager: ColorSchemeManager

    @State private var resetCount = 0

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

    private var contrast: Double {
        selectedTitleColor.contrastRatio(against: selectedBackgroundColor)
    }

    var body: some View {
        Screen {
            MyTitle("Settings", pad: true)

            Form {
                VStack(spacing: 10) {
                    ColorPicker(
                        "Background Color",
                        selection: $selectedBackgroundColor,
                        supportsOpacity: false
                    )
                    .onChange(of: selectedBackgroundColor) { _ in
                        if resetCount > 0 {
                            resetCount -= 1
                        } else {
                            backgroundColor = selectedBackgroundColor.json
                            csManager.myColorScheme =
                                selectedBackgroundColor.isDark ? .dark : .light
                            update()
                        }
                    }

                    // For color debugging ...
                    // Text("background luminance: \(selectedBackgroundColor.luminance)")
                    // Text("color scheme: \(String(describing: csManager.myColorScheme))")

                    ColorPicker(
                        "Title Color",
                        selection: $selectedTitleColor,
                        supportsOpacity: false
                    )
                    .onChange(of: selectedTitleColor) { _ in
                        if resetCount > 0 {
                            resetCount -= 1
                        } else {
                            titleColor = selectedTitleColor.json
                            update()
                        }
                    }

                    if contrast < 4.5 {
                        Text("Choose colors with more contrast.")
                            .foregroundColor(.red)
                            .fontWeight(.bold)
                    }

                    HStack {
                        Text("Start Screen")
                        Spacer()
                        Picker("", selection: $startScreen) {
                            ForEach(Screens.allCases.indices, id: \.self) { index in
                                let rawValue = Screens.allCases[index].rawValue
                                Text(rawValue).tag(rawValue)
                                    .foregroundColor(Color("Background"))
                            }
                        }
                        .pickerStyle(.menu)
                        .accentColor(Color.fromJSON(titleColor))
                    }

                    Button("Reset", action: reset)
                }
                .buttonStyle(MyButtonStyle())
            }
            .hideBackground() // defined in ViewExtension.swift
        }
    }

    private func reset() {
        // This allows the system color scheme to affect colors.
        csManager.myColorScheme = .unspecified

        backgroundColor = "Background"
        resetCount += 1
        selectedBackgroundColor = Color(backgroundColor)

        titleColor = "Title"
        resetCount += 1
        selectedTitleColor = Color(titleColor)

        startScreen = "About"

        update()
    }

    private func update() {
        updateForegroundColor(titleColor)
    }
}
