import SwiftUI

struct SFSymbol: View {
    private let name: String
    private let size: CGFloat

    init(_ name: String, size: Int = 24) {
        self.name = name
        self.size = CGFloat(size)
    }

    var body: some View {
        Image(systemName: name).font(.system(size: size))
            .foregroundColor(textColor)
    }
}
