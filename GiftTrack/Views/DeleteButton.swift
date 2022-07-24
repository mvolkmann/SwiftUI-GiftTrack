import SwiftUI

struct DeleteButton: View {
    let action: () -> Void

    var body: some View {
        IconButton(
            icon: "xmark.circle.fill",
            size: 15,
            color: .gray,
            action: action
        )
    }
}
