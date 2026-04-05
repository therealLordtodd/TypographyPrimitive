import Foundation
import Testing
@testable import TypographyPrimitive

@MainActor
@Suite("FontManager Tests")
struct FontManagerTests {
    @Test func availableFamiliesNotEmpty() {
        let manager = FontManager()
        #expect(!manager.availableFamilies.isEmpty)
    }

    @Test func resolveKnownFont() {
        let manager = FontManager()
        let descriptor = TypefaceDescriptor(family: "Helvetica")
        let resolved = manager.resolve(descriptor)
        #expect(resolved != nil)
        #expect((resolved?.ascent ?? 0) > 0)
        #expect((resolved?.descent ?? 0) >= 0)
    }

    @Test func resolveUnknownFontReturnsNil() {
        let manager = FontManager()
        let descriptor = TypefaceDescriptor(family: "ThisFontDoesNotExist_XYZ_123")
        #expect(manager.resolve(descriptor) == nil)
    }

    @Test func resolveCachesResult() {
        let manager = FontManager()
        let descriptor = TypefaceDescriptor(family: "Helvetica", weight: .bold)
        let first = manager.resolve(descriptor)
        let second = manager.resolve(descriptor)

        #expect(first != nil)
        #expect(second != nil)
        #expect(first?.ascent == second?.ascent)
    }

    @Test func metricsAtSize() {
        let manager = FontManager()
        let descriptor = TypefaceDescriptor(family: "Helvetica")
        let metrics12 = manager.metricsForSize(descriptor, size: 12)
        let metrics24 = manager.metricsForSize(descriptor, size: 24)

        #expect(metrics12 != nil)
        #expect(metrics24 != nil)
        #expect((metrics24?.ascent ?? 0) > (metrics12?.ascent ?? 0))
    }

    @Test func fontsInHelveticaFamily() {
        let manager = FontManager()
        let fonts = manager.fontsInFamily("Helvetica")
        #expect(!fonts.isEmpty)
        #expect(fonts.contains { $0.weight == .regular || $0.weight == .medium || $0.weight == .bold })
    }

    @Test func clearCacheWorks() {
        let manager = FontManager()
        let descriptor = TypefaceDescriptor(family: "Helvetica")
        _ = manager.resolve(descriptor)
        manager.clearCache()
        #expect(manager.resolve(descriptor) != nil)
    }
}
