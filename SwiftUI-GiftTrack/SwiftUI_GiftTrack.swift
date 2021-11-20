import SwiftUI

@main
struct SwiftUI_GiftTrack: App {
    @Environment(\.scenePhase) var scenePhase
    let pc = PersistenceController.singleton

    var body: some Scene {
        WindowGroup {
            MainView()
                .environment(\.managedObjectContext, pc.container.viewContext)
        }
        // Automatically save when changing apps.
        .onChange(of: scenePhase) { _ in pc.save() }
    }
}
