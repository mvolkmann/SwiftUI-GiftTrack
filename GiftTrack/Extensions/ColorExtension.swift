import SwiftUI

// Conforming to RawRepresentable enables storing Color values in AppStorage.
//TODO: Maybe conforming to RawRepresentable is no longer needed.
extension Color: Codable, RawRepresentable {
    enum CodingKeys: String, CodingKey {
        case red, green, blue
    }

    typealias ColorTuple = (
        red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat
    )

    public typealias RawValue = String

    // MARK: - Initializers

    // Adds an initializer for creating a color from a single hex number
    // and an optional alpha value.
    init(_ hex: UInt, alpha: Double = 1) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xFF) / 255,
            green: Double((hex >> 8) & 0xFF) / 255,
            blue: Double(hex & 0xFF) / 255,
            opacity: alpha
        )
    }

    //TODO: Are you using this?
    // Decodes a color.
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let r = try container.decode(Double.self, forKey: .red)
        let g = try container.decode(Double.self, forKey: .green)
        let b = try container.decode(Double.self, forKey: .blue)
        self.init(red: r, green: g, blue: b)
    }

    //TODO: Do you need this?
    public init?(rawValue: RawValue) {
        guard let hex = UInt(rawValue[0...5]) else {
            return nil
        }
        let alpha = Double(rawValue[6...7]) ?? 1
        self.init(hex, alpha: alpha)
    }

    // MARK: - Properties

    //TODO: Do you need this?
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
    
    //TODO: Do you need this?
    public var rawValue: String {
        let r = String(format: "%02X", colorComponents.red)
        let g = String(format: "%02X", colorComponents.green)
        let b = String(format: "%02X", colorComponents.blue)
        let a = String(format: "%02X", colorComponents.alpha)
        return r + g + b + a
    }

    // MARK: - Methods

    //TODO: Are you using this?
    // Encodes a color.
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(colorComponents.red, forKey: .red)
        try container.encode(colorComponents.green, forKey: .green)
        try container.encode(colorComponents.blue, forKey: .blue)
    }
}
