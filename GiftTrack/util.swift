import SwiftUI

// TODO: How can you replace these 3 functions with one?
func name(_ gift: GiftEntity?) -> String {
    gift?.name ?? "unknown"
}

func name(_ occasion: OccasionEntity?) -> String {
    occasion?.name ?? "unknown"
}

func name(_ person: PersonEntity?) -> String {
    person?.name ?? "unknown"
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

extension String {
    func trim() -> String {
        self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
