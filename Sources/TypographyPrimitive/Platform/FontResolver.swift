import CoreGraphics
import Foundation
#if canImport(AppKit)
import AppKit
#elseif canImport(UIKit)
import UIKit
#endif

enum FontResolver {
    static var availableFamilies: [String] {
        #if canImport(AppKit)
        NSFontManager.shared.availableFontFamilies.sorted()
        #elseif canImport(UIKit)
        UIFont.familyNames.sorted()
        #else
        []
        #endif
    }

    static func resolve(_ descriptor: TypefaceDescriptor) -> ResolvedTypeface? {
        #if canImport(AppKit)
        guard let font = nsFont(for: descriptor, size: 1000) else { return nil }
        return ResolvedTypeface(
            descriptor: descriptor,
            ascent: font.ascender,
            descent: -font.descender,
            leading: font.leading,
            xHeight: font.xHeight,
            capHeight: font.capHeight,
            unitsPerEm: 1000
        )
        #elseif canImport(UIKit)
        guard let font = uiFont(for: descriptor, size: 1000) else { return nil }
        return ResolvedTypeface(
            descriptor: descriptor,
            ascent: font.ascender,
            descent: -font.descender,
            leading: font.leading,
            xHeight: font.xHeight,
            capHeight: font.capHeight,
            unitsPerEm: 1000
        )
        #else
        return nil
        #endif
    }

    static func metrics(for descriptor: TypefaceDescriptor, size: CGFloat) -> TypeMetrics? {
        #if canImport(AppKit)
        guard let font = nsFont(for: descriptor, size: size) else { return nil }
        return TypeMetrics(
            pointSize: size,
            ascent: font.ascender,
            descent: -font.descender,
            leading: font.leading,
            xHeight: font.xHeight,
            capHeight: font.capHeight
        )
        #elseif canImport(UIKit)
        guard let font = uiFont(for: descriptor, size: size) else { return nil }
        return TypeMetrics(
            pointSize: size,
            ascent: font.ascender,
            descent: -font.descender,
            leading: font.leading,
            xHeight: font.xHeight,
            capHeight: font.capHeight
        )
        #else
        return nil
        #endif
    }

    static func fontsInFamily(_ family: String) -> [TypefaceDescriptor] {
        #if canImport(AppKit)
        guard let members = NSFontManager.shared.availableMembers(ofFontFamily: family) else { return [] }
        return members.compactMap { member in
            guard member.count >= 4,
                  let weight = member[2] as? Int,
                  let traitsValue = member[3] as? UInt
            else {
                return nil
            }

            let traits = NSFontTraitMask(rawValue: traitsValue)
            return TypefaceDescriptor(
                family: family,
                weight: fontWeight(from: weight),
                width: traits.contains(.condensedFontMask) ? .condensed : (traits.contains(.expandedFontMask) ? .expanded : .standard),
                isItalic: traits.contains(.italicFontMask)
            )
        }
        #elseif canImport(UIKit)
        return UIFont.fontNames(forFamilyName: family).map { name in
            let lower = name.lowercased()
            return TypefaceDescriptor(
                family: family,
                weight: lower.contains("black") ? .black :
                    lower.contains("heavy") ? .heavy :
                    lower.contains("bold") ? .bold :
                    lower.contains("semibold") ? .semibold :
                    lower.contains("medium") ? .medium :
                    lower.contains("light") ? .light : .regular,
                width: lower.contains("condensed") ? .condensed : .standard,
                isItalic: lower.contains("italic") || lower.contains("oblique")
            )
        }
        #else
        return []
        #endif
    }

    #if canImport(AppKit)
    private static func nsFont(for descriptor: TypefaceDescriptor, size: CGFloat) -> NSFont? {
        var traits: NSFontTraitMask = []
        if descriptor.isItalic { traits.insert(.italicFontMask) }
        if descriptor.weight == .bold || descriptor.weight == .heavy || descriptor.weight == .black || descriptor.weight == .semibold {
            traits.insert(.boldFontMask)
        }
        if descriptor.width == .condensed || descriptor.width == .compressed {
            traits.insert(.condensedFontMask)
        }
        if descriptor.width == .expanded {
            traits.insert(.expandedFontMask)
        }

        if let font = NSFontManager.shared.font(
            withFamily: descriptor.family,
            traits: traits,
            weight: nsFontWeight(descriptor.weight),
            size: size
        ) {
            return font
        }

        return NSFont(name: descriptor.family, size: size)
    }

    private static func nsFontWeight(_ weight: FontWeight) -> Int {
        switch weight {
        case .ultraLight: 1
        case .thin: 2
        case .light: 3
        case .regular: 5
        case .medium: 6
        case .semibold: 8
        case .bold: 9
        case .heavy: 11
        case .black: 13
        }
    }

    private static func fontWeight(from value: Int) -> FontWeight {
        switch value {
        case 0...1: .ultraLight
        case 2: .thin
        case 3...4: .light
        case 5: .regular
        case 6...7: .medium
        case 8: .semibold
        case 9...10: .bold
        case 11...12: .heavy
        default: .black
        }
    }
    #endif

    #if canImport(UIKit)
    private static func uiFont(for descriptor: TypefaceDescriptor, size: CGFloat) -> UIFont? {
        if let exactFont = UIFont(name: descriptor.family, size: size) {
            return exactFont
        }

        let baseDescriptor = UIFontDescriptor(fontAttributes: [.family: descriptor.family])
        var traits: UIFontDescriptor.SymbolicTraits = []
        if descriptor.isItalic { traits.insert(.traitItalic) }
        if descriptor.weight == .bold || descriptor.weight == .heavy || descriptor.weight == .black || descriptor.weight == .semibold {
            traits.insert(.traitBold)
        }
        if descriptor.width == .condensed || descriptor.width == .compressed {
            traits.insert(.traitCondensed)
        }

        let resolvedDescriptor = baseDescriptor.withSymbolicTraits(traits) ?? baseDescriptor
        return UIFont(descriptor: resolvedDescriptor, size: size)
    }
    #endif
}
