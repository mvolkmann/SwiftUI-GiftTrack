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
        // The default foreground color is Color.primary.
        // It is set here so it can be overridden in Settings.
        .foregroundColor(settings.textColor)
    }
}

struct LabelledText_Previews: PreviewProvider {
    static var previews: some View {
        LabelledText(label: "First Name", text: "Mark")
    }
}
