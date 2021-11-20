import CoreData

// This is based on the approach described at
// https://www.donnywals.com/fetching-objects-from-core-data-in-a-swiftui-project/

class PersonStorage: NSObject, ObservableObject {
    @Published public private(set) var people: [PersonEntity] = []
    private let controller: NSFetchedResultsController<PersonEntity>
    private var moc: NSManagedObjectContext
        
    init(moc: NSManagedObjectContext) {
        self.moc = moc
        
        let request: NSFetchRequest<PersonEntity> = PersonEntity.fetchRequest()
        // request.predicate = NSPredicate(format: "...") // to filter data
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]

        controller = NSFetchedResultsController(
            fetchRequest: request,
            managedObjectContext: moc,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        super.init() // must call before referencing self
        controller.delegate = self

        do {
            try controller.performFetch()
            people = controller.fetchedObjects ?? []
        } catch {
            print("PersonStorage error fetching:", error.localizedDescription)
        }
    }
    
    func add(name: String, birthday: Date?) {
        let person = PersonEntity(context: moc)
        person.name = name
        if let birthday = birthday { person.birthday = birthday }
        save()
    }
    
    func delete(indexSet: IndexSet) {
        for index in indexSet {
            moc.delete(people[index])
        }
        save()
    }
    
    func move(indexSet: IndexSet, to: Int) {
        people.move(fromOffsets: indexSet, toOffset: to)
    }
    
    func save() {
        do {
            try moc.save()
        } catch {
            print("Error saving PersonEntity:", error.localizedDescription)
        }
    }
}

extension PersonStorage: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(
        _ controller: NSFetchedResultsController<NSFetchRequestResult>
    ) {
        if let newPeople = controller.fetchedObjects as? [PersonEntity] {
            people = newPeople
        }
    }
}
