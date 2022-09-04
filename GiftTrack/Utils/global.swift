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

func navigationBarColors(foreground _: Color, background _: Color) {}

func updateForegroundColor(_ foregroundColor: String) {
    // Set navigation bar title color.
    let appearance = UINavigationBarAppearance()
    let fgColor = Color.fromJSON(foregroundColor)
    appearance.titleTextAttributes = [.foregroundColor: UIColor(fgColor)]
    UINavigationBar.appearance().standardAppearance = appearance

    // Set image and text color for unselected tab items.
    UITabBar.appearance().unselectedItemTintColor =
        UIColor(Color("UnselectedTab"))
}
