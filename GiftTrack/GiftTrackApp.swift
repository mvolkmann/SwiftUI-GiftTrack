import SwiftUI

@main
struct GiftTrackApp: App {
    // MARK: - State

    @AppStorage("colorsCustomized") var colorsCustomized: Bool = false
    @AppStorage("isDarkMode") private var isDarkMode = false

    @Environment(\.colorScheme) var colorScheme
    @Environment(\.scenePhase) var scenePhase

    @State private var colorSchemeToUse: ColorScheme = .light

    // for in-app purchases
    @StateObject private var store = StoreKitStore()

    // MARK: - Properties

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
                .preferredColorScheme(colorSchemeToUse)
        }
        .onChange(of: colorScheme) { _ in
            print("GiftTrackApp: colorScheme changed")
            if !colorsCustomized { colorSchemeToUse = colorScheme }
        }
        .onChange(of: colorsCustomized) { _ in
            print("GiftTrackApp: isDarkMode = \(sd(isDarkMode))")
            print("GiftTrackApp: colorsCustomized = \(sd(colorsCustomized))")
            if colorsCustomized {
                colorSchemeToUse = isDarkMode ? .dark : .light
            } else {
                colorSchemeToUse = colorScheme
            }
            print("GiftTrackApp: colorSchemeToUse = \(colorSchemeToUse)")
        }
        .onChange(of: scenePhase) { phase in
            if phase == .background { pCtrl.save() }
        }
    }
}
