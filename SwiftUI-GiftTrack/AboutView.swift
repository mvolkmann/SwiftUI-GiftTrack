import SwiftUI

struct AboutView: View {
    @StateObject var vm: ViewModel

    let intro = """
    This app tracks gift ideas and purchased gifts \
    for multiple people and multiple occasions \
    throughout the year.
    """
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(intro).padding(.bottom)
            Text("To use it, follow the steps below:").padding(.bottom)
            Text("1. Click \"People\" and add people.")
            Text("2. Click \"Occasions\" and add occasions.")
            Text("3. Click \"Gifts\" and add gifts for specific people and occasions.")
        }.padding(.horizontal)
    }
}
