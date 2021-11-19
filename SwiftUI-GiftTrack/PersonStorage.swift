import CoreData

class PersonStorage: NSObject, ObservableObject {
    @Published var people: [PersonEntity] = []
    private let controller: NSFetchedResultsController<PersonEntity>
    private var moc: NSManagedObjectContext
        
    init(moc: NSManagedObjectContext) {
        self.moc = moc
        
        let request: NSFetchRequest<PersonEntity> = PersonEntity.fetchRequest()
        // request.predicate = NSPredicate(format: "...")
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]

        controller = NSFetchedResultsController(
            fetchRequest: request,
            managedObjectContext: moc,
            sectionNameKeyPath: nil,
            cacheName: nil
        )

        super.init()

        controller.delegate = self

        do {
            try controller.performFetch()
            people = controller.fetchedObjects ?? []
        } catch {
            print("Error fetching PersonEntity objects:", error.localizedDescription)
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
