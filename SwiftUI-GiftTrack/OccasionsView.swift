import SwiftUI

struct OccasionsView: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(
        entity: OccasionEntity.entity(),
        sortDescriptors: [
            NSSortDescriptor(key: "name", ascending: true)
        ]
    ) var occasions: FetchedResults<OccasionEntity>

    private var dateFormatter = DateFormatter()

    init() {
        dateFormatter.dateFormat = "M/d/yyyy"
    }

    private func delete(indexSet: IndexSet) {
        for index in indexSet {
            moc.delete(occasions[index])
        }
        PersistenceController.shared.save()
    }

    private func format(date: Date) -> String {
        dateFormatter.string(from: date)
    }

    private func move(indexSet: IndexSet, to: Int) {
        // TODO: How can you implement this when using @FetchRequest?
        // This updates the UI, but doesn't save the order.
        // If you navigate to another page and then return to this page,
        // the occasions will return to alphabetical order.
        // $occasions.move(fromOffsets: indexSet, toOffset: to)
    }

    var body: some View {
        NavigationView {
            // If the iteration is done with List instead of ForEach,
            // we can't use onDelete or onMove.
            // List(vm.occasions, id: \.self) { occasion in
            List {
                ForEach(occasions, id: \.self) { occasion in
                    NavigationLink(
                        destination: OccasionUpdate(occasion: occasion)
                    ) {
                        HStack {
                            Text(occasion.name ?? "")
                            // TODO: See the unhelpful error messages you get if
                            // TODO: you change occasion.date to occasion.x!
                            if let date = occasion.date {
                                Spacer()
                                Text(format(date: date))
                            }
                        }
                    }
                }
                .onDelete(perform: delete)
                .onMove(perform: move)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    EditButton()
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink("Add", destination: OccasionAdd())
                }
            }
            .navigationTitle("Occasions")
        }
    }
}
