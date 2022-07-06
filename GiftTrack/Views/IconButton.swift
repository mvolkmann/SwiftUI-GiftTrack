import SwiftUI

struct IconButton: View {
    @EnvironmentObject var settings: Settings

    private let action: () -> Void
    private let color: Color?
    private let icon: String
    private let size: CGFloat

    init(
        icon: String,
        size: CGFloat = Settings.iconSize,
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
                .foregroundColor(color ?? settings.bgColor)
        }
        .buttonStyle(.borderless)
    }
}
