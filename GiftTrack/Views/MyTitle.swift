import SwiftUI

struct MyTitle: View {
    @AppStorage("titleColor") var titleColor: String = "Title"

    private let smallTitle: Font = .system(size: 20).weight(.bold)

    init(
        _ title: String,
        small: Bool = false,
        pad: Bool = false,
        usesKeyboard: Bool = false
    ) {
        self.small = small
        self.pad = pad
        self.usesKeyboard = usesKeyboard
        self.title = title

        if pad { edgeSet.insert(.leading) }
    }

    let pad: Bool
    let small: Bool
    let title: String
    let usesKeyboard: Bool

    var edgeSet: Edge.Set = []

    var body: some View {
        HStack {
            Text(title)
                .font(small ? smallTitle : .largeTitle)
                .fontWeight(.bold)
                .foregroundColor(Color.fromJSON(titleColor))
                .padding(edgeSet, 20)
            if usesKeyboard {
                Spacer()
                Button(action: dismissKeyboard) {
                    Image(systemName: "keyboard.chevron.compact.down")
                }
                .padding(.trailing)
            }
        }
    }
}

struct MyTitle_Previews: PreviewProvider {
    static var previews: some View {
        MyTitle("This is a Title")
    }
}
