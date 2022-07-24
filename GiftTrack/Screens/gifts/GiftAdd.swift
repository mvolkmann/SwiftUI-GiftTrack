import SwiftUI

struct GiftAdd: View {
    @State private var mode = GiftMode.add

    var person: PersonEntity
    var occasion: OccasionEntity

    var body: some View {
        GiftForm(person: person, occasion: occasion, mode: $mode)
    }
}
