import SwiftUI

struct MainScreen: View {
    @AppStorage("backgroundColor") var backgroundColor: String = "Background"
    @AppStorage("startScreen") var startScreen: String = "About"

    @Environment(\.colorScheme) var colorScheme

    @State private var broughtToForeground = false
    @State private var screenTag: String = "About"

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

    var body: some View {
        ZStack {
            Color.fromJSON(backgroundColor)
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

            .onAppear {
                screenTag = startScreen
                updateColors()
            }

            // This is triggered when the app moves to the background
            // and then returns to the foreground.
            .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
                // If the color scheme changed, we need to call updateColors.
                // But colorScheme won't be set until onAppear is called.
                // That is why we need the broughtToForeground flag.
                broughtToForeground = true
            }

            .onChange(of: colorScheme) { _ in updateColors() }
        }
        .datePickerStyle(.wheel)

        // This removes the following console warning:
        // [LayoutConstraints] Unable to simultaneously satisfy constraints.
        // Probably at least one of the constraints in the following list
        // is one you don't want.
        .navigationViewStyle(StackNavigationViewStyle())
    }

    private func updateColors() {
        navigationBarColors(
            foreground: Color("Title"),
            background: Color("Background")
        )

        // Set background color for the TabView.
        // Calling this a second time after LoginScreen is rendered doesn't work.
        // This is why we need "tabViewCover" when viewing LoginScreen.
        UITabBar.appearance().backgroundColor =
            UIColor(Color("Background"))

        // Set image and text color for unselected tab items.
        UITabBar.appearance().unselectedItemTintColor =
            UIColor(Color("UnselectedTab"))
    }
}
