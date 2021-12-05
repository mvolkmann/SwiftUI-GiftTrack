import SwiftUI

class Settings: ObservableObject {
    private static let defaultBgColor = Color("custom-background")
    private static let defaultTitleColor = Color(UIColor.systemYellow)
    private static let defaultStartPageTag = 0
    
    static let iconSize: CGFloat = 40
    static let imageSize: CGFloat = 150

    @Published var bgColor = Settings.defaultBgColor {
        didSet { setData(for: "bgColor", to: bgColor) }
    }

    @Published var startPageTag = Settings.defaultStartPageTag {
        didSet { setData(for: "startPageTag", to: startPageTag) }
    }

    @Published var titleColor = Settings.defaultTitleColor {
        didSet { setData(for: "titleColor", to: titleColor) }
    }

    static var shared = Settings()

    private init() {
        bgColor = getData(
            for: "bgColor",
            defaultingTo: Settings.defaultBgColor
        )
        
        startPageTag = getData(
            for: "startPageTag",
            defaultingTo: Settings.defaultStartPageTag
        )
        
        titleColor = getData(
            for: "titleColor",
            defaultingTo: Settings.defaultTitleColor
        )
    }

    static func reset() {
        shared.bgColor = defaultBgColor
        shared.startPageTag = defaultStartPageTag
        shared.titleColor = defaultTitleColor
    }
}
