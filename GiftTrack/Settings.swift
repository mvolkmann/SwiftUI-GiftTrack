import SwiftUI

class Settings: ObservableObject {
    // @Published var bgColor = Color(0x002D62)
    // @Published var bgColor = Color(UIColor.systemBlue)
    @Published var bgColor = Color("custom-background")
    
    @Published var textColor = Color.primary
    
    // @Published var titleColor = Color(0xFFD17A)
    @Published var titleColor = Color(UIColor.systemYellow)
    
    @Published var literalColor = Color(#colorLiteral(red: 0.01568627451, green: 0.2, blue: 1, alpha: 1))
}
