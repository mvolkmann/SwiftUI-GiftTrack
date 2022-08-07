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

    var components: ColorTuple {
        guard let components = UIColor(self).cgColor.components else {
            return (0, 0, 0, 0)
        }

        let red = components[0]
        let green = components[1]
        let blue = components[2]
        let alpha = components[3]
        return (red, green, blue, alpha)
    }

    var isDark: Bool { luminance < 0.2 }

    var json: String {
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(self)
            return String(data: data, encoding: .utf8)!
        } catch {
            print("Color.json failed: \(error)")
            return ""
        }
    }

    var luminance: Double {
        func adjust(colorComponent: CGFloat) -> CGFloat {
            colorComponent < 0.04045 ?
                (colorComponent / 12.92) :
                pow((colorComponent + 0.055) / 1.055, 2.4)
        }

        return 0.2126 * adjust(colorComponent: self.components.red) +
            0.7152 * adjust(colorComponent: self.components.green) +
            0.0722 * adjust(colorComponent: self.components.blue)
    }

    // MARK: - Methods

    func contrastRatio(against color: Color) -> Double {
        let luminance1 = self.luminance
        let luminance2 = color.luminance
        let luminanceDarker = min(luminance1, luminance2)
        let luminanceLighter = max(luminance1, luminance2)
        return (luminanceLighter + 0.05) / (luminanceDarker + 0.05)
    }

    // Encodes a color.
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(components.red, forKey: .red)
        try container.encode(components.green, forKey: .green)
        try container.encode(components.blue, forKey: .blue)
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
}
