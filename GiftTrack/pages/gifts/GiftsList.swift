import CoreData
import SwiftUI

enum GiftMode {
    case add, copy, move, update
}
    
struct GiftsList: View {
    @Environment(\.managedObjectContext) var moc
    @EnvironmentObject var settings: Settings

    @State private var isConfirming = false

    private var person: PersonEntity?
    private var personIndex: Int
    private var occasion: OccasionEntity?
    private var occasionIndex: Int
    private var request: FetchRequest<GiftEntity>

    private var gifts: FetchedResults<GiftEntity> {
        request.wrappedValue
    }

    private var noGifts: String {
        "\(name(person)) has no \(name(occasion)) gifts yet."
    }

    private var total: Int {
        Int(gifts.reduce(0) { acc, gift in acc + gift.price })
    }
    
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
        self.request = FetchRequest<GiftEntity>(
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
        for gift in gifts {
            moc.delete(gift)
        }
        PersistenceController.shared.save()
    }

    var body: some View {
        if gifts.isEmpty {
            Group {
                if person == nil || occasion == nil {
                    Text("No people or occasions have been created yet.")
                        .foregroundColor(settings.titleColor)
                        .padding(.top, 20)
                } else {
                    MyText(noGifts, bold: true)
                        .foregroundColor(settings.titleColor)
                        .padding(.top, 20)
                }
            }
            .padding(.horizontal, 20)
        } else {
            VStack(spacing: 10) {
                List {
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
                                if gift.price != 0 {
                                    Spacer()
                                    MyText("$\(gift.price)")
                                }
                            }
                        }
                    }
                    .onDelete(perform: delete)
                }
                
                LabelledText(label: "Total", text: "\(total)")

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
            .buttonStyle(MyButtonStyle())
            }
        }
    }
}
