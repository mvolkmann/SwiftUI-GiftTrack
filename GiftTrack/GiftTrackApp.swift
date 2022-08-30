import SwiftUI

@main
struct GiftTrackApp: App {
    @Environment(\.scenePhase) var scenePhase

    // for in-app purchases
    @StateObject private var store = StoreKitStore()

    @StateObject var csManager = ColorSchemeManager()

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

                // for managing color schemes
                .environmentObject(csManager)
                .onAppear { csManager.applyColorScheme() }
                .alert(
                    "In-App Purchase Failed",
                    isPresented: $store.purchaseFailed,
                    actions: {},
                    message: { Text("The app could not be purchased.") }
                )
        }
        .onChange(of: scenePhase) { phase in
            if phase == .background { pCtrl.save() }
        }
    }
}
