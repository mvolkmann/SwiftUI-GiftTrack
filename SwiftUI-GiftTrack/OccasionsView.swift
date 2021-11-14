import SwiftUI

struct OccasionsView: View {
    @StateObject var vm: ViewModel

    private func addOccasion() {
        print("addOccasion entered")
    }

    var body: some View {
        Page {
            HStack {
                MyText("Occasions", bold: true)
                Button(action: addOccasion) {
                    SFSymbol("plus")
                }
            }
        }
    }
}
