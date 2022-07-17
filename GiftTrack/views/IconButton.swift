import SwiftUI

struct IconButton: View {
    @AppStorage("titleColor") var titleColor: String = "Title"

    private let action: () -> Void
    private let color: Color?
    private let icon: String
    private let size: CGFloat

    init(
        icon: String,
        size: CGFloat = 40,
        color: Color? = nil,
        action: @escaping () -> Void
    ) {
        self.icon = icon
        self.size = size
        self.color = color
        self.action = action
    }

    var body: some View {
        Button(action: action) {
            Image(systemName: icon)
                .size(size)
                .foregroundColor(color ?? Color(titleColor))
        }
        .buttonStyle(.borderless)
    }
}
