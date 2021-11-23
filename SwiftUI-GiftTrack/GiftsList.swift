import CoreData
import SwiftUI

struct GiftsList: View {
    @Environment(\.managedObjectContext) var moc

    var request: FetchRequest<GiftEntity>

    // Computed property
    var gifts: FetchedResults<GiftEntity> {
        request.wrappedValue
    }

    init(person: PersonEntity?, occasion: OccasionEntity?) {
        let personName = person?.name ?? ""
        let occasionName = occasion?.name ?? ""
        print("personName =", personName)
        print("occasionName =", occasionName)

        let sortDescriptors = [
            NSSortDescriptor(key: "name", ascending: true)
        ]
        let predicate = NSPredicate(
            format: "to.name == %@ and reason.name == %@",
            personName,
            occasionName
        )
        request = FetchRequest<GiftEntity>(
            entity: GiftEntity.entity(),
            sortDescriptors: sortDescriptors,
            predicate: predicate
        )
    }

    private func delete(indexSet: IndexSet) {
        for index in indexSet {
            moc.delete(gifts[index])
        }
        PersistenceController.shared.save()
    }

    var body: some View {
        VStack {
            Text("gift count = \(gifts.count)")
            List(request.wrappedValue, id: \.self) { gift in
                Text(gift.name ?? "unnamed gift")
            }
            /*
             List {
                 ForEach(gifts, id: \.self) { gift in
                     NavigationLink(
                         destination: GiftUpdate(gift: gift)
                     ) {
                         HStack {
                             Text(gift.name ?? "unnamed gift")
                             // Show more gift properties here?
                         }
                     }
                 }
                 .onDelete(perform: delete)
             }
             */
        }
    }
}
