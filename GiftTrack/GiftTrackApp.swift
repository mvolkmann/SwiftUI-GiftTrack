import SwiftUI

@main
struct GiftTrackApp: App {
    @StateObject var settings = Settings.shared
    @StateObject private var store = StoreKitStore()
    
    @Environment(\.scenePhase) var scenePhase
    
    let pc = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            MainScreen()
                .environment(\.managedObjectContext, pc.container.viewContext)
                .environmentObject(settings)
                .environmentObject(store)
        }
        // Automatically save when changing apps.
        .onChange(of: scenePhase) { _ in pc.save() }
    }
}