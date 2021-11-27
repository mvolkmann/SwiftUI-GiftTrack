import SwiftUI

class Settings: ObservableObject {
    @Published var bgColor = Color(0x002D62)
    @Published var textColor = Color.white
    @Published var titleColor = Color(0xFFD17A)
}

extension Color {
    init(_ hex: UInt, alpha: Double = 1) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xFF) / 255,
            green: Double((hex >> 8) & 0xFF) / 255,
            blue: Double(hex & 0xFF) / 255,
            opacity: alpha
        )
    }
}
