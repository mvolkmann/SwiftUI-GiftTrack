import SwiftUI

func name(_ object: NSObject?) -> String {
    if let object = object {
        let v = object.value(forKey: "name") as? String
        return v ?? "unknown"
    } else {
        return "nil"
    }
}

func configureNavigationTitle(color: Color) {
    let uiColor = UIColor(color)

    // Change color of the navigation title
    // when displayMode is not .inline.
    let appearance = UINavigationBar.appearance()
    appearance.largeTitleTextAttributes = [.foregroundColor: uiColor]
    // when displayMode is .inline.
    appearance.titleTextAttributes = [.foregroundColor: uiColor]
}

private var dateFormatter = DateFormatter()

func format(date: Date?) -> String {
    guard let date = date else { return "" }
    dateFormatter.dateFormat = "M/d/yyyy"
    return dateFormatter.string(from: date)
}

extension String {
    func trim() -> String {
        self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
