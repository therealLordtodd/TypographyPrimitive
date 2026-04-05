import CoreGraphics
import Foundation
import Observation

@MainActor
@Observable
public final class FontManager {
    private var cache: [TypefaceDescriptor: ResolvedTypeface] = [:]

    public init() {}

    public var availableFamilies: [String] {
        FontResolver.availableFamilies
    }

    public func resolve(_ descriptor: TypefaceDescriptor) -> ResolvedTypeface? {
        if let cached = cache[descriptor] {
            return cached
        }

        guard let resolved = FontResolver.resolve(descriptor) else {
            return nil
        }

        cache[descriptor] = resolved
        return resolved
    }

    public func fontsInFamily(_ family: String) -> [TypefaceDescriptor] {
        FontResolver.fontsInFamily(family)
    }

    public func metricsForSize(_ descriptor: TypefaceDescriptor, size: CGFloat) -> TypeMetrics? {
        FontResolver.metrics(for: descriptor, size: size)
    }

    public func clearCache() {
        cache.removeAll()
    }
}
