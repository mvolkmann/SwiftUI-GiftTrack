import SwiftUI

func name(_ object: NSObject?) -> String {
    if let object = object {
        let v = object.value(forKey: "name") as? String
        return v ?? "unknown"
    } else {
        return "nil"
    }
}

private var dateFormatter = DateFormatter()

func format(date: Date?) -> String {
    guard let date = date else { return "" }
    dateFormatter.dateFormat = "M/d/yyyy"
    return dateFormatter.string(from: date)
}

func navigationBarColors(foreground: Color, background: Color) {
    let uiForeground = UIColor(foreground)
    let appearance = UINavigationBarAppearance()
    appearance.configureWithOpaqueBackground()
    appearance.backgroundColor = UIColor(background)
    appearance.titleTextAttributes = [.foregroundColor: uiForeground]
    appearance.largeTitleTextAttributes = [.foregroundColor: uiForeground]

    let target = UINavigationBar.appearance()
    target.standardAppearance = appearance
    target.compactAppearance = appearance
    target.scrollEdgeAppearance = appearance
    target.tintColor = uiForeground
}
