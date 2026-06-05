import Foundation
#if canImport(AppKit)
import AppKit
#endif
#if canImport(UIKit)
import UIKit
#endif
#if canImport(SwiftUI)
import SwiftUI
#endif
#if canImport(DeveloperToolsSupport)
import DeveloperToolsSupport
#endif

#if SWIFT_PACKAGE
private let resourceBundle = Foundation.Bundle.module
#else
private class ResourceBundleClass {}
private let resourceBundle = Foundation.Bundle(for: ResourceBundleClass.self)
#endif

// MARK: - Color Symbols -

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension DeveloperToolsSupport.ColorResource {

    /// The "AccentColor" asset catalog color resource.
    static let accent = DeveloperToolsSupport.ColorResource(name: "AccentColor", bundle: resourceBundle)

    /// The "ff_background" asset catalog color resource.
    static let ffBackground = DeveloperToolsSupport.ColorResource(name: "ff_background", bundle: resourceBundle)

    /// The "ff_on_primary" asset catalog color resource.
    static let ffOnPrimary = DeveloperToolsSupport.ColorResource(name: "ff_on_primary", bundle: resourceBundle)

    /// The "ff_on_surfuce" asset catalog color resource.
    static let ffOnSurfuce = DeveloperToolsSupport.ColorResource(name: "ff_on_surfuce", bundle: resourceBundle)

    /// The "ff_primary" asset catalog color resource.
    static let ffPrimary = DeveloperToolsSupport.ColorResource(name: "ff_primary", bundle: resourceBundle)

    /// The "ff_primary_text" asset catalog color resource.
    static let ffPrimaryText = DeveloperToolsSupport.ColorResource(name: "ff_primary_text", bundle: resourceBundle)

    /// The "ff_surfuce" asset catalog color resource.
    static let ffSurfuce = DeveloperToolsSupport.ColorResource(name: "ff_surfuce", bundle: resourceBundle)

}

// MARK: - Image Symbols -

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension DeveloperToolsSupport.ImageResource {

    /// The "AppLogo" asset catalog image resource.
    static let appLogo = DeveloperToolsSupport.ImageResource(name: "AppLogo", bundle: resourceBundle)

    /// The "basketball" asset catalog image resource.
    static let basketball = DeveloperToolsSupport.ImageResource(name: "basketball", bundle: resourceBundle)

    /// The "cricket" asset catalog image resource.
    static let cricket = DeveloperToolsSupport.ImageResource(name: "cricket", bundle: resourceBundle)

    /// The "football" asset catalog image resource.
    static let football = DeveloperToolsSupport.ImageResource(name: "football", bundle: resourceBundle)

    /// The "home_png" asset catalog image resource.
    static let homePng = DeveloperToolsSupport.ImageResource(name: "home_png", bundle: resourceBundle)

    /// The "leauge_placeholder" asset catalog image resource.
    static let leaugePlaceholder = DeveloperToolsSupport.ImageResource(name: "leauge_placeholder", bundle: resourceBundle)

    /// The "tennis" asset catalog image resource.
    static let tennis = DeveloperToolsSupport.ImageResource(name: "tennis", bundle: resourceBundle)

}

// MARK: - Color Symbol Extensions -

#if canImport(AppKit)
@available(macOS 14.0, *)
@available(macCatalyst, unavailable)
extension AppKit.NSColor {

    /// The "AccentColor" asset catalog color.
    static var accent: AppKit.NSColor {
#if !targetEnvironment(macCatalyst)
        .init(resource: .accent)
#else
        .init()
#endif
    }

    /// The "ff_background" asset catalog color.
    static var ffBackground: AppKit.NSColor {
#if !targetEnvironment(macCatalyst)
        .init(resource: .ffBackground)
#else
        .init()
#endif
    }

    /// The "ff_on_primary" asset catalog color.
    static var ffOnPrimary: AppKit.NSColor {
#if !targetEnvironment(macCatalyst)
        .init(resource: .ffOnPrimary)
#else
        .init()
#endif
    }

    /// The "ff_on_surfuce" asset catalog color.
    static var ffOnSurfuce: AppKit.NSColor {
#if !targetEnvironment(macCatalyst)
        .init(resource: .ffOnSurfuce)
#else
        .init()
#endif
    }

    /// The "ff_primary" asset catalog color.
    static var ffPrimary: AppKit.NSColor {
#if !targetEnvironment(macCatalyst)
        .init(resource: .ffPrimary)
#else
        .init()
#endif
    }

    /// The "ff_primary_text" asset catalog color.
    static var ffPrimaryText: AppKit.NSColor {
#if !targetEnvironment(macCatalyst)
        .init(resource: .ffPrimaryText)
#else
        .init()
#endif
    }

    /// The "ff_surfuce" asset catalog color.
    static var ffSurfuce: AppKit.NSColor {
#if !targetEnvironment(macCatalyst)
        .init(resource: .ffSurfuce)
#else
        .init()
#endif
    }

}
#endif

#if canImport(UIKit)
@available(iOS 17.0, tvOS 17.0, *)
@available(watchOS, unavailable)
extension UIKit.UIColor {

    /// The "AccentColor" asset catalog color.
    static var accent: UIKit.UIColor {
#if !os(watchOS)
        .init(resource: .accent)
#else
        .init()
#endif
    }

    /// The "ff_background" asset catalog color.
    static var ffBackground: UIKit.UIColor {
#if !os(watchOS)
        .init(resource: .ffBackground)
#else
        .init()
#endif
    }

    /// The "ff_on_primary" asset catalog color.
    static var ffOnPrimary: UIKit.UIColor {
#if !os(watchOS)
        .init(resource: .ffOnPrimary)
#else
        .init()
#endif
    }

    /// The "ff_on_surfuce" asset catalog color.
    static var ffOnSurfuce: UIKit.UIColor {
#if !os(watchOS)
        .init(resource: .ffOnSurfuce)
#else
        .init()
#endif
    }

    /// The "ff_primary" asset catalog color.
    static var ffPrimary: UIKit.UIColor {
#if !os(watchOS)
        .init(resource: .ffPrimary)
#else
        .init()
#endif
    }

    /// The "ff_primary_text" asset catalog color.
    static var ffPrimaryText: UIKit.UIColor {
#if !os(watchOS)
        .init(resource: .ffPrimaryText)
#else
        .init()
#endif
    }

    /// The "ff_surfuce" asset catalog color.
    static var ffSurfuce: UIKit.UIColor {
#if !os(watchOS)
        .init(resource: .ffSurfuce)
#else
        .init()
#endif
    }

}
#endif

#if canImport(SwiftUI)
@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension SwiftUI.Color {

    /// The "AccentColor" asset catalog color.
    static var accent: SwiftUI.Color { .init(.accent) }

    /// The "ff_background" asset catalog color.
    static var ffBackground: SwiftUI.Color { .init(.ffBackground) }

    /// The "ff_on_primary" asset catalog color.
    static var ffOnPrimary: SwiftUI.Color { .init(.ffOnPrimary) }

    /// The "ff_on_surfuce" asset catalog color.
    static var ffOnSurfuce: SwiftUI.Color { .init(.ffOnSurfuce) }

    /// The "ff_primary" asset catalog color.
    static var ffPrimary: SwiftUI.Color { .init(.ffPrimary) }

    /// The "ff_primary_text" asset catalog color.
    static var ffPrimaryText: SwiftUI.Color { .init(.ffPrimaryText) }

    /// The "ff_surfuce" asset catalog color.
    static var ffSurfuce: SwiftUI.Color { .init(.ffSurfuce) }

}

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension SwiftUI.ShapeStyle where Self == SwiftUI.Color {

    /// The "AccentColor" asset catalog color.
    static var accent: SwiftUI.Color { .init(.accent) }

    /// The "ff_background" asset catalog color.
    static var ffBackground: SwiftUI.Color { .init(.ffBackground) }

    /// The "ff_on_primary" asset catalog color.
    static var ffOnPrimary: SwiftUI.Color { .init(.ffOnPrimary) }

    /// The "ff_on_surfuce" asset catalog color.
    static var ffOnSurfuce: SwiftUI.Color { .init(.ffOnSurfuce) }

    /// The "ff_primary" asset catalog color.
    static var ffPrimary: SwiftUI.Color { .init(.ffPrimary) }

    /// The "ff_primary_text" asset catalog color.
    static var ffPrimaryText: SwiftUI.Color { .init(.ffPrimaryText) }

    /// The "ff_surfuce" asset catalog color.
    static var ffSurfuce: SwiftUI.Color { .init(.ffSurfuce) }

}
#endif

// MARK: - Image Symbol Extensions -

#if canImport(AppKit)
@available(macOS 14.0, *)
@available(macCatalyst, unavailable)
extension AppKit.NSImage {

    /// The "AppLogo" asset catalog image.
    static var appLogo: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .appLogo)
#else
        .init()
#endif
    }

    /// The "basketball" asset catalog image.
    static var basketball: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .basketball)
#else
        .init()
#endif
    }

    /// The "cricket" asset catalog image.
    static var cricket: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .cricket)
#else
        .init()
#endif
    }

    /// The "football" asset catalog image.
    static var football: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .football)
#else
        .init()
#endif
    }

    /// The "home_png" asset catalog image.
    static var homePng: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .homePng)
#else
        .init()
#endif
    }

    /// The "leauge_placeholder" asset catalog image.
    static var leaugePlaceholder: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .leaugePlaceholder)
#else
        .init()
#endif
    }

    /// The "tennis" asset catalog image.
    static var tennis: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .tennis)
#else
        .init()
#endif
    }

}
#endif

#if canImport(UIKit)
@available(iOS 17.0, tvOS 17.0, *)
@available(watchOS, unavailable)
extension UIKit.UIImage {

    /// The "AppLogo" asset catalog image.
    static var appLogo: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .appLogo)
#else
        .init()
#endif
    }

    /// The "basketball" asset catalog image.
    static var basketball: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .basketball)
#else
        .init()
#endif
    }

    /// The "cricket" asset catalog image.
    static var cricket: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .cricket)
#else
        .init()
#endif
    }

    /// The "football" asset catalog image.
    static var football: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .football)
#else
        .init()
#endif
    }

    /// The "home_png" asset catalog image.
    static var homePng: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .homePng)
#else
        .init()
#endif
    }

    /// The "leauge_placeholder" asset catalog image.
    static var leaugePlaceholder: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .leaugePlaceholder)
#else
        .init()
#endif
    }

    /// The "tennis" asset catalog image.
    static var tennis: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .tennis)
#else
        .init()
#endif
    }

}
#endif

// MARK: - Thinnable Asset Support -

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
@available(watchOS, unavailable)
extension DeveloperToolsSupport.ColorResource {

    private init?(thinnableName: Swift.String, bundle: Foundation.Bundle) {
#if canImport(AppKit) && os(macOS)
        if AppKit.NSColor(named: NSColor.Name(thinnableName), bundle: bundle) != nil {
            self.init(name: thinnableName, bundle: bundle)
        } else {
            return nil
        }
#elseif canImport(UIKit) && !os(watchOS)
        if UIKit.UIColor(named: thinnableName, in: bundle, compatibleWith: nil) != nil {
            self.init(name: thinnableName, bundle: bundle)
        } else {
            return nil
        }
#else
        return nil
#endif
    }

}

#if canImport(AppKit)
@available(macOS 14.0, *)
@available(macCatalyst, unavailable)
extension AppKit.NSColor {

    private convenience init?(thinnableResource: DeveloperToolsSupport.ColorResource?) {
#if !targetEnvironment(macCatalyst)
        if let resource = thinnableResource {
            self.init(resource: resource)
        } else {
            return nil
        }
#else
        return nil
#endif
    }

}
#endif

#if canImport(UIKit)
@available(iOS 17.0, tvOS 17.0, *)
@available(watchOS, unavailable)
extension UIKit.UIColor {

    private convenience init?(thinnableResource: DeveloperToolsSupport.ColorResource?) {
#if !os(watchOS)
        if let resource = thinnableResource {
            self.init(resource: resource)
        } else {
            return nil
        }
#else
        return nil
#endif
    }

}
#endif

#if canImport(SwiftUI)
@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension SwiftUI.Color {

    private init?(thinnableResource: DeveloperToolsSupport.ColorResource?) {
        if let resource = thinnableResource {
            self.init(resource)
        } else {
            return nil
        }
    }

}

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension SwiftUI.ShapeStyle where Self == SwiftUI.Color {

    private init?(thinnableResource: DeveloperToolsSupport.ColorResource?) {
        if let resource = thinnableResource {
            self.init(resource)
        } else {
            return nil
        }
    }

}
#endif

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
@available(watchOS, unavailable)
extension DeveloperToolsSupport.ImageResource {

    private init?(thinnableName: Swift.String, bundle: Foundation.Bundle) {
#if canImport(AppKit) && os(macOS)
        if bundle.image(forResource: NSImage.Name(thinnableName)) != nil {
            self.init(name: thinnableName, bundle: bundle)
        } else {
            return nil
        }
#elseif canImport(UIKit) && !os(watchOS)
        if UIKit.UIImage(named: thinnableName, in: bundle, compatibleWith: nil) != nil {
            self.init(name: thinnableName, bundle: bundle)
        } else {
            return nil
        }
#else
        return nil
#endif
    }

}

#if canImport(AppKit)
@available(macOS 14.0, *)
@available(macCatalyst, unavailable)
extension AppKit.NSImage {

    private convenience init?(thinnableResource: DeveloperToolsSupport.ImageResource?) {
#if !targetEnvironment(macCatalyst)
        if let resource = thinnableResource {
            self.init(resource: resource)
        } else {
            return nil
        }
#else
        return nil
#endif
    }

}
#endif

#if canImport(UIKit)
@available(iOS 17.0, tvOS 17.0, *)
@available(watchOS, unavailable)
extension UIKit.UIImage {

    private convenience init?(thinnableResource: DeveloperToolsSupport.ImageResource?) {
#if !os(watchOS)
        if let resource = thinnableResource {
            self.init(resource: resource)
        } else {
            return nil
        }
#else
        return nil
#endif
    }

}
#endif

