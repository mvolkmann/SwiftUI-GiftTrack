import SwiftUI

struct MyTitle: View {
    @AppStorage("titleColor") var titleColor: String = "Title"

    init(
        _ title: String,
        pad: Bool = false
    ) {
        if pad { edgeSet.insert(.leading)}
        self.pad = pad
        self.title = title
    }

    let pad: Bool
    let title: String

    var edgeSet: Edge.Set = [.bottom]

    var body: some View {
        Text(title)
            .font(.largeTitle)
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
