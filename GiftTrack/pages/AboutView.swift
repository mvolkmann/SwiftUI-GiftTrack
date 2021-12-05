import SwiftUI

struct AboutView: View {
    @EnvironmentObject private var settings: Settings
    @EnvironmentObject private var store: StoreKitStore

    let intro = """
    This app tracks gift ideas and purchased gifts \
    for multiple people and multiple occasions \
    throughout the year.
    """

    var body: some View {
        Page {
            VStack(alignment: .leading) {
                Text("Gift Track")
                    .font(.largeTitle)
                    .foregroundColor(settings.titleColor)
                    .padding(.bottom, 20)
                
                MyText(intro, bold: true).padding(.bottom)
                
                MyText(
                    "To use it, follow the steps below:",
                    bold: true
                ).padding(.bottom)
                
                MyText("1. Tap \"People\" and add people.")
                MyText("2. Tap \"Occasions\" and add occasions.")
                MyText("3. Tap \"Gifts\" and add gifts for specific people and occasions.")
                
                if !store.appPurchased {
                     MyText("""
                     \nYou are using the free version of the app \
                     which is limited to tracking gifts for \
                     two people and two occasions. \
                     If you attempt to add more people or occasions, \
                     you will be prompted to make an in-app purchase \
                     which enables tracking gifts for an \
                     unlimited number of people and occasions.
                     """)
                }
            }
            .padding(.horizontal, 15)
        }
    }
}
