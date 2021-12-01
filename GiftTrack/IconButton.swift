import SwiftUI

struct IconButton: View {
    @EnvironmentObject var settings: Settings

    private let action: () -> Void
    private let icon: String

    init(icon: String, action: @escaping () -> Void) {
        self.action = action
        self.icon = icon
    }

    var body: some View {
        Button(action: action) {
            Image(systemName: icon)
                .size(Settings.iconSize)
                .foregroundColor(settings.bgColor)
        }
        .buttonStyle(.borderless)
    }
}
