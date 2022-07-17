import SwiftUI

extension Image {
    func circle(diameter: CGFloat) -> some View {
        self
            .resizable()
            .scaledToFill() //TODO: needed?
            .frame(width: diameter, height: diameter)
            .clipShape(Circle())
    }

    // Maybe this should be implemented as a view modifier
    // so it can also be applied to other views like Button and Text.
    func size(_ size: CGFloat) -> some View {
        self.font(.system(size: size))
    }

    func square(size: CGFloat) -> some View {
        self
            .resizable()
            .scaledToFit()
            .frame(width: size, height: size)
        // .clipShape(Rectangle())
    }
}
