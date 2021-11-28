import SwiftUI

class Settings: ObservableObject {
    // @Published var bgColor = Color(UIColor.systemBlue)
    @Published var bgColor = Color("custom-background")

    @Published var textColor = Color.primary

    @Published var titleColor = Color(UIColor.systemYellow)
}
