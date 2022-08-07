import SwiftUI

struct SettingsScreen: View {
    // MARK: - State

    @AppStorage("backgroundColor") var backgroundColor: String = "Background"
    @AppStorage("titleColor") var titleColor: String = "Title"
    @AppStorage("startScreen") var startScreen: String = "About"

    @EnvironmentObject var csManager: ColorSchemeManager

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
                        print("SettingsScreen: backgroundColor = \(backgroundColor)")
                        if backgroundColor != "Background" {
                            csManager.colorScheme =
                            selectedBackgroundColor.isDark ? .dark : .light
                            print("SettingsScreen: colorScheme = \(String(describing: csManager.colorScheme))")
                        }
                        backgroundColor = selectedBackgroundColor.json
                        update()
                    }

                    // For color debugging ...`
                    Text("background luminance: \(selectedBackgroundColor.luminance)")

                    ColorPicker(
                        "Title Color",
                        selection: $selectedTitleColor,
                        supportsOpacity: false
                    )
                    .onChange(of: selectedTitleColor) { _ in
                        titleColor = selectedTitleColor.json
                        update()
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

    // TODO: Why does reset need to be called twice
    // TODO: to really reset the color scheme?
    // TODO: Is it a timing issue?
    private func reset() {
        backgroundColor = "Background"
        selectedBackgroundColor = Color(backgroundColor)

        titleColor = "Title"
        selectedTitleColor = Color(titleColor)

        startScreen = "About"
        update()

        // This allows the system color scheme to affect colors.
        csManager.colorScheme = .unspecified
        print("SettingsScreen.reset: changed colorScheme to unspecified")
    }

    private func update() {
        updateColors(
            foregroundColor: titleColor,
            backgroundColor: backgroundColor
        )
    }
}
