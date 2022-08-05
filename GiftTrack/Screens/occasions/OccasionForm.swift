import SwiftUI

struct OccasionForm: View {
    // MARK: - State

    @Environment(\.canAdd) var canAdd
    @Environment(\.dismiss) var dismiss
    @Environment(\.managedObjectContext) var moc

    @State private var date = Date.now
    @State private var includeDate = false
    @State private var name = ""
    @State private var showAlert = false

    @FetchRequest(
        entity: OccasionEntity.entity(),
        sortDescriptors: [
            NSSortDescriptor(key: "name", ascending: true)
        ]
    ) var occasions: FetchedResults<OccasionEntity>

    // MARK: - Initializer

    init(occasion: OccasionEntity? = nil) {
        self.occasion = occasion

        if let occasion = occasion {
            _name = State(initialValue: occasion.name ?? "")
            _date = State(initialValue: occasion.date ?? Date.now)
            _includeDate = State(initialValue: occasion.date != nil)
        }
    }

    // MARK: - Properties

    var occasion: OccasionEntity?

    var body: some View {
        Screen {
            if canAdd {
                Form {
                    MyTextField("Name", text: $name, capitalizationType: .words)
                    MyToggle("Include Date", isOn: $includeDate)
                    if includeDate {
                        MyDatePicker(selection: $date, hideYear: true)
                    }
                }
                .hideBackground() // defined in ViewExtension.swift
                .trimTop()
                .navigationBarItems(
                    trailing: Button("Done") { save() }.disabled(name.isEmpty)
                )
            } else {
                MyText("""
                An in-app purchase is required to \
                create more than two occasions.
                """, bold: true)
                    .padding(.top)
            }
        }
        .alert(
            "Duplicate Occasion",
            isPresented: $showAlert,
            actions: {},
            message: {
                Text("An occasion with the name \"\(name)\" already exists.")
            }
        )
    }

    // MARK: - Methods

    private func save() {
        let adding = occasion == nil

        if adding, occasions.contains(where: {
            $0.name?.caseInsensitiveCompare(name) == .orderedSame
        }) {
            showAlert = true
            return
        }

        let toSave = adding ? OccasionEntity(context: moc) : occasion!

        toSave.name = name.trim()
        toSave.date = includeDate ? date : nil

        PersistenceController.shared.save()
        dismiss()
    }
}
