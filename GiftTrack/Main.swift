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

struct MainView: View {
    @StateObject var settings = Settings.shared
    @State private var selection = 3

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
            TabView(selection: $selection) {
                AboutView().tabItem {
                    Image(systemName: "info.circle")
                    Text("About")
                }.tag(0)
                PeopleView().tabItem {
                    Image(systemName: "person.3.fill")
                    Text("People")
                }.tag(1)
                OccasionsView().tabItem {
                    Image("christmas-tree")
                    Text("Occasions")
                }.tag(2)
                GiftsView().tabItem {
                    Image(systemName: "gift")
                    Text("Gifts")
                }.tag(3)
                /* For testing image code.
                 CameraView().tabItem {
                     Image(systemName: "camera")
                     Text("Camera")
                 }
                 .tag(5)
                 */
                SettingsView().tabItem {
                    Image(systemName: "gear")
                    Text("Settings")
                }
                .tag(4)
            }
        }
        .environmentObject(settings)
        // .buttonStyle(MyButtonStyle())
        .datePickerStyle(.wheel)
        // This removes the following console warning:
        // [LayoutConstraints] Unable to simultaneously satisfy constraints.
        // Probably at least one of the constraints in the following list
        // is one you don't want.
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
