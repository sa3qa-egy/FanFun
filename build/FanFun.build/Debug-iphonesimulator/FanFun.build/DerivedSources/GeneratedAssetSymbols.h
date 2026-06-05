#import <Foundation/Foundation.h>

#if __has_attribute(swift_private)
#define AC_SWIFT_PRIVATE __attribute__((swift_private))
#else
#define AC_SWIFT_PRIVATE
#endif

/// The resource bundle ID.
static NSString * const ACBundleID AC_SWIFT_PRIVATE = @"com.compny.FanFun";

/// The "AccentColor" asset catalog color resource.
static NSString * const ACColorNameAccentColor AC_SWIFT_PRIVATE = @"AccentColor";

/// The "ff_background" asset catalog color resource.
static NSString * const ACColorNameFfBackground AC_SWIFT_PRIVATE = @"ff_background";

/// The "ff_on_primary" asset catalog color resource.
static NSString * const ACColorNameFfOnPrimary AC_SWIFT_PRIVATE = @"ff_on_primary";

/// The "ff_on_surfuce" asset catalog color resource.
static NSString * const ACColorNameFfOnSurfuce AC_SWIFT_PRIVATE = @"ff_on_surfuce";

/// The "ff_primary" asset catalog color resource.
static NSString * const ACColorNameFfPrimary AC_SWIFT_PRIVATE = @"ff_primary";

/// The "ff_primary_text" asset catalog color resource.
static NSString * const ACColorNameFfPrimaryText AC_SWIFT_PRIVATE = @"ff_primary_text";

/// The "ff_surfuce" asset catalog color resource.
static NSString * const ACColorNameFfSurfuce AC_SWIFT_PRIVATE = @"ff_surfuce";

/// The "AppLogo" asset catalog image resource.
static NSString * const ACImageNameAppLogo AC_SWIFT_PRIVATE = @"AppLogo";

/// The "basketball" asset catalog image resource.
static NSString * const ACImageNameBasketball AC_SWIFT_PRIVATE = @"basketball";

/// The "cricket" asset catalog image resource.
static NSString * const ACImageNameCricket AC_SWIFT_PRIVATE = @"cricket";

/// The "football" asset catalog image resource.
static NSString * const ACImageNameFootball AC_SWIFT_PRIVATE = @"football";

/// The "home_png" asset catalog image resource.
static NSString * const ACImageNameHomePng AC_SWIFT_PRIVATE = @"home_png";

/// The "leauge_placeholder" asset catalog image resource.
static NSString * const ACImageNameLeaugePlaceholder AC_SWIFT_PRIVATE = @"leauge_placeholder";

/// The "tennis" asset catalog image resource.
static NSString * const ACImageNameTennis AC_SWIFT_PRIVATE = @"tennis";

#undef AC_SWIFT_PRIVATE
