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
        let red = try container.decode(Double.self, forKey: .red)
        let green = try container.decode(Double.self, forKey: .green)
        let blue = try container.decode(Double.self, forKey: .blue)
        self.init(red: red, green: green, blue: blue)
    }

    // MARK: - Properties

    var colorComponents: ColorTuple {
        guard let components = UIColor(self).cgColor.components else {
            return (0, 0, 0, 0)
        }

        let red = components[0]
        let green = components[1]
        let blue = components[2]
        let alpha = components[3]
        return (red, green, blue, alpha)
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
        do {
            return try JSONDecoder().decode(Color.self, from: data)
        } catch {
            print("Color.fromJSON failed: \(error)")
            return .clear
        }
    }

    func toJSON() -> String {
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(self)
            return String(data: data, encoding: .utf8)!
        } catch {
            print("Color.toJSON failed: \(error)")
            return ""
        }
    }
}
