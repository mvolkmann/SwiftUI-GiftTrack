import SwiftUI

func addHTTP(_ url: String) -> String {
    if url.isEmpty { return url }
    if url.starts(with: "https://") { return url }
    if url.starts(with: "http://") { return url }
    return "https://" + url
}

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

// This simplifies print statements that use string interpolation
// to print values with types like Bool.
func sd(_ css: CustomStringConvertible) -> String {
    String(describing: css)
}

func updateColors(foregroundColor: String, backgroundColor: String) {
    print("updateColors: entered")
    let bgColor = Color.fromJSON(backgroundColor)
    navigationBarColors(
        foreground: Color.fromJSON(foregroundColor),
        background: bgColor
    )

    // Set image and text color for unselected tab items.
    UITabBar.appearance().unselectedItemTintColor =
        UIColor(Color("UnselectedTab"))
}
