import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var settings: Settings

    @State private var newColor: Color = .red

    // See https://www.kairadiagne.com/2020/01/13/nssecurecoding-and-transformable-properties-in-core-data.html
    @FetchRequest(
        entity: SettingsEntity.entity(),
        sortDescriptors: []
    ) var persistedSettings: FetchedResults<SettingsEntity>

    func save() {
        print("saving")
        /*
         var first = persistedSettings.first
         first.bgColor = settings.bgColor
         first.titleColor = settings.titleColor
         first.textColor = settings.textColor
         PersistenceController.shared.save()
         */

        // TODO: Also retrieve colors from Core Data when app starts
        // TODO: and set the "settings" EnvironmentObject.
    }

    var body: some View {
        Page {
            Text("Settings")
                .font(.largeTitle)
                .foregroundColor(settings.titleColor)
                .padding(.bottom, 20)

            Form {
                VStack(spacing: 10) {
                    ColorPicker(
                        "Background Color",
                        selection: $settings.bgColor
                    ).foregroundColor(settings.textColor)

                    ColorPicker(
                        "Title Color",
                        selection: $settings.titleColor
                    ).foregroundColor(settings.textColor)

                    ColorPicker(
                        "Text Color",
                        selection: $settings.textColor
                    ).foregroundColor(settings.textColor)
                }
            }
        }
        .onDisappear(perform: save)
    }
}
