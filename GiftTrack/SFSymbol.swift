import SwiftUI

struct SFSymbol: View {
    @EnvironmentObject var settings: Settings

    private let name: String
    private let size: CGFloat

    init(_ name: String, size: Int = 24) {
        self.name = name
        self.size = CGFloat(size)
    }

    var body: some View {
        Image(systemName: name).font(.system(size: size))
            .foregroundColor(settings.textColor)
    }
}
