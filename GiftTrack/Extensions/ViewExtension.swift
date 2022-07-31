import SwiftUI

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(
            #selector(UIResponder.resignFirstResponder),
            to: nil,
            from: nil,
            for: nil
        )
    }

    func sysFont(_ size: Int, weight: Font.Weight = .regular) -> some View {
        font(.system(size: CGFloat(size)).weight(weight))
    }
}
