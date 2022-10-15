import SwiftUI
#if os(iOS)
import UIKit
#elseif os(macOS)
import AppKit
#endif

// MARK: - Helpers
public extension Color {
    static var random: Color {
        return Color(red: .random(in: 0...1), green: .random(in: 0...1), blue: .random(in: 0...1))
    }
}

// MARK: - Hex
public extension Color {
    init(hex: String, alpha: Double = 1) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (r, g, b) = ((int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (r, g, b) = (int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (r, g, b) = (int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (r, g, b) = (1, 1, 0)
        }
        
        self.init(.sRGB, red: Double(r) / 255, green: Double(g) / 255, blue:  Double(b) / 255, opacity: alpha / 255)
    }
    
    var hexRGB: String? {
        guard let rgba = rgba else { return nil }
        return String(format: "#%02x%02x%02x", Int(rgba.red*255), Int(rgba.green*255), Int(rgba.blue*255))
    }
    
    var hexRGBA: String? {
        guard let rgba = rgba else { return nil }
        return String(format: "#%02x%02x%02x%02x", Int(rgba.red * 255), Int(rgba.green * 255), Int(rgba.blue * 255), Int(rgba.alpha * 255))
    }
}

// MARK: - RGBA
public extension Color {
    typealias RGBA = (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat)
    
#if os(iOS)
    var uiColor: UIColor { .init(self) }
    
    var rgba: RGBA? {
        var (r,g,b,a): RGBA = (0,0,0,0)
        return uiColor.getRed(&r, green: &g, blue: &b, alpha: &a) ? (r,g,b,a) : nil
    }
#elseif os(macOS)
    var nsColor: NSColor { .init(self) }
    
    var rgba: RGBA? {
        return (nsColor.redComponent, nsColor.greenComponent, nsColor.blueComponent, nsColor.alphaComponent)
    }
#endif
}
