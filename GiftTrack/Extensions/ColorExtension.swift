import SwiftUI

extension Color: Codable {
    enum CodingKeys: String, CodingKey {
        case red, green, blue
    }

    typealias ColorTuple = (
        red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat
    )

    // MARK: - Initializer

    // Decodes a color.
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let r = try container.decode(Double.self, forKey: .red)
        let g = try container.decode(Double.self, forKey: .green)
        let b = try container.decode(Double.self, forKey: .blue)
        self.init(red: r, green: g, blue: b)
    }

    // MARK: - Properties

    var colorComponents: ColorTuple {
        guard let components = UIColor(self).cgColor.components else {
            return (0, 0, 0, 0)
        }
        
        let r = components[0]
        let g = components[1]
        let b = components[2]
        let a = components[3]
        return (r, g, b, a)
    }

    // MARK: - Methods

    // Encodes a color.
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(colorComponents.red, forKey: .red)
        try container.encode(colorComponents.green, forKey: .green)
        try container.encode(colorComponents.blue, forKey: .blue)
    }

    static func fromJSON(_ json: String) -> Color {
        if !json.starts(with: "{") {
            return Color(json) // an asset Color Set name
        }

        let data = json.data(using: .utf8)!
        return try! JSONDecoder().decode(Color.self, from: data)
    }

    func toJSON() -> String {
        let encoder = JSONEncoder()
        let data = try! encoder.encode(self)
        return String(data: data, encoding: .utf8)!
    }
}
