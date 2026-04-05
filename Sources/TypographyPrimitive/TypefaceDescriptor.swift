import CoreGraphics
import Foundation

public enum FontWeight: String, Codable, Sendable, CaseIterable {
    case ultraLight
    case thin
    case light
    case regular
    case medium
    case semibold
    case bold
    case heavy
    case black
}

public enum FontWidth: String, Codable, Sendable, CaseIterable {
    case compressed
    case condensed
    case standard
    case expanded
}

public struct TypefaceDescriptor: Codable, Sendable, Equatable, Hashable {
    public var family: String
    public var weight: FontWeight
    public var width: FontWidth
    public var isItalic: Bool
    public var opticalSize: CGFloat?

    public init(
        family: String,
        weight: FontWeight = .regular,
        width: FontWidth = .standard,
        isItalic: Bool = false,
        opticalSize: CGFloat? = nil
    ) {
        self.family = family
        self.weight = weight
        self.width = width
        self.isItalic = isItalic
        self.opticalSize = opticalSize
    }
}
