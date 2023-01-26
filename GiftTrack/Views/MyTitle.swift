import SwiftUI

struct MyTitle: View {
    @AppStorage("titleColor") var titleColor: String = "Title"
    @StateObject private var viewModel = ViewModel.shared

    private let smallTitle: Font = .system(size: 20).weight(.bold)

    init(
        _ title: String,
        small: Bool = false,
        pad: Bool = false
    ) {
        self.small = small
        self.pad = pad
        self.title = title

        if pad { edgeSet.insert(.leading) }
    }

    let pad: Bool
    let small: Bool
    let title: String

    var edgeSet: Edge.Set = []

    var body: some View {
        Text(title)
            .font(small ? smallTitle : .largeTitle)
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
