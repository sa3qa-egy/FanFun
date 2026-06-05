import XCTest
@testable import FanFun

final class HomePresenterTests: XCTestCase {

    var sut: HomePresenter!
    var mockView: MockHomeView!
    var mockRouter: MockAppRouter!

    override func setUp() {
        super.setUp()
        mockView = MockHomeView()
        mockRouter = MockAppRouter()
        sut = HomePresenter(router: mockRouter)
        sut.view = mockView
    }

    override func tearDown() {
        sut = nil
        mockView = nil
        mockRouter = nil
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
}
