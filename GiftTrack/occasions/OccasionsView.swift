import SwiftUI

struct OccasionsView: View {
    @Environment(\.managedObjectContext) var moc
    @EnvironmentObject var settings: Settings

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
            print("OccasionsView delete: index = \(index)")
            moc.delete(occasions[index])
            print("OccasionsView delete: success")
        }
        PersistenceController.shared.save()
    }

    private func format(date: Date) -> String {
        dateFormatter.string(from: date)
    }

    var body: some View {
        NavigationView {
            Page {
                // If the iteration is done with List instead of ForEach,
                // we can't use onDelete or onMove.
                // List(vm.occasions, id: \.self) { occasion in
                List {
                    ForEach(occasions, id: \.self) { occasion in
                        NavigationLink(
                            destination: OccasionUpdate(occasion: occasion)
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
                    .onDelete(perform: delete)
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        EditButton()
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        NavigationLink("Add", destination: OccasionAdd())
                    }
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
