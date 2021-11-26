import SwiftUI

extension Color {
    init(hex: String) {
        var s: String =
            hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if s.hasPrefix("#") {
            s.remove(at: s.startIndex)
        }

        var red = 0.0
        var green = 0.0
        var blue = 0.0

        if (s.count) == 6 {
            var rgbValue: UInt64 = 0
            Scanner(string: s).scanHexInt64(&rgbValue)

            red = Double((rgbValue & 0xFF0000) >> 16) / 255.0
            green = Double((rgbValue & 0x00FF00) >> 8) / 255.0
            blue = Double(rgbValue & 0x0000FF) / 255.0
        }

        self.init(
            red: CGFloat(red),
            green: CGFloat(green),
            blue: CGFloat(blue),
            opacity: CGFloat(1.0)
        )
    }
}
