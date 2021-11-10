import CoreData
import Foundation

class ViewModel: ObservableObject {
    let container: NSPersistentContainer
    var context: NSManagedObjectContext { container.viewContext }
    
    //@Published var dogs: [DogEntity] = []
    //@Published var people: [PersonEntity] = []

    init() {
        container = NSPersistentContainer(name: "Model")
        container.loadPersistentStores { _, error in
            if let error = error {
                print("error loading Core Data:", error)
            } else {
                print("loaded Core Data")
                /*
                self.fetchDogs()
                self.fetchPeople()
                */
            }
        }
    }
}
