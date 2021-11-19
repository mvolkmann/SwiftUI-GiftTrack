import SwiftUI

@main
struct SwiftUI_GiftTrack: App {
    @Environment(\.scenePhase) var scenePhase
    //let pc = PersistenceController.shared
    var vm = ViewModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
                //.environment(\.managedObjectContext, pc.container.viewContext)
                .environmentObject(vm)
        }
        //.onChange(of: scenePhase) { _ in pc.save() }
        .onChange(of: scenePhase) { _ in vm.save() }
    }
}
