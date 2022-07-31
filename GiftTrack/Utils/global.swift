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

func updateColors(foregroundColor: String, backgroundColor: String) {
    print("updateColors: entered")
    let bgColor = Color.fromJSON(backgroundColor)
    navigationBarColors(
        foreground: Color.fromJSON(foregroundColor),
        background: bgColor
    )

    // TODO: Why does this only work the first time it is run?
    // Set background color for the TabView.
    let appearance = UITabBarAppearance()
    appearance.backgroundColor = UIColor(bgColor)
    let appearance2 = UITabBar.appearance()
    appearance2.scrollEdgeAppearance = appearance
    appearance2.standardAppearance = appearance

    // Set image and text color for unselected tab items.
    appearance2.unselectedItemTintColor =
        UIColor(Color("UnselectedTab"))
}
