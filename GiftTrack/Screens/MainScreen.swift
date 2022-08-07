import SwiftUI

struct MainScreen: View {
    // MAIN: - State

    @AppStorage("backgroundColor") var backgroundColor: String = "Background"
    @AppStorage("colorsCustomized") var colorsCustomized: Bool = false
    @AppStorage("startScreen") var startScreen: String = "About"
    @AppStorage("titleColor") var titleColor: String = "Title"

    @Environment(\.colorScheme) var colorScheme

    @State private var osScheme: ColorScheme = .light
    @State private var screenTag: String = "About"
    @State private var updatingScheme: Bool = false
    @State private var useScheme: ColorScheme = .light

    // MAIN: - Initializer

    init() {
        // These lines affect all the views and allow the
        // page background color to show though in List views.
        let tva = UITableView.appearance()
        tva.backgroundColor = .clear
        UITableViewCell.appearance().backgroundColor = .clear

        // This removes excess space at the top and bottom of List views.
        tva.contentInset.top = -35
        tva.contentInset.bottom = -35

        // Set background color for the TabView.
        // This only work the first time it is run.
        // It is set to clear so the background color can show through.
        UITabBar.appearance().backgroundColor = .clear
    }

    // MAIN: - Properties

    var body: some View {
        TabView(selection: $screenTag) {
            AboutScreen().tabItem {
                Label("About", systemImage: "info.circle")
            }.tag("About")

            PeopleScreen().tabItem {
                Label("People", systemImage: "person.3.fill")
            }.tag("People")

            OccasionsScreen().tabItem {
                Image("ChristmasTree")
                    .renderingMode(.template)
                    .foregroundColor(Color("Title"))
                Text("Occasions")
            }.tag("Occasions")

            GiftsScreen().tabItem {
                Label("Gifts", systemImage: "gift")
            }.tag("Gifts")

            SettingsScreen().tabItem {
                Label("Settings", systemImage: "gear")
            }.tag("Settings")
        }

        // Set image and text color for the selected tab item.
        .accentColor(Color.fromJSON(titleColor))

        .datePickerStyle(.wheel)

        .onAppear {
            screenTag = startScreen
            updateColors(
                foregroundColor: titleColor,
                backgroundColor: backgroundColor
            )
        }

        .onChange(of: backgroundColor) { _ in
            updatingScheme = true
            updateColorScheme()
        }

        .onChange(of: colorScheme) { newColorScheme in
            print("MainScreen: colorScheme = \(colorScheme)")
            print("MainScreen: newColorScheme = \(newColorScheme)")
            print("MainScreen: updatingScheme = \(sd(updatingScheme))")
            if updatingScheme {
                updatingScheme = false
            } else {
                osScheme = newColorScheme
                print("MainScreen: osScheme = \(osScheme)")
                updateColorScheme()
            }
        }

        // TODO: Calling this seems to prevent
        // TODO: onChange(of: colorScheme) from being called!
        .preferredColorScheme(useScheme)

        // This removes the following console warning:
        // [LayoutConstraints] Unable to simultaneously satisfy constraints.
        .navigationViewStyle(StackNavigationViewStyle())
    }

    func updateColorScheme() {
        useScheme =
           !colorsCustomized ? osScheme :
           Color.fromJSON(backgroundColor).isDark ? .dark :
           .light
        print("MainScreen.updateColorScheme: useScheme = \(useScheme)")
    }
}
