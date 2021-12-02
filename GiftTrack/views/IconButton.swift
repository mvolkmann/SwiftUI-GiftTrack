import SwiftUI

struct IconButton: View {
    @EnvironmentObject var settings: Settings

    private let action: () -> Void
    private let icon: String
    private let size: CGFloat

    init(
        icon: String,
        size: CGFloat = Settings.iconSize,
        action: @escaping () -> Void
    ) {
        self.action = action
        self.size = size
        self.icon = icon
    }

    var body: some View {
        Button(action: action) {
            Image(systemName: icon)
                .size(size)
                .foregroundColor(settings.bgColor)
        }
        .buttonStyle(.borderless)
    }
}
