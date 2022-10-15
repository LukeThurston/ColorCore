import SwiftUI
#if os(iOS)
import UIKit
#elseif os(macOS)
import AppKit
#endif

extension Color: Codable {
    private struct Components {
        let hex: String
        let alpha: Double
    }
    
    private enum CodingKeys: String, CodingKey {
        case hex
        case alpha
    }
    
    private var components: Components {
        return Components(hex: self.hexRGB ?? "#000000",
                          alpha: Double(rgba?.alpha ?? 1))
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let hex = try container.decode(String.self, forKey: .hex)
        let alpha = try container.decode(Double.self, forKey: .alpha)
        self.init(hex: hex, alpha: alpha)
    }
    
    private init(_ components: Components) {
        self.init(hex: components.hex, alpha: components.alpha)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        let components = self.components
        try container.encode(components.hex, forKey: .hex)
        try container.encode(components.alpha, forKey: .alpha)
    }
}
