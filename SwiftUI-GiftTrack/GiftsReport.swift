import SwiftUI

struct GiftsReport: View {
    let person: PersonEntity?
    let occasion: OccasionEntity?
    let gifts: FetchedResults<GiftEntity>

    private var total: Int {
        Int(gifts.reduce(0) { acc, gift in acc + gift.price })
    }

    var body: some View {
        Page {
            Text("\(name(person))'s \(name(occasion)) Gifts")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.yellow)
            ForEach(gifts, id: \.self) { gift in
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
            Text("Total: $\(total)")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(textColor)
        }
    }
}
