import SwiftUI

struct OccasionsView: View {
    @EnvironmentObject var vm: ViewModel

    var body: some View {
        NavigationView {
            List {}
            .navigationTitle("Occasions")
        }
    }
}
