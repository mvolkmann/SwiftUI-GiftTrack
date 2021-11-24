import SwiftUI

// TODO: How can you replace these 3 functions with one?
func name(_ gift: GiftEntity?) -> String {
    gift?.name ?? "unknown"
}

func name(_ occasion: OccasionEntity?) -> String {
    occasion?.name ?? "unknown"
}

func name(_ person: PersonEntity?) -> String {
    person?.name ?? "unknown"
}

func configureNavigationTitle() {
    let color = UIColor(titleColor)

    // Change color of the navigation title
    // when displayMode is not .inline.
    let appearance = UINavigationBar.appearance()
    appearance.largeTitleTextAttributes = [.foregroundColor: color]
    // when displayMode is .inline.
    appearance.titleTextAttributes = [.foregroundColor: color]
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

let bgColor = Color(0x002D62)
let textColor = Color.white
let titleColor = Color(0xFFD17A)
