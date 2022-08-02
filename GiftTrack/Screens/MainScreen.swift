import SwiftUI

struct MainScreen: View {
    // MAIN: - State

    @AppStorage("backgroundColor") var backgroundColor: String = "Background"
    @AppStorage("startScreen") var startScreen: String = "About"
    @AppStorage("titleColor") var titleColor: String = "Title"

    @Environment(\.colorScheme) var colorScheme

    // @State private var broughtToForeground = false
    @State private var screenTag: String = "About"

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

        // This removes the following console warning:
        // [LayoutConstraints] Unable to simultaneously satisfy constraints.
        // Probably at least one of the constraints in the following list
        // is one you don't want.
        .navigationViewStyle(StackNavigationViewStyle())
    }
}
