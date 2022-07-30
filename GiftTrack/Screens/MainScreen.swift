import SwiftUI

struct MainScreen: View {
    // MAIN: - State

    @AppStorage("backgroundColor") var backgroundColor: String = "Background"
    @AppStorage("startScreen") var startScreen: String = "About"

    @Environment(\.colorScheme) var colorScheme

    @State private var broughtToForeground = false
    @State private var screenTag: String = "About"

    // MAIN: - Initializer

    init() {
        // These lines affect all the views and allow the
        // page background color to show though in List views.
        let tva = UITableView.appearance()
        tva.backgroundColor = .clear
        UITableViewCell.appearance().backgroundColor = .clear

        // Without the next line the TabView background is clear
        // and the page background color shows through.
        UITabBar.appearance().backgroundColor = .systemGray5

        // This removes excess space at the top and bottom of List views.
        tva.contentInset.top = -35
        tva.contentInset.bottom = -35
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
        .accentColor(Color("Title"))

        .datePickerStyle(.wheel)

        .onAppear {
            screenTag = startScreen
            updateColors(backgroundColor: backgroundColor)
        }

        // This is triggered when the app moves to the background
        // and then returns to the foreground.
        .onReceive(NotificationCenter.default.publisher(
            for: UIApplication.willEnterForegroundNotification
        )) { _ in
            // If the color scheme changed, we need to call updateColors.
            // But colorScheme won't be set until onAppear is called.
            // That is why we need the broughtToForeground flag.
            broughtToForeground = true
        }

        .onChange(of: colorScheme) { _ in
            updateColors(backgroundColor: backgroundColor)
        }

        // This removes the following console warning:
        // [LayoutConstraints] Unable to simultaneously satisfy constraints.
        // Probably at least one of the constraints in the following list
        // is one you don't want.
        .navigationViewStyle(StackNavigationViewStyle())
    }
}
