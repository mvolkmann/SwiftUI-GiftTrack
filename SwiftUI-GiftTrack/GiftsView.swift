import SwiftUI

struct GiftsView: View {
    @EnvironmentObject var vm: ViewModel

    var body: some View {
        NavigationView {
            List {}
            .navigationTitle("Gifts")
        }
    }
}
