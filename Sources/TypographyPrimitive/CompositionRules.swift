import CoreGraphics
import Foundation

public enum KerningMode: Codable, Sendable, Equatable {
    case auto
    case none
    case custom(CGFloat)
}

public enum LineBreakStrategy: String, Codable, Sendable {
    case standard
    case hangulWordPriority
    case pushOut
}

public struct CompositionRules: Codable, Sendable, Equatable {
    public var tracking: CGFloat
    public var kerning: KerningMode
    public var hyphenation: Bool
    public var hyphenationFactor: CGFloat
    public var lineBreakStrategy: LineBreakStrategy

    public init(
        tracking: CGFloat = 0,
        kerning: KerningMode = .auto,
        hyphenation: Bool = false,
        hyphenationFactor: CGFloat = 0.5,
        lineBreakStrategy: LineBreakStrategy = .standard
    ) {
        self.tracking = tracking
        self.kerning = kerning
        self.hyphenation = hyphenation
        self.hyphenationFactor = hyphenationFactor
        self.lineBreakStrategy = lineBreakStrategy
    }

    public static var `default`: CompositionRules { CompositionRules() }
}
