import SwiftUI

struct MainView: View {
    var body: some View {
        ZStack {
            Color.blue
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
            }
            .onAppear {
                UITabBar.appearance().backgroundColor = .systemGray5
            }
        }
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
