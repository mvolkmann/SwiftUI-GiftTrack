import SwiftUI

struct MyTitle: View {
    @AppStorage("titleColor") var titleColor: String = "Title"

    init(
        _ title: String,
        font: Font = .largeTitle,
        pad: Bool = false
    ) {
        self.font = font
        if pad { edgeSet.insert(.leading) }
        self.pad = pad
        self.title = title
    }

    let font: Font
    let pad: Bool
    let title: String

    var edgeSet: Edge.Set = []

    var body: some View {
        Text(title)
            .font(font)
            .fontWeight(.bold)
            .foregroundColor(Color.fromJSON(titleColor))
            .padding(edgeSet, 20)
    }
}

struct MyTitle_Previews: PreviewProvider {
    static var previews: some View {
        MyTitle("This is a Title")
    }
}
