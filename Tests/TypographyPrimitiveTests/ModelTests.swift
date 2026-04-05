import Foundation
import Testing
@testable import TypographyPrimitive

@Suite("TypographyPrimitive Model Tests")
struct ModelTests {
    @Test func typefaceDescriptorDefaults() {
        let descriptor = TypefaceDescriptor(family: "Helvetica")
        #expect(descriptor.weight == .regular)
        #expect(descriptor.width == .standard)
        #expect(descriptor.isItalic == false)
        #expect(descriptor.opticalSize == nil)
    }

    @Test func typefaceDescriptorCodableRoundTrip() throws {
        let descriptor = TypefaceDescriptor(
            family: "Georgia",
            weight: .bold,
            width: .condensed,
            isItalic: true,
            opticalSize: 12
        )
        let data = try JSONEncoder().encode(descriptor)
        let decoded = try JSONDecoder().decode(TypefaceDescriptor.self, from: data)
        #expect(decoded == descriptor)
    }

    @Test func resolvedTypefaceLineHeight() {
        let resolved = ResolvedTypeface(
            descriptor: TypefaceDescriptor(family: "Helvetica"),
            ascent: 14,
            descent: 4,
            leading: 2,
            xHeight: 8,
            capHeight: 12,
            unitsPerEm: 1000
        )

        #expect(resolved.lineHeight == 20)
    }

    @Test func openTypeFeaturesDefaults() {
        let features = OpenTypeFeatures.default
        #expect(features.ligatures == .standard)
        #expect(features.smallCaps == .none)
        #expect(features.fractions == false)
    }

    @Test func openTypeFeaturesCodableRoundTrip() throws {
        let features = OpenTypeFeatures(
            ligatures: .all,
            numberStyle: .oldstyle,
            numberSpacing: .tabular,
            smallCaps: .fromLowercase,
            fractions: true,
            ordinals: true,
            stylisticAlternates: [1, 3, 5]
        )

        let data = try JSONEncoder().encode(features)
        let decoded = try JSONDecoder().decode(OpenTypeFeatures.self, from: data)
        #expect(decoded == features)
    }

    @Test func compositionRulesDefaults() {
        let rules = CompositionRules.default
        #expect(rules.tracking == 0)
        #expect(rules.kerning == .auto)
        #expect(rules.hyphenation == false)
    }

    @Test func compositionRulesCodableRoundTrip() throws {
        let rules = CompositionRules(
            tracking: 0.5,
            kerning: .custom(1.2),
            hyphenation: true,
            hyphenationFactor: 0.8,
            lineBreakStrategy: .pushOut
        )

        let data = try JSONEncoder().encode(rules)
        let decoded = try JSONDecoder().decode(CompositionRules.self, from: data)
        #expect(decoded == rules)
    }

    @Test func fontWeightCaseIterable() {
        #expect(FontWeight.allCases.count == 9)
    }
}
