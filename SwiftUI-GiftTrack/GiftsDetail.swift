import SwiftUI

struct GiftsDetail: View {
    let person: PersonEntity?
    let occasion: OccasionEntity?
    let gifts: FetchedResults<GiftEntity>

    private var title: String {
        "\(name(person))'s \(name(occasion)) Gifts"
    }

    private var total: Int {
        Int(gifts.reduce(0) { acc, gift in acc + gift.price })
    }

    var body: some View {
        // TODO: How can you pass spacing to Page?
        // Page<<#Content: View#>>(spacing: 10) {
        Page {
            Text(title)
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.yellow)
                .padding(.bottom, 20)
            ScrollView { // TODO: This isn't working!
                ForEach(gifts, id: \.self) { gift in
                    GiftDetail(gift: gift)
                }
            }
            Text("Total: $\(total)")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(textColor)
                .padding(.vertical, 20)
        }
        // .navigationTitle(title)
    }
}
