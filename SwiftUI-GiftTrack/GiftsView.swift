import SwiftUI

struct GiftsView: View {
    @StateObject var vm: ViewModel
    
    private func addGift() {
        print("addGift entered")
    }

    var body: some View {
        HStack {
            Text("Gifts").font(.largeTitle)
            Button(action: addGift) {
                Image(systemName: "plus")
            }
        }

    }

}
