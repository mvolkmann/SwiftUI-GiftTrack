import SwiftUI

struct GiftDetail: View {
    @EnvironmentObject var settings: Settings

    let gift: GiftEntity

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(name(gift))
                    .foregroundColor(settings.bgColor)
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
                Link(destination: url, label: {
                    Text("website")
                        .foregroundColor(settings.bgColor)
                        .underline()
                })
            }
        }
        .frame(maxWidth: .infinity)
        .padding(5)
        .background(.white)
        .cornerRadius(10)
    }
}
