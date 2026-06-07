import Foundation
import UIKit

class LocalPreferencesDataSource: LocalPreferencesDataSourceProtocol {
    private let defaults: UserDefaults
    private let key = "isDarkMode"

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }

    var isDarkMode: Bool {
        get {
            if defaults.object(forKey: key) == nil {
                return UITraitCollection.current.userInterfaceStyle == .dark
            }
            return defaults.bool(forKey: key)
        }
        set {
            defaults.set(newValue, forKey: key)
        }
    }
}
