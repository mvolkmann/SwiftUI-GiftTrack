import SwiftUI

extension Image {
    func circle(diameter: CGFloat) -> some View {
        resizable()
            .scaledToFill() // TODO: needed?
            .frame(width: diameter, height: diameter)
            .clipShape(Circle())
    }

    func square(size: CGFloat) -> some View {
        resizable()
            .scaledToFit()
            .frame(width: size, height: size)
    }
}
