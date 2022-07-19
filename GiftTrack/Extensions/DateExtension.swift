import Foundation

extension Date {
    // Returns a String representation of the Date in "month/day" format.
    var md: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "M/d"
        return dateFormatter.string(from: self)
    }

    // Returns a String representation of the Date in "month/day/year" format.
    var mdy: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "M/d/yyyy"
        return dateFormatter.string(from: self)
    }
}
