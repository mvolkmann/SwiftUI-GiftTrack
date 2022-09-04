import SwiftUI

class ViewModel: ObservableObject {
    // This is a singleton class.
    static let shared = ViewModel()
    private init() {}

    @Published var isKeyboardShown = false
}
