import SwiftUI

struct PersonUpdate: View {
    var person: PersonEntity
    
    var body: some View {
        PersonForm(person: person)
    }
}
