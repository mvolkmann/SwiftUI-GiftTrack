import CoreData

class PersistenceManager {
  let persistentContainer: NSPersistentContainer = {
      // "Model" is the name of the Model.xcdatamodeld file.
      let container = NSPersistentContainer(name: "Model")
      container.loadPersistentStores(completionHandler: { description, error in
          if let error = error as NSError? {
              let msg = "PersistenceManager: error loading persistent stores"
              fatalError("\(msg): \(error), \(error.userInfo)")
          }
      })
      return container
  }()
}
