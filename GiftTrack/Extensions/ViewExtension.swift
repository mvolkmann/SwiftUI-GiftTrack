import SwiftUI

extension View {
    func dismissKeyboard() {
        UIApplication.shared.sendAction(
            #selector(UIResponder.resignFirstResponder),
            to: nil,
            from: nil,
            for: nil
        )
    }

    @ViewBuilder
    func hideBackground() -> some View {
        if #available(iOS 16, *) {
            // Definitely need this in iOS 16!
            // scrollContentBackground(.hidden).padding(.top, -35)
            self // just until Xcode 14 is out of beta
        } else {
            self
        }
    }

    /// Supports conditional view modifiers.
    /// For example, .if(price > 100) { view in view.background(.orange) }
    /// The concrete type of Content can be any type
    /// that conforms to the View protocol.
    @ViewBuilder
    func `if`<Content: View>(
        _ condition: Bool,
        transform: (Self) -> Content
    ) -> some View {
        // This cannot be replaced by a ternary expression.
        if condition {
            transform(self)
        } else {
            self
        }
    }

    func sysFont(_ size: Int, weight: Font.Weight = .regular) -> some View {
        font(.system(size: CGFloat(size)).weight(weight))
    }
}
