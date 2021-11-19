import CoreData
import Foundation

class ViewModel: ObservableObject {
    let container: NSPersistentContainer
    var context: NSManagedObjectContext { container.viewContext }
    
    @Published var gifts: [GiftEntity] = []
    @Published var people: [PersonEntity] = []
    @Published var occasions: [OccasionEntity] = []

    init() {
        container = NSPersistentContainer(name: "Model")
        container.loadPersistentStores { _, error in
            if let error = error {
                print("error loading Core Data:", error)
            } else {
                print("loaded Core Data")
                self.fetchPeople()
                self.fetchOccasions()
                self.fetchGifts()
            }
        }
    }
    
    func addGift(
        name: String,
        desc: String = "",
        price: Decimal = 0,
        url: String = "",
        location: String = ""
    ) {
        let gift = GiftEntity(context: context)
        gift.name = name
        //if let birthday = birthday { person.birthday = birthday }
        save()
        gifts.append(gift)
        gifts.sort { ($0.name ?? "") < ($1.name ?? "") }
    }
    
    func addOccasion(name: String, date: Date?) {
            let occasion = OccasionEntity(context: context)
            occasion.name = name
            if let date = date { occasion.date = date }
            save()
            occasions.append(occasion)
            occasions.sort { ($0.name ?? "") < ($1.name ?? "") }
        }
    
    func addPerson(name: String, birthday: Date?) {
        let person = PersonEntity(context: context)
        person.name = name
        if let birthday = birthday { person.birthday = birthday }
        save()
        people.append(person)
        people.sort { ($0.name ?? "") < ($1.name ?? "") }
    }
    
    func deleteGift(indexSet: IndexSet) {
        for index in indexSet {
            context.delete(gifts[index])
            gifts.remove(at: index)
        }
        save()
    }
    

    func deleteOccasions(indexSet: IndexSet) {
        for index in indexSet {
            context.delete(occasions[index])
            occasions.remove(at: index)
        }
        save()
    }
    
    func deletePeople(indexSet: IndexSet) {
        for index in indexSet {
            context.delete(people[index])
            people.remove(at: index)
        }
        save()
    }
    
    func fetchGifts() {
        let request = NSFetchRequest<GiftEntity>(entityName: "GiftEntity")
        request.sortDescriptors = [
            NSSortDescriptor(key: "name", ascending: true)
        ]
        do {
            gifts = try context.fetch(request)
        } catch {
            print("fetchGifts error:", error.localizedDescription)
        }
    }
    
    func fetchOccasions() {
        let request = NSFetchRequest<OccasionEntity>(entityName: "OccasionEntity")
        request.sortDescriptors = [
            NSSortDescriptor(key: "name", ascending: true)
        ]
        do {
            occasions = try context.fetch(request)
        } catch {
            print("fetchOccasion error:", error.localizedDescription)
        }
    }
    
    func fetchPeople() {
        let request = NSFetchRequest<PersonEntity>(entityName: "PersonEntity")
        request.sortDescriptors = [
            NSSortDescriptor(key: "name", ascending: true)
        ]
        do {
            people = try context.fetch(request)
        } catch {
            print("fetchPeople error:", error.localizedDescription)
        }
    }
    
    func movePeople(indexSet: IndexSet, to: Int) {
        people.move(fromOffsets: indexSet, toOffset: to)
    }
    
    func save() {
        do {
            try context.save()
        } catch {
            print("save error:", error)
        }
    }
    
    func update(person: PersonEntity) {
        let id = person.objectID
        if let index = people.firstIndex(where: { $0.objectID == id }) {
            people[index] = person
            save()
        }
    }
}
