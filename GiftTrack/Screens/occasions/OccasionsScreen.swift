import SwiftUI

struct OccasionsScreen: View {
    // MARK: - State

    @AppStorage("titleColor") var titleColor: String = "Title"

    @Environment(\.managedObjectContext) var moc
    @EnvironmentObject private var store: StoreKitStore

    @State private var confirmDelete = false
    @State private var deleteSet: IndexSet = .init()

    @FetchRequest(
        entity: OccasionEntity.entity(),
        sortDescriptors: [
            NSSortDescriptor(key: "name", ascending: true)
        ]
    ) var occasions: FetchedResults<OccasionEntity>

    // MARK: - Initializer

    // MARK: - Properties

    private var allowMore: Bool {
        // TODO: This temporarily makes in-app purchase unnecessary for debugging.
        // true

        store.appPurchased || occasions.count < 2
    }

    var body: some View {
        NavigationView {
            Screen {
                MyList {
                    ForEach(occasions, id: \.self) { occasion in
                        NavigationLink(
                            destination: OccasionForm(occasion: occasion)
                        ) {
                            HStack {
                                MyText(occasion.name ?? "")
                                // TODO: See the unhelpful error messages you get
                                // TODO: if you change occasion.date to occasion.x!
                                if let date = occasion.date {
                                    Spacer()
                                    MyText(date.monthDay)
                                }
                            }
                        }
                    }
                    .onDelete { indexSet in
                        confirmDelete = true
                        deleteSet = indexSet
                    }
                }
                .confirmationDialog(
                    "Deleting this occasion will also delete " +
                        "all gifts for it.\nAre you sure?",
                    isPresented: $confirmDelete,
                    titleVisibility: .visible
                ) {
                    Button("Yes", role: .destructive) {
                        delete(indexSet: deleteSet)
                    }
                }
            }
            .toolbar {
                // ToolbarItem(placement: .navigationBarLeading) { EditButton() }
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(
                        "Add",
                        destination: OccasionForm()
                            .environment(\.canAdd, allowMore)
                    )
                    .navigationBarTitleDisplayMode(.inline)
                    .simultaneousGesture(TapGesture().onEnded {
                        if !allowMore { store.purchaseApp() }
                    })
                }
            }
            .navigationTitle("Occasions")
            .accentColor(Color.fromJSON(titleColor))
        }
    }

    // MARK: - Methods

    private func delete(indexSet: IndexSet) {
        for index in indexSet {
            moc.delete(occasions[index])
        }
        PersistenceController.shared.save()
    }
}
