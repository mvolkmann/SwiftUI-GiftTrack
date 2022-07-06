import SwiftUI

struct LabelledText: View {
    @EnvironmentObject var settings: Settings
    
    let label: String
    let text: String
    
    var body: some View {
        HStack {
            Text("\(label):").fontWeight(.bold)
            Text("\(text.isEmpty ? "none" : text)")
        }
        .font(.system(size: 20))
    }
}
