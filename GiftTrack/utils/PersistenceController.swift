import CoreData

struct PersistenceController {
    static let shared = PersistenceController()
    let container = NSPersistentContainer(name: "CoreDataModel") // cannot be private
    //let description = persistentContainer.persistentStoreDescriptions.first
    //description?.setOption(true as NSNumber, forKey: NSPersistentHistoryTrackingKey)

    init() {
        // Load from Core Data.
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Error: \(error.localizedDescription)")
            }
        }
    }

    func save() {
        let moc = container.viewContext
        if moc.hasChanges {
            do {
                try moc.save()
            } catch {
                fatalError("Error saving: \(error.localizedDescription)")
            }
        }
    }
}
