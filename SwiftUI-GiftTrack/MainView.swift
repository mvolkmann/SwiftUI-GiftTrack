import SwiftUI

struct MainView: View {
    @State private var selection = 3

    init() {
        // These lines affect all the views and allow the
        // page background color to show though in List views.
        UITableView.appearance().backgroundColor = .clear
        UITableViewCell.appearance().backgroundColor = .clear

        // Without the next line the TabView background is clear
        // and the page background color shows through.
        UITabBar.appearance().backgroundColor = .systemGray5
    }

    var body: some View {
        ZStack {
            bgColor
            // TabView(selection: $selection) {
            TabView {
                AboutView().tabItem {
                    Image(systemName: "info.circle")
                    Text("About")
                }
                PeopleView().tabItem {
                    Image(systemName: "person.3.fill")
                    Text("People")
                }
                OccasionsView().tabItem {
                    Image("christmas-tree")
                    Text("Occasions")
                }
                GiftsView().tabItem {
                    Image(systemName: "gift")
                    Text("Gifts")
                }
                .tag(3)
            }
        }
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
