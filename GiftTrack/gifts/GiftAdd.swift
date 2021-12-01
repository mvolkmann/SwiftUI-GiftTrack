import CodeScanner
import SwiftUI

struct GiftAdd: View {
    var person: PersonEntity
    var occasion: OccasionEntity
    
    var body: some View {
        GiftForm(person: person, occasion: occasion)
    }
}
