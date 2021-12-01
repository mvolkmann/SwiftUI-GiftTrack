import SwiftUI

class Settings: ObservableObject {
    private static let defaultBgColor = Color("custom-background")
    private static let defaultTitleColor = Color(UIColor.systemYellow)
    private static let defaultTextColor = Color.primary
    
    static let iconSize: CGFloat = 30
    static let imageSize: CGFloat = 150

    @Published var bgColor = Settings.defaultBgColor
    @Published var titleColor = Settings.defaultTitleColor
    @Published var textColor = Settings.defaultTextColor

    static var shared = Settings()

    private init() {
        bgColor = getData(
            for: "bgColor",
            defaultingTo: Settings.defaultBgColor
        )
        titleColor = getData(
            for: "titleColor",
            defaultingTo: Settings.defaultTitleColor
        )
        textColor = getData(
            for: "textColor",
            defaultingTo: Settings.defaultTextColor
        )
    }

    static func reset() {
        shared.bgColor = defaultBgColor
        shared.titleColor = defaultTitleColor
        shared.textColor = defaultTextColor
    }
}
