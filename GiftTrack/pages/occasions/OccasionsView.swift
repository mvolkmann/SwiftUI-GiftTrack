import SwiftUI

struct OccasionsView: View {
    @Environment(\.managedObjectContext) var moc
    @EnvironmentObject var settings: Settings

    @State private var confirmDelete = false
    @State private var deleteSet: IndexSet = IndexSet()
    
    @FetchRequest(
        entity: OccasionEntity.entity(),
        sortDescriptors: [
            NSSortDescriptor(key: "name", ascending: true)
        ]
    ) var occasions: FetchedResults<OccasionEntity>

    private var dateFormatter = DateFormatter()

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

    private func format(date: Date) -> String {
        dateFormatter.string(from: date)
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
                /*
                ToolbarItem(placement: .navigationBarLeading) {
                    EditButton()
                }
                */
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink("Add", destination: OccasionForm())
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
