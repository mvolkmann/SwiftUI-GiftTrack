import CoreData
import SwiftUI

enum GiftMode {
    case add, copy, move, update
}

struct GiftsList: View {
    // MARK: - State

    @AppStorage("titleColor") var titleColor: String = "Title"
    @Environment(\.managedObjectContext) var moc

    @State private var isConfirming = false

    // MARK: - Initializer

    init(
        person: PersonEntity?,
        personIndex: Int,
        occasion: OccasionEntity?,
        occasionIndex: Int
    ) {
        self.person = person
        self.personIndex = personIndex
        self.occasion = occasion
        self.occasionIndex = occasionIndex

        let sortDescriptors = [
            NSSortDescriptor(key: "name", ascending: true)
        ]
        let predicate = NSPredicate(
            format: "to.name == %@ AND reason.name == %@",
            name(person),
            name(occasion)
        )
        request = FetchRequest<GiftEntity>(
            entity: GiftEntity.entity(),
            sortDescriptors: sortDescriptors,
            predicate: predicate
        )
    }

    // MARK: - Properties

    private var person: PersonEntity?
    private var personIndex: Int
    private var occasion: OccasionEntity?
    private var occasionIndex: Int
    private var request: FetchRequest<GiftEntity>

    private var emptyGifts: some View {
        Group {
            if person == nil || occasion == nil {
                Text("No people or occasions have been created yet.")
                    .foregroundColor(Color.fromJSON(titleColor))
                    .padding(.top, 20)
            } else {
                MyText(noGifts, bold: true)
                    .padding(.top, 20)
            }
        }
        .padding(.horizontal, 20)
    }

    private var giftList: some View {
        VStack {
            MyList {
                ForEach(gifts, id: \.self) { gift in
                    NavigationLink(
                        destination: GiftUpdate(
                            personIndex: personIndex,
                            occasionIndex: occasionIndex,
                            gift: gift
                        )
                    ) {
                        HStack {
                            MyText(name(gift))
                            if isValidPrice(gift.price) {
                                Spacer()
                                MyText("$\(gift.price!)")
                            }
                        }
                    }
                }
                .onDelete(perform: delete)
            }

            LabelledText(label: "Total", text: "$\(total)")
                .padding(.top, 5)

            Button("Delete These Gifts", role: .destructive) {
                isConfirming = true
            }
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
        .buttonStyle(MyButtonStyle())
    }

    private var gifts: FetchedResults<GiftEntity> {
        request.wrappedValue
    }

    private var noGifts: String {
        "\(name(person)) has no \(name(occasion)) gifts yet."
    }

    private var total: String {
        let number = gifts.reduce(0.0) { acc, gift in
            if let price = gift.price, let value = Double(price) {
                return acc + value
            } else {
                return acc
            }
        }
        let text = String(format: "%.2f", number)
        return text.hasSuffix(".00") ? String(text.dropLast(3)) : text
    }

    var body: some View {
        if gifts.isEmpty {
            emptyGifts
        } else {
            giftList
        }
    }

    // MARK: - Methods

    private func delete(indexSet: IndexSet) {
        for index in indexSet {
            moc.delete(gifts[index])
        }
        PersistenceController.shared.save()
    }

    private func deleteAll() {
        for gift in gifts {
            moc.delete(gift)
        }
        PersistenceController.shared.save()
    }

    private func isValidPrice(_ price: String?) -> Bool {
        guard let price = price else { return false }
        return !price.isEmpty && Double(price) != 0
    }
}
