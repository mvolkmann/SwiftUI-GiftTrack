import SwiftUI

struct PeopleView: View {
    @StateObject var vm: ViewModel

    private func addPerson() {
        print("addPerson entered")
    }

    var body: some View {
        Page {
            HStack {
                MyText("People", bold: true)
                Button(action: addPerson) {
                    SFSymbol("plus")
                }
            }
        }
    }
}
