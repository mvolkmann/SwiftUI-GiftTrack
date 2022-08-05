import Foundation

// This holds a publishes string that
// removes non-digit characters every time it is changed.
// It is useful for TextFields that should only contain digits
// such as the price of a gift.
class NumbersOnly: ObservableObject {
    @Published var value = "" {
        didSet {
            let filtered = value.filter(\.isNumber)
            if value != filtered { value = filtered }
        }
    }

    init(_ value: Int) {
        self.value = value == 0 ? "" : String(value)
    }

    init(_ value: Int64) {
        self.value = value == 0 ? "" : String(value)
    }
}
