import CoreData
import SwiftUI

// TODO: Can you make this work with an NSObject array?
// struct TitledWheelPicker<T>: View where T: NSObject {
struct TitledWheelPicker<T>: View where T: NSFetchRequestResult {
    // MARK: - State

    @AppStorage("titleColor") var titleColor: String = "Title"

    // MARK: - Constants

    private let padding: CGFloat = 15
    private let pickerHeight: CGFloat = 200
    private let textHeight: CGFloat = 30

    // MARK: - Properties

    let title: String
    // let options: [T]
    let options: FetchedResults<T>
    let property: String
    let selectedIndex: Binding<Int>

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color(UIColor.systemBackground)
                VStack(spacing: 0) {
                    Text(title)
                        .font(.title2)
                        .foregroundColor(Color.fromJSON(titleColor))
                    Picker(title, selection: selectedIndex) {
                        ForEach(options.indices, id: \.self) { index in
                            MyText(value(options[index] as! NSObject)).tag(index)
                        }
                    }
                    .frame(width: pickerWidth(geometry), height: pickerHeight)
                    .pickerStyle(.wheel)
                }
                .frame(height: pickerHeight + textHeight)
            }
            .cornerRadius(10)
        }
    }

    // MARK: - Methods

    func pickerWidth(_ geometry: GeometryProxy) -> CGFloat {
        let width = geometry.size.width
        return width == 0 ? 0 : max(0, (width - padding * 3) / 2)
    }

    func value(_ object: NSObject) -> String {
        let v = object.value(forKey: property) as? String
        return v ?? ""
    }
}
