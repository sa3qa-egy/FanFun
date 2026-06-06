import XCTest
@testable import FanFun

final class FavoritesPresenterTests: XCTestCase {

    var sut: FavoritesPresenter!
    var mockView: MockFavoritesView!
    var mockRepository: MockSportsRepository!
    var mockRouter: MockAppRouter!

    override func setUp() {
        super.setUp()
        mockView = MockFavoritesView()
        mockRepository = MockSportsRepository()
        mockRouter = MockAppRouter()
        sut = FavoritesPresenter(repository: mockRepository, router: mockRouter)
        sut.view = mockView
    }

    override func tearDown() {
        sut = nil
        mockView = nil
        mockRepository = nil
        mockRouter = nil
        super.tearDown()
    }

    private func seedOneFavouriteAndLoad() {
        let league = TestFixtureFactory.makeLeague(key: 1, name: "Premier League")
        mockRepository.stubbedAllFavorites = ["football": [league]]
        sut.viewWillAppear()
    }

    func test_viewWillAppear_whenNoFavorites_showsEmptyState() {
        mockRepository.stubbedAllFavorites = [:]

        sut.viewWillAppear()

        XCTAssertEqual(mockView.showEmptyStateCallCount, 1,
                       "Empty favorites must trigger showEmptyState")
    }

    func test_viewWillAppear_whenNoFavorites_doesNotShowSections() {
        mockRepository.stubbedAllFavorites = [:]

        sut.viewWillAppear()

        XCTAssertEqual(sut.numberOfSections, 0,
                       "Sections count must be 0 when there are no favorites")
    }

    func test_viewWillAppear_whenNoFavorites_reloadsData() {
        mockRepository.stubbedAllFavorites = [:]

        sut.viewWillAppear()

        XCTAssertEqual(mockView.reloadDataCallCount, 1,
                       "reloadData must always be called after loading favorites")
    }

    func test_viewWillAppear_withFavorites_hidesEmptyState() {
        seedOneFavouriteAndLoad()

        XCTAssertEqual(mockView.hideEmptyStateCallCount, 1,
                       "hideEmptyState must be called when favorites exist")
    }

    func test_viewWillAppear_withFavorites_reloadsData() {
        seedOneFavouriteAndLoad()

        XCTAssertGreaterThanOrEqual(mockView.reloadDataCallCount, 1,
                                    "reloadData must be called after loading favorites")
    }

    func test_numberOfSections_withOneFootballLeague_isOne() {
        seedOneFavouriteAndLoad()

        XCTAssertEqual(sut.numberOfSections, 1,
                       "One sport with favorites should produce one section")
    }

    func test_numberOfSections_withTwoSports_isTwo() {
        mockRepository.stubbedAllFavorites = [
            "football": [TestFixtureFactory.makeLeague(key: 1, name: "EPL")],
            "tennis":   [TestFixtureFactory.makeLeague(key: 2, name: "ATP")]
        ]

        sut.viewWillAppear()

        XCTAssertEqual(sut.numberOfSections, 2,
                       "Two sports should produce two sections")
    }

    func test_sectionTitle_isCapitalized() {
        seedOneFavouriteAndLoad()

        let title = sut.sectionTitle(for: 0)

        XCTAssertEqual(title, "Football",
                       "Section title should be the sport name capitalized")
    }

    func test_numberOfLeagues_inFirstSection_matchesStubCount() {
        let leagues = [
            TestFixtureFactory.makeLeague(key: 1, name: "EPL"),
            TestFixtureFactory.makeLeague(key: 2, name: "LaLiga")
        ]
        mockRepository.stubbedAllFavorites = ["football": leagues]
        sut.viewWillAppear()

        XCTAssertEqual(sut.numberOfLeagues(in: 0), 2,
                       "Section league count must match the repository stub")
    }

    func test_getLeague_returnsCorrectLeague() {
        let league = TestFixtureFactory.makeLeague(key: 7, name: "Bundesliga")
        mockRepository.stubbedAllFavorites = ["football": [league]]
        sut.viewWillAppear()

        let result = sut.getLeague(at: IndexPath(row: 0, section: 0))

        XCTAssertEqual(result.leagueKey, 7,
                       "getLeague must return the league with the expected key")
        XCTAssertEqual(result.leagueName, "Bundesliga")
    }

    func test_getSportType_returnsRawSportString() {
        seedOneFavouriteAndLoad()

        let sport = sut.getSportType(for: 0)

        XCTAssertEqual(sport, "football",
                       "getSportType should return the lowercased sport identifier")
    }

    func test_didSelectLeague_callsRouter() {
        seedOneFavouriteAndLoad()

        sut.didSelectLeague(at: IndexPath(row: 0, section: 0))

        XCTAssertEqual(mockRouter.navigateToLeagueDetailsCallCount, 1,
                       "Selecting a league must trigger router navigation")
    }

    func test_didSelectLeague_passesCorrectLeagueId() {
        let league = TestFixtureFactory.makeLeague(key: 42, name: "Serie A")
        mockRepository.stubbedAllFavorites = ["football": [league]]
        sut.viewWillAppear()

        sut.didSelectLeague(at: IndexPath(row: 0, section: 0))

        XCTAssertEqual(mockRouter.lastLeagueDetailsLeagueId, 42,
                       "Router must receive the correct leagueId")
    }

    func test_removeFavorite_callsRepositoryRemove() {
        seedOneFavouriteAndLoad()

        sut.removeFavorite(at: IndexPath(row: 0, section: 0))

        XCTAssertEqual(mockRepository.removeFavoriteCallCount, 1,
                       "removeFavorite must call repository.removeFavorite exactly once")
    }

    func test_removeFavorite_passesCorrectLeagueKey() {
        let league = TestFixtureFactory.makeLeague(key: 99, name: "Ligue 1")
        mockRepository.stubbedAllFavorites = ["football": [league]]
        sut.viewWillAppear()

        sut.removeFavorite(at: IndexPath(row: 0, section: 0))

        XCTAssertEqual(mockRepository.lastRemovedLeagueKey, 99,
                       "Repository should receive leagueKey 99")
    }

    func test_removeFavorite_reloadsViewAfterRemoval() {
        seedOneFavouriteAndLoad()
        let callsBefore = mockView.reloadDataCallCount

        sut.removeFavorite(at: IndexPath(row: 0, section: 0))

        XCTAssertGreaterThan(mockView.reloadDataCallCount, callsBefore,
                             "View must be reloaded after removing a favorite")
    }
}
