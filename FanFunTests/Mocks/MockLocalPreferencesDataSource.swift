import Foundation
@testable import FanFun

class MockLocalPreferencesDataSource: LocalPreferencesDataSourceProtocol {
    var stubbedIsDarkMode: Bool = false
    var isDarkModeSetCallCount = 0

    var isDarkMode: Bool {
        get { return stubbedIsDarkMode }
        set { 
            stubbedIsDarkMode = newValue 
            isDarkModeSetCallCount += 1
        }
    }
}
