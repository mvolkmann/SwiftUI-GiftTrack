// import FontAwesomeSwiftUI
import SwiftUI

struct AboutView: View {
    @EnvironmentObject var settings: Settings

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
            }
            .padding(.horizontal, 15)
        }
    }
}
