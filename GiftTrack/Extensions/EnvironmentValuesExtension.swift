import SwiftUI

// This used to determine whether adding a person or occasion is allowed.
private struct CanAddKey: EnvironmentKey {
    static let defaultValue = true
}

extension EnvironmentValues {
    var canAdd: Bool {
        get { self[CanAddKey.self]}
        set { self[CanAddKey.self] = newValue }
    }
}
