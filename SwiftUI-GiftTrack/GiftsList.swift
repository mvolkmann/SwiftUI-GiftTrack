import CoreData
import SwiftUI

struct GiftsList: View {
    @Environment(\.managedObjectContext) var moc
    @State private var isConfirming = false

    var occasion: OccasionEntity?
    var person: PersonEntity?
    var request: FetchRequest<GiftEntity>

    private var deleteAllText: String {
        "Delete all \(name(occasion)) gifts for \(name(person))"
    }

    private var gifts: FetchedResults<GiftEntity> {
        request.wrappedValue
    }

    init(person: PersonEntity?, occasion: OccasionEntity?) {
        self.person = person
        self.occasion = occasion

        let sortDescriptors = [
            NSSortDescriptor(key: "name", ascending: true)
        ]
        // TODO: What is wrong with this predicate?
        // TODO: You get gifts if no predicate is used.
        let predicate = NSPredicate(
            format: "to.name == %@ AND reason.name == %@",
            // format: "to.name == %@",
            name(person),
            name(occasion)
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

    private func deleteAll() {
        print("gift count = \(gifts.count)")
        for gift in gifts {
            print("deleting gift \(name(gift))")
            moc.delete(gift)
        }
        PersistenceController.shared.save()
    }

    var body: some View {
        if gifts.isEmpty {
            Text("\(name(person)) has no \(name(occasion)) gifts yet.")
                .foregroundColor(textColor)
                .padding(.top, 20)
        } else {
            VStack {
                List {
                    ForEach(gifts, id: \.self) { gift in
                        NavigationLink(
                            destination: GiftUpdate(gift: gift)
                        ) {
                            HStack {
                                Text(name(gift))
                                // Show more gift properties here?
                            }
                        }
                    }
                    .onDelete(perform: delete)
                }

                NavigationLink(
                    destination: GiftsDetail(
                        person: person,
                        occasion: occasion,
                        gifts: gifts
                    )
                ) {
                    Text("Detail")
                }

                Button(deleteAllText, role: .destructive) {
                    isConfirming = true
                }
                .buttonStyle(.bordered)
                .padding()
                .confirmationDialog(
                    "Are you sure you want to delete these gifts?",
                    isPresented: $isConfirming,
                    titleVisibility: .visible
                ) {
                    Button("Yes", role: .destructive) {
                        deleteAll()
                    }
                }
            }
        }
    }
}
