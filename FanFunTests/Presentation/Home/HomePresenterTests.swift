import XCTest
@testable import FanFun

final class HomePresenterTests: XCTestCase {

    var sut: HomePresenter!
    var mockView: MockHomeView!
    var mockRouter: MockAppRouter!
    var mockRepository: MockSportsRepository!

    override func setUp() {
        super.setUp()
        mockView = MockHomeView()
        mockRouter = MockAppRouter()
        mockRepository = MockSportsRepository()
        sut = HomePresenter(router: mockRouter, repository: mockRepository)
        sut.view = mockView
    }

    override func tearDown() {
        sut = nil
        mockView = nil
        mockRouter = nil
        mockRepository = nil
        super.tearDown()
    }

    func test_viewDidLoad_reloadsCollectionView() {
        sut.viewDidLoad()

        XCTAssertEqual(mockView.reloadCollectionViewCallCount, 1,
                       "viewDidLoad must trigger reloadCollectionView exactly once")
    }

    func test_viewDidLoad_sportsListIsNotEmpty() {
        sut.viewDidLoad()

        XCTAssertGreaterThan(sut.numberOfSports, 0,
                             "Sports list must not be empty after viewDidLoad")
    }

    func test_numberOfSports_afterViewDidLoad_isFour() {
        sut.viewDidLoad()

        XCTAssertEqual(sut.numberOfSports, 4,
                       "There should always be exactly 4 sports")
    }

    func test_numberOfSports_beforeViewDidLoad_isZero() {
        XCTAssertEqual(sut.numberOfSports, 0,
                       "Sports list should be empty before viewDidLoad is called")
    }

    func test_getSport_atIndexZero_isFootball() {
        sut.viewDidLoad()

        let sport = sut.getSport(at: 0)

        XCTAssertEqual(sport.name, "Football",
                       "First sport should be Football")
    }

    func test_getSport_atIndexThree_isBasketball() {
        sut.viewDidLoad()

        let sport = sut.getSport(at: 3)

        XCTAssertEqual(sport.name, "Basketball",
                       "Fourth sport should be Basketball")
    }

    func test_didSelectSport_callsNavigateToLeagueScreen() {
        sut.viewDidLoad()

        sut.didSelectSport(at: 0)

        XCTAssertEqual(mockRouter.navigateToLeagueScreenCallCount, 1,
                       "Selecting a sport must call navigateToLeagueScreen once")
    }

    func test_didSelectSport_passesCorrectSportType() {
        sut.viewDidLoad()

        sut.didSelectSport(at: 1)

        XCTAssertEqual(mockRouter.lastLeagueScreenSportType, "Tennis",
                       "Router must receive the selected sport's name")
    }

    func test_viewDidLoad_appliesThemeFromRepository() {
        mockRepository.isDarkMode = true
        sut.viewDidLoad()
        
        XCTAssertEqual(mockView.applyThemeCallCount, 1)
        XCTAssertTrue(mockView.lastAppliedThemeIsDark == true)
    }

    func test_toggleTheme_togglesRepositoryIsDarkMode() {
        mockRepository.isDarkMode = false
        sut.toggleTheme()
        
        XCTAssertTrue(mockRepository.isDarkMode, "Repository's isDarkMode should be toggled to true")
        XCTAssertEqual(mockView.applyThemeCallCount, 1)
        XCTAssertTrue(mockView.lastAppliedThemeIsDark == true)
    }
}
