import XCTest
@testable import FanFun

final class LeaguesPresenterTests: XCTestCase {

    var sut: LeaguePresenter!
    var mockView: MockLeagueView!
    var mockRepository: MockSportsRepository!
    var mockRouter: MockAppRouter!
    var mockMonitor: MockNetworkMonitor!

    override func setUp() {
        super.setUp()
        mockView = MockLeagueView()
        mockRepository = MockSportsRepository()
        mockRouter = MockAppRouter()
        mockMonitor = MockNetworkMonitor(isConnected: true)
        sut = LeaguePresenter(
            repository: mockRepository,
            router: mockRouter,
            networkMonitor: mockMonitor
        )
        sut.view = mockView
    }

    override func tearDown() {
        sut = nil
        mockView = nil
        mockRepository = nil
        mockRouter = nil
        mockMonitor = nil
        super.tearDown()
    }

    private func seedLeagues(_ leagues: [League]) {
        mockRepository.stubbedLeagues = leagues
        sut.viewDidLoad(sportType: "football")
    }

    func test_viewDidLoad_showsLoadingBeforeFetch() {
        sut.viewDidLoad(sportType: "football")

        XCTAssertEqual(mockView.showLoadingCallCount, 1,
                       "showLoading must be called when the presenter starts fetching")
    }

    func test_viewDidLoad_hidesLoadingAfterSuccess() {
        seedLeagues([TestFixtureFactory.makeLeague()])

        XCTAssertEqual(mockView.hideLoadingCallCount, 1,
                       "hideLoading must be called after the fetch completes")
    }

    func test_viewDidLoad_reloadsTableOnSuccess() {
        seedLeagues([TestFixtureFactory.makeLeague()])

        XCTAssertEqual(mockView.reloadTableViewCallCount, 1,
                       "Table must reload when leagues are received")
    }

    func test_viewDidLoad_whenOnline_hidesOfflineNotice() {
        mockMonitor.stubbedIsConnected = true

        seedLeagues([TestFixtureFactory.makeLeague()])

        XCTAssertEqual(mockView.hideOfflineNoticeCallCount, 1,
                       "Offline notice must be hidden when device is online")
    }

    func test_viewDidLoad_whenOffline_showsOfflineNotice() {
        mockMonitor.stubbedIsConnected = false

        seedLeagues([TestFixtureFactory.makeLeague()])

        XCTAssertEqual(mockView.showOfflineNoticeCallCount, 1,
                       "Offline notice must appear when device is offline")
    }

    func test_viewDidLoad_onError_showsErrorMessage() {
        mockRepository.shouldReturnError = true

        sut.viewDidLoad(sportType: "football")

        XCTAssertNotNil(mockView.lastErrorMessage,
                        "An error from the repository must surface as an error message in the view")
    }

    func test_numberOfLeagues_afterSuccessfulLoad_matchesStubCount() {
        let leagues = [
            TestFixtureFactory.makeLeague(key: 1, name: "EPL"),
            TestFixtureFactory.makeLeague(key: 2, name: "LaLiga")
        ]
        seedLeagues(leagues)

        XCTAssertEqual(sut.numberOfLeagues, 2,
                       "numberOfLeagues must equal the number of leagues returned")
    }

    func test_numberOfLeagues_beforeLoad_isZero() {
        XCTAssertEqual(sut.numberOfLeagues, 0,
                       "numberOfLeagues should be 0 before viewDidLoad is called")
    }

    func test_getLeague_returnsCorrectLeague() {
        let leagues = [
            TestFixtureFactory.makeLeague(key: 10, name: "Bundesliga"),
            TestFixtureFactory.makeLeague(key: 11, name: "Serie A")
        ]
        seedLeagues(leagues)

        let league = sut.getLeague(at: 1)

        XCTAssertEqual(league.leagueKey, 11,
                       "getLeague must return the correct league at the given index")
    }

    func test_filterLeagues_withMatchingQuery_reducesCount() {
        seedLeagues([
            TestFixtureFactory.makeLeague(key: 1, name: "Premier League"),
            TestFixtureFactory.makeLeague(key: 2, name: "LaLiga")
        ])

        sut.filterLeagues(with: "Premier")

        XCTAssertEqual(sut.numberOfLeagues, 1,
                       "Only leagues matching the query should remain")
    }

    func test_filterLeagues_withEmptyQuery_restoresAllLeagues() {
        seedLeagues([
            TestFixtureFactory.makeLeague(key: 1, name: "Premier League"),
            TestFixtureFactory.makeLeague(key: 2, name: "LaLiga")
        ])
        sut.filterLeagues(with: "Premier")

        sut.filterLeagues(with: "")

        XCTAssertEqual(sut.numberOfLeagues, 2,
                       "Clearing the query must restore the full leagues list")
    }

    func test_filterLeagues_withWhitespaceQuery_restoresAllLeagues() {
        seedLeagues([
            TestFixtureFactory.makeLeague(key: 1, name: "Premier League"),
            TestFixtureFactory.makeLeague(key: 2, name: "LaLiga")
        ])

        sut.filterLeagues(with: "   ")

        XCTAssertEqual(sut.numberOfLeagues, 2,
                       "A whitespace-only query should be treated as empty")
    }

    func test_filterLeagues_withNonMatchingQuery_returnsEmpty() {
        seedLeagues([TestFixtureFactory.makeLeague(key: 1, name: "Premier League")])

        sut.filterLeagues(with: "zzzzz")

        XCTAssertEqual(sut.numberOfLeagues, 0,
                       "No leagues should match a non-existent query")
    }

    func test_filterLeagues_isCaseInsensitive() {
        seedLeagues([TestFixtureFactory.makeLeague(key: 1, name: "Premier League")])

        sut.filterLeagues(with: "premier")

        XCTAssertEqual(sut.numberOfLeagues, 1,
                       "Filter should match regardless of letter case")
    }

    func test_filterLeagues_reloadsTableView() {
        seedLeagues([TestFixtureFactory.makeLeague()])
        let callsBefore = mockView.reloadTableViewCallCount

        sut.filterLeagues(with: "EPL")

        XCTAssertGreaterThan(mockView.reloadTableViewCallCount, callsBefore,
                             "filterLeagues must trigger a table reload")
    }

    func test_isFavorite_delegatesToRepository() {
        mockRepository.stubbedIsFavorite = true
        seedLeagues([TestFixtureFactory.makeLeague()])

        XCTAssertTrue(sut.isFavorite(at: 0),
                      "isFavorite must reflect the repository's answer")
    }

    func test_isNotFavorite_delegatesToRepository() {
        mockRepository.stubbedIsFavorite = false
        seedLeagues([TestFixtureFactory.makeLeague()])

        XCTAssertFalse(sut.isFavorite(at: 0),
                       "isFavorite must return false when repo says not favourite")
    }

    func test_toggleFavorite_whenNotFavorite_callsAddFavorite() {
        mockRepository.stubbedIsFavorite = false
        seedLeagues([TestFixtureFactory.makeLeague()])

        sut.toggleFavorite(at: 0)

        XCTAssertEqual(mockRepository.addFavoriteCallCount, 1,
                       "addFavorite should be called when the league is not yet a favourite")
    }

    func test_toggleFavorite_whenAlreadyFavorite_callsRemoveFavorite() {
        mockRepository.stubbedIsFavorite = true
        seedLeagues([TestFixtureFactory.makeLeague()])

        sut.toggleFavorite(at: 0)

        XCTAssertEqual(mockRepository.removeFavoriteCallCount, 1,
                       "removeFavorite should be called when the league is already a favourite")
    }

    func test_toggleFavorite_addPath_updatesViewWithTrue() {
        mockRepository.stubbedIsFavorite = false
        seedLeagues([TestFixtureFactory.makeLeague()])

        sut.toggleFavorite(at: 0)

        XCTAssertEqual(mockView.lastFavoriteStatus, true,
                       "View should be updated with isFavorite=true after adding")
    }

    func test_toggleFavorite_removePath_updatesViewWithFalse() {
        mockRepository.stubbedIsFavorite = true
        seedLeagues([TestFixtureFactory.makeLeague()])

        sut.toggleFavorite(at: 0)

        XCTAssertEqual(mockView.lastFavoriteStatus, false,
                       "View should be updated with isFavorite=false after removing")
    }

    func test_didSelectLeague_whenOnline_navigates() {
        mockMonitor.stubbedIsConnected = true
        seedLeagues([TestFixtureFactory.makeLeague(key: 5, name: "EPL")])

        sut.didSelectLeague(at: 0)

        XCTAssertEqual(mockRouter.navigateToLeagueDetailsCallCount, 1,
                       "Selecting a league when online must navigate to details")
    }

    func test_didSelectLeague_whenOffline_showsError() {
        mockMonitor.stubbedIsConnected = false
        seedLeagues([TestFixtureFactory.makeLeague()])

        sut.didSelectLeague(at: 0)

        XCTAssertNotNil(mockView.lastErrorMessage,
                        "Selecting a league when offline must show an error")
        XCTAssertEqual(mockRouter.navigateToLeagueDetailsCallCount, 0,
                       "Router must NOT be called when offline")
    }

    func test_didSelectLeague_passesCorrectLeagueId() {
        mockMonitor.stubbedIsConnected = true
        seedLeagues([TestFixtureFactory.makeLeague(key: 77, name: "Ligue 1")])

        sut.didSelectLeague(at: 0)

        XCTAssertEqual(mockRouter.lastLeagueDetailsLeagueId, 77,
                       "Router must receive the correct leagueId")
    }
}
