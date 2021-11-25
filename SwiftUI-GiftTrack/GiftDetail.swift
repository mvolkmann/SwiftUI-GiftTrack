import SwiftUI

struct GiftDetail: View {
    let gift: GiftEntity

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(name(gift))
                    .foregroundColor(bgColor)
                if let price = gift.price {
                    Text("- $\(price)")
                }
            }
            .font(.system(size: 20, weight: .bold))

            if let desc = gift.desc {
                Text("Description: \(desc)")
            }

            if let location = gift.location {
                Text("Location: \(location)")
            }

            if let url = gift.url {
                Link("website", destination: url)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(5)
        .background(.white)
        .cornerRadius(10)
    }
}
