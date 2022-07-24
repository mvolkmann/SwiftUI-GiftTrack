import SwiftUI

// Returns the value of the "name" property of a given object.
func name(_ object: NSObject?) -> String {
    guard let object = object else { return "unknown" }
    let value = object.value(forKey: "name") as? String
    return value ?? "unknown"
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
