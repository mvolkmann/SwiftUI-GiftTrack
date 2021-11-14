import SwiftUI
//--secondary-color: #ffd17a;

struct Page<Content: View>: View {
    @ViewBuilder let content: () -> Content
    
    var body: some View {
        ZStack {
            Color(hex: "002d62").ignoresSafeArea()
            content()
        }
    }
}
