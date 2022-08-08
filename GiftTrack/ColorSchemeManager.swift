// This is based on the Stewart Lynch video at
// https://www.youtube.com/watch?v=PbryeZmJRmA.

import SwiftUI

enum MyColorScheme: Int {
    case unspecified, light, dark
}

class ColorSchemeManager: ObservableObject {
    @AppStorage("myColorScheme") var myColorScheme: MyColorScheme = .unspecified {
        didSet {
            applyColorScheme()
        }
    }

    func applyColorScheme() {
        print("ColorSchemeManager.applyColorScheme: myColorScheme = \(String(describing: myColorScheme))")
        firstWindow?.overrideUserInterfaceStyle =
            UIUserInterfaceStyle(rawValue: myColorScheme.rawValue)!
    }

    var firstWindow: UIWindow? {
        guard let scene = UIApplication.shared.connectedScenes.first,
              let windowSceneDelegate = scene.delegate as? UIWindowSceneDelegate,
              let window = windowSceneDelegate.window else {
            return nil
        }

        return window
    }
}
