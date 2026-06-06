import XCTest
@testable import FanFun

class LocalPreferencesDataSourceTests: XCTestCase {
    var sut: LocalPreferencesDataSource!
    var mockUserDefaults: UserDefaults!

    override func setUp() {
        super.setUp()
        mockUserDefaults = UserDefaults(suiteName: "MockLocalPreferencesDataSourceTests")
        mockUserDefaults.removePersistentDomain(forName: "MockLocalPreferencesDataSourceTests")
        sut = LocalPreferencesDataSource(defaults: mockUserDefaults)
    }

    override func tearDown() {
        mockUserDefaults.removePersistentDomain(forName: "MockLocalPreferencesDataSourceTests")
        sut = nil
        mockUserDefaults = nil
        super.tearDown()
    }

    func test_isDarkMode_setsAndGetsCorrectly() {
        sut.isDarkMode = true
        XCTAssertTrue(sut.isDarkMode)
        XCTAssertTrue(mockUserDefaults.bool(forKey: "isDarkMode"))
        
        sut.isDarkMode = false
        XCTAssertFalse(sut.isDarkMode)
        XCTAssertFalse(mockUserDefaults.bool(forKey: "isDarkMode"))
    }
}
