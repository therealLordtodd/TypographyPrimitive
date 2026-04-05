import Foundation

public enum LigatureMode: String, Codable, Sendable {
    case none
    case standard
    case all
}

public enum NumberStyle: String, Codable, Sendable {
    case lining
    case oldstyle
}

public enum NumberSpacing: String, Codable, Sendable {
    case proportional
    case tabular
}

public enum SmallCapsMode: String, Codable, Sendable {
    case none
    case fromLowercase
    case fromUppercase
}

public struct OpenTypeFeatures: Codable, Sendable, Equatable {
    public var ligatures: LigatureMode
    public var numberStyle: NumberStyle
    public var numberSpacing: NumberSpacing
    public var smallCaps: SmallCapsMode
    public var fractions: Bool
    public var ordinals: Bool
    public var stylisticAlternates: Set<Int>

    public init(
        ligatures: LigatureMode = .standard,
        numberStyle: NumberStyle = .lining,
        numberSpacing: NumberSpacing = .proportional,
        smallCaps: SmallCapsMode = .none,
        fractions: Bool = false,
        ordinals: Bool = false,
        stylisticAlternates: Set<Int> = []
    ) {
        self.ligatures = ligatures
        self.numberStyle = numberStyle
        self.numberSpacing = numberSpacing
        self.smallCaps = smallCaps
        self.fractions = fractions
        self.ordinals = ordinals
        self.stylisticAlternates = stylisticAlternates
    }

    public static var `default`: OpenTypeFeatures { OpenTypeFeatures() }
}
