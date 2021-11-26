import SwiftUI

// This is a custom view modifier intended to be applied to buttons.
struct Prominent: ViewModifier {
    func body(content: Content) -> some View {
        content.font(.system(size: 17, weight: .bold))
    }
}

extension View {
    func prominent() -> some View {
        modifier(Prominent())
    }
}
