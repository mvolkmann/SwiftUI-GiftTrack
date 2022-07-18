import SwiftUI

struct MyTitle: View {
    @AppStorage("titleColor") var titleColor: String = "Title"

    let title: String

    init(_ title: String) {
        self.title = title
    }

    var body: some View {
        Text(title)
            .font(.largeTitle)
            .fontWeight(.bold)
            .foregroundColor(Color.fromJSON(titleColor))
            .padding(.bottom, 20)
    }
}

struct MyTitle_Previews: PreviewProvider {
    static var previews: some View {
        MyTitle("This is a Title")
    }
}
