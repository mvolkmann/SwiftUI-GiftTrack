import SwiftUI

struct LabelledText: View {
    let label: String
    let text: String

    var body: some View {
        HStack {
            Text("\(label):").fontWeight(.bold)
            Text("\(text.isEmpty ? "none" : text)")
        }
        .font(.system(size: 20))
        .foregroundColor(Color("Text"))
    }
}
