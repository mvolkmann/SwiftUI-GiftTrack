import SwiftUI

// This used to determine whether adding a person or occasion is allowed.
private struct CanAddKey: EnvironmentKey {
    static let defaultValue = true
}

extension EnvironmentValues {
    var canAdd: Bool {
        get { self[CanAddKey.self]}
        set { self[CanAddKey.self] = newValue }
    }
}

struct MainScreen: View {
    @EnvironmentObject var settings: Settings
    @State var pageTag = 0

    init() {
        // These lines affect all the views and allow the
        // page background color to show though in List views.
        UITableView.appearance().backgroundColor = .clear
        UITableViewCell.appearance().backgroundColor = .clear

        // Without the next line the TabView background is clear
        // and the page background color shows through.
        UITabBar.appearance().backgroundColor = .systemGray5

        // This removes excess space at the top and bottom of List views.
        UITableView.appearance().contentInset.top = -35
        UITableView.appearance().contentInset.bottom = -35
    }

    var body: some View {
        ZStack {
            settings.bgColor
            TabView(selection: $pageTag) {
                AboutScreen().tabItem {
                    Image(systemName: "info.circle")
                    Text("About")
                }.tag(0)
                PeopleScreen().tabItem {
                    Image(systemName: "person.3.fill")
                    Text("People")
                }.tag(1)
                OccasionsScreen().tabItem {
                    Image("christmas-tree")
                    Text("Occasions")
                }.tag(2)
                GiftsScreen().tabItem {
                    Image(systemName: "gift")
                    Text("Gifts")
                }.tag(3)
                SettingsScreen().tabItem {
                    Image(systemName: "gear")
                    Text("Settings")
                }
                .tag(4)
            }
        }
        .datePickerStyle(.wheel)
        // This removes the following console warning:
        // [LayoutConstraints] Unable to simultaneously satisfy constraints.
        // Probably at least one of the constraints in the following list
        // is one you don't want.
        .navigationViewStyle(StackNavigationViewStyle())
        // Cannot set this in init because settings
        // isn't available until body is evaluated.
        .onAppear() { pageTag = settings.startPageTag }
    }
}
