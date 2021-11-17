import SwiftUI

struct ContentView: View {
    var vm = ViewModel()

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
        .environmentObject(vm)
        // .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
