import Foundation

class NumbersOnly: ObservableObject {
    @Published var value = "" {
        didSet {
            let filtered = value.filter { $0.isNumber }
            if value != filtered { value = filtered }
        }
    }

    init(_ value: Int) {
        self.value = String(value)
    }

    init(_ value: Int64) {
        self.value = String(value)
    }
}
