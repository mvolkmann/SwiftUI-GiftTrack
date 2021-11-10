import SwiftUI

struct OccasionsView: View {
    @StateObject var vm: ViewModel
    
    private func addOccasion() {
        print("addOccasion entered")
    }

    var body: some View {
        HStack {
            Text("Occasions").font(.largeTitle)
            Button(action: addOccasion) {
                Image(systemName: "plus")
            }
        }

    }
}
