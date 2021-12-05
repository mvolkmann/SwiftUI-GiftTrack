import SwiftUI

@main
struct SwiftUI_GiftTrack: App {
    @StateObject private var store = StoreKitStore()
    
    @Environment(\.scenePhase) var scenePhase
    
    let pc = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            MainView()
                .environment(\.managedObjectContext, pc.container.viewContext)
                .environmentObject(store)
        }
        // Automatically save when changing apps.
        .onChange(of: scenePhase) { _ in pc.save() }
    }
}
