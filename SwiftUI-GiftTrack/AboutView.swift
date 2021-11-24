// import FontAwesomeSwiftUI
import SwiftUI

struct AboutView: View {
    let intro = """
    This app tracks gift ideas and purchased gifts \
    for multiple people and multiple occasions \
    throughout the year.
    """

    var body: some View {
        Page {
            MyText(intro, bold: true).padding(.bottom)
            MyText(
                "To use it, follow the steps below:",
                bold: true
            ).padding(.bottom)
            MyText("1. Click \"People\" and add people.")
            MyText("2. Click \"Occasions\" and add occasions.")
            MyText("3. Click \"Gifts\" and add gifts for specific people and occasions.")
        }
    }
}
