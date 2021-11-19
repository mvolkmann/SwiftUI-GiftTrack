import SwiftUI

@main
struct SwiftUI_GiftTrack: App {
    @Environment(\.scenePhase) var scenePhase
    
    let persistenceManager: PersistenceManager
    @StateObject var personStorage: PersonStorage
    
    init() {
        persistenceManager = PersistenceManager()

        let moc = persistenceManager.persistentContainer.viewContext
        let storage = PersonStorage(moc: moc)
        //TODO: Why the underscore?
        self._personStorage = StateObject(wrappedValue: storage)
    }

    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(personStorage)
        }
    }
}
