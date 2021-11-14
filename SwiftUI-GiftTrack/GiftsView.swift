import SwiftUI

struct GiftsView: View {
    @StateObject var vm: ViewModel

    private func addGift() {
        print("addGift entered")
    }

    var body: some View {
        Page {
            HStack {
                MyText("Gifts", bold: true)
                Button(action: addGift) {
                    SFSymbol("plus")
                }.foregroundColor(.white)
            }
        }
    }
}
