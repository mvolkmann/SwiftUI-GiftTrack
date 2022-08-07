// This is based on the Stewart Lynch video at
// https://www.youtube.com/watch?v=PbryeZmJRmA.

import SwiftUI

enum ColorScheme: Int {
    case unspecified, light, dark
}

class ColorSchemeManager: ObservableObject {
    @AppStorage("colorScheme") var colorScheme: ColorScheme = .unspecified {
        didSet {
            applyColorScheme()
        }
    }

    func applyColorScheme() {
        print("ColorSchemeManager.applyColorScheme: colorScheme = \(String(describing: colorScheme))")
        keyWindow?.overrideUserInterfaceStyle =
            UIUserInterfaceStyle(rawValue: colorScheme.rawValue)!
    }

    var keyWindow: UIWindow? {
        guard let scene = UIApplication.shared.connectedScenes.first,
              let windowSceneDelegate = scene.delegate as? UIWindowSceneDelegate,
              let window = windowSceneDelegate.window else {
            return nil
        }

        return window
    }
}
