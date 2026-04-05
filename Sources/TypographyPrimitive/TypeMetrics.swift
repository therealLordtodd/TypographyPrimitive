import CoreGraphics
import Foundation

public struct TypeMetrics: Sendable, Equatable {
    public var pointSize: CGFloat
    public var ascent: CGFloat
    public var descent: CGFloat
    public var leading: CGFloat
    public var lineHeight: CGFloat
    public var xHeight: CGFloat
    public var capHeight: CGFloat

    public init(
        pointSize: CGFloat,
        ascent: CGFloat,
        descent: CGFloat,
        leading: CGFloat,
        xHeight: CGFloat,
        capHeight: CGFloat
    ) {
        self.pointSize = pointSize
        self.ascent = ascent
        self.descent = descent
        self.leading = leading
        self.lineHeight = ascent + descent + leading
        self.xHeight = xHeight
        self.capHeight = capHeight
    }
}
