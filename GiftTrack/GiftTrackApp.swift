import SwiftUI

@main
struct GiftTrackApp: App {
    @AppStorage("isDarkMode") private var isDarkMode = false
    
    @Environment(\.scenePhase) var scenePhase

    // for in-app purchases
    @StateObject private var store = StoreKitStore()

    let pCtrl = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            MainScreen()
                // for Core Data
                .environment(
                    \.managedObjectContext,
                    pCtrl.container.viewContext
                )

                // for in-app purchases
                .environmentObject(store)

                .preferredColorScheme(isDarkMode ? .dark : .light)
        }
        .onChange(of: scenePhase) { phase in
            if phase == .background { pCtrl.save() }
        }
    }
}
