import SwiftUI

struct OccasionsScreen: View {
    @Environment(\.managedObjectContext) var moc
    @EnvironmentObject private var settings: Settings
    @EnvironmentObject private var store: StoreKitStore

    @State private var confirmDelete = false
    @State private var deleteSet: IndexSet = IndexSet()
    
    @FetchRequest(
        entity: OccasionEntity.entity(),
        sortDescriptors: [
            NSSortDescriptor(key: "name", ascending: true)
        ]
    ) var occasions: FetchedResults<OccasionEntity>

    private var dateFormatter = DateFormatter()

    private var allowMore: Bool {
        store.appPurchased || occasions.count < 2
    }
    
    init() {
        // Show dates as month/day without year.
        dateFormatter.setLocalizedDateFormatFromTemplate("M/d")
    }

    private func delete(indexSet: IndexSet) {
        for index in indexSet {
            moc.delete(occasions[index])
        }
        PersistenceController.shared.save()
    }

    private func format(date: Date?) -> String {
        guard let date = date else { return "" }
        return dateFormatter.string(from: date)
    }

    var body: some View {
        NavigationView {
            Page {
                List {
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
                                    MyText(format(date: date))
                                }
                            }
                        }
                    }
                    .onDelete() { indexSet in
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
                //ToolbarItem(placement: .navigationBarLeading) { EditButton() }
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(
                        "Add",
                        destination: OccasionForm()
                            .environment(\.canAdd, allowMore)
                    )
                    // This avoids having PersonForm overlap the navigation bar.
                    .navigationBarTitleDisplayMode(.inline)
                    .simultaneousGesture(TapGesture().onEnded {
                        if !allowMore { store.purchaseApp() }
                    })
                }
            }
            .navigationTitle("Occasions")
            .accentColor(settings.titleColor)
        }
        .accentColor(settings.titleColor) // navigation back link color
        .onAppear {
            configureNavigationTitle(color: settings.titleColor)
        }
    }
}