import SwiftUI

struct MenuPicker<T>: View where T: NSObject {
    let label: String
    let options: [T]
    let property: String
    var value: Binding<T>

    var body: some View {
        VStack(spacing: 0) {
            Text(label).font(.title2)
            Picker("not shown", selection: value) {
                ForEach(options, id: \.self) { _ in
                    // Text(option.value(forKey: property)).tag(option)
                    Text("FIX THIS")
                }
            }
            .padding()
            .pickerStyle(.menu)
        }
    }
}
