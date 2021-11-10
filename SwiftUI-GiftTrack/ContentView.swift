import SwiftUI

struct ContentView: View {
    var vm = ViewModel()
    
    var body: some View {
        TabView {
            AboutView(vm: vm).tabItem {
                Image(systemName: "info.circle")
                Text("About")
            }
            PeopleView(vm: vm).tabItem {
                Image(systemName: "person.3.fill")
                Text("People")
            }
            OccasionsView(vm: vm).tabItem {
                Image("christmas-tree")
                Text("Occasions")
            }
            GiftsView(vm: vm).tabItem {
                Image(systemName: "gift")
                Text("Gifts")
            }
        }
        .onAppear {
            UITabBar.appearance().backgroundColor = .systemGray5
        }

    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
