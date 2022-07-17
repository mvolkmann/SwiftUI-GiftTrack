import SwiftUI

@main
struct GiftTrackApp: App {
    @Environment(\.scenePhase) var scenePhase

    // for in-app purchases
    @StateObject private var store = StoreKitStore()

    let pc = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            MainScreen()
                // for Core Data
                .environment(\.managedObjectContext, pc.container.viewContext)

                // for in-app purchases
                .environmentObject(store)
        }
        .onChange(of: scenePhase) { phase in
            if phase == .background { pc.save() }
        }
    }
}
