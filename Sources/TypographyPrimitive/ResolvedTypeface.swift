import CoreGraphics
import Foundation

public struct ResolvedTypeface: Sendable, Equatable {
    public var descriptor: TypefaceDescriptor
    public var ascent: CGFloat
    public var descent: CGFloat
    public var leading: CGFloat
    public var xHeight: CGFloat
    public var capHeight: CGFloat
    public var unitsPerEm: CGFloat

    public init(
        descriptor: TypefaceDescriptor,
        ascent: CGFloat,
        descent: CGFloat,
        leading: CGFloat,
        xHeight: CGFloat,
        capHeight: CGFloat,
        unitsPerEm: CGFloat
    ) {
        self.descriptor = descriptor
        self.ascent = ascent
        self.descent = descent
        self.leading = leading
        self.xHeight = xHeight
        self.capHeight = capHeight
        self.unitsPerEm = unitsPerEm
    }

    public var lineHeight: CGFloat {
        ascent + descent + leading
    }
}
