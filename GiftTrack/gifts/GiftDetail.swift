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

            Text(gift.purchased ? "already purchased" : "not yet purchased")

            if let url = gift.url {
                Link(destination: url) {
                    Text("website")
                        .foregroundColor(settings.bgColor)
                        .underline()
                }
                .buttonStyle(.borderless)
            }

            if let imageUrl = gift.imageUrl, !imageUrl.isEmpty {
                AsyncImage(
                    url: URL(string: imageUrl),
                    content: { image in
                        image
                            .resizable()
                            .frame(
                                width: Settings.imageSize,
                                height: Settings.imageSize
                            )
                    },
                    placeholder: { ProgressView() } // spinner
                )
            }
    
        if let data = gift.image, let uiImage = UIImage(data: data) {
                Image(uiImage: uiImage).square(size: Settings.imageSize)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(5)
        .background(.white)
        .cornerRadius(10)
    }
}
