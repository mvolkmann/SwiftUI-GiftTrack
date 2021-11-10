import SwiftUI

struct PeopleView: View {
    @StateObject var vm: ViewModel
    
    private func addPerson() {
        print("addPerson entered")
    }

    var body: some View {
        HStack {
            Text("People").font(.largeTitle)
            Button(action: addPerson) {
                Image(systemName: "plus")
            }
        }
    }
}
