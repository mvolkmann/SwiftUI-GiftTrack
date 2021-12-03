import SwiftUI

class Settings: ObservableObject {
    private static let defaultBgColor = Color("custom-background")
    private static let defaultTitleColor = Color(UIColor.systemYellow)
    
    static let iconSize: CGFloat = 40
    static let imageSize: CGFloat = 150

    @Published var bgColor = Settings.defaultBgColor
    @Published var titleColor = Settings.defaultTitleColor

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
    }

    static func reset() {
        shared.bgColor = defaultBgColor
        shared.titleColor = defaultTitleColor
    }
}
