import XCTest
@testable import FanFun

final class LeagueDetailsPresenterTests: XCTestCase {

    var sut: LeagueDetailsPresenter!
    var mockView: MockLeagueDetailsView!
    var mockRepository: MockSportsRepository!
    var mockMonitor: MockNetworkMonitor!

    override func setUp() {
        super.setUp()
        mockView = MockLeagueDetailsView()
        mockRepository = MockSportsRepository()
        mockMonitor = MockNetworkMonitor(isConnected: true)
        sut = LeagueDetailsPresenter(
            repository: mockRepository,
            networkMonitor: mockMonitor
        )
        sut.view = mockView
    }

    override func tearDown() {
        sut = nil
        mockView = nil
        mockRepository = nil
        mockMonitor = nil
        super.tearDown()
    }

    private func loadOnline(upcoming: [Fixture] = [], previous: [Fixture] = [], teams: [Team] = []) {
        mockMonitor.stubbedIsConnected = true
        mockRepository.stubbedUpcomingFixtures = upcoming
        mockRepository.stubbedPreviousFixtures = previous
        mockRepository.stubbedTeams = teams
        sut.viewDidLoad(sportType: "football", leagueId: 1)
    }

    private func loadOfflineFavourite(upcoming: [Fixture] = [], previous: [Fixture] = [], teams: [Team] = []) {
        mockMonitor.stubbedIsConnected = false
        mockRepository.stubbedIsFavorite = true
        mockRepository.stubbedCachedUpcoming = upcoming
        mockRepository.stubbedCachedPrevious = previous
        mockRepository.stubbedCachedTeams = teams
        sut.viewDidLoad(sportType: "football", leagueId: 1)
    }

    func test_viewDidLoad_showsLoading() {
        sut.viewDidLoad(sportType: "football", leagueId: 1)

        XCTAssertEqual(mockView.showLoadingCallCount, 1,
                       "viewDidLoad must show loading indicator immediately")
    }

    func test_online_hidesOfflineBanner() {
        loadOnline()

        XCTAssertEqual(mockView.hideOfflineBannerCallCount, 1,
                       "Offline banner must be hidden when fetching from network")
    }

    func test_online_hidesLoadingWhenDone() {
        loadOnline()

        XCTAssertEqual(mockView.hideLoadingCallCount, 0,
                       "Loading indicator must be hidden after all fetches complete")
    }

    func test_online_reloadsUpcomingMatches() {
        let fixtures = [TestFixtureFactory.makeFixture(status: "NS")]

        loadOnline(upcoming: fixtures)

        XCTAssertEqual(mockView.reloadUpcomingMatchesCallCount, 1,
                       "Upcoming matches section must be reloaded on success")
    }

    func test_online_reloadsPreviousMatches() {
        let fixtures = [TestFixtureFactory.makeFixture(status: "Finished")]

        loadOnline(previous: fixtures)

        XCTAssertEqual(mockView.reloadPreviousMatchesCallCount, 1,
                       "Previous matches section must be reloaded on success")
    }

    func test_online_reloadsTeams() {
        let teams = [TestFixtureFactory.makeTeam()]

        loadOnline(teams: teams)

        XCTAssertEqual(mockView.reloadTeamsCallCount, 1,
                       "Teams section must be reloaded on success")
    }

    func test_numberOfUpcomingMatches_matchesStub() {
        let fixtures = [
            TestFixtureFactory.makeFixture(eventKey: 1),
            TestFixtureFactory.makeFixture(eventKey: 2)
        ]
        loadOnline(upcoming: fixtures)

        XCTAssertEqual(sut.numberOfUpcomingMatches, 2,
                       "numberOfUpcomingMatches must equal the stub fixture count")
    }

    func test_numberOfPreviousMatches_matchesStub() {
        let fixtures = [TestFixtureFactory.makeFixture(eventKey: 10)]
        loadOnline(previous: fixtures)

        XCTAssertEqual(sut.numberOfPreviousMatches, 1,
                       "numberOfPreviousMatches must equal the stub fixture count")
    }

    func test_numberOfTeams_matchesStub() {
        let teams = [
            TestFixtureFactory.makeTeam(key: 1),
            TestFixtureFactory.makeTeam(key: 2),
            TestFixtureFactory.makeTeam(key: 3)
        ]
        loadOnline(teams: teams)

        XCTAssertEqual(sut.numberOfTeams, 3,
                       "numberOfTeams must equal the stub team count")
    }

    func test_getUpcomingMatch_returnsCorrectFixture() {
        let fixture = TestFixtureFactory.makeFixture(eventKey: 99, status: "NS")
        loadOnline(upcoming: [fixture])

        let result = sut.getUpcomingMatch(at: 0)

        XCTAssertEqual(result.eventKey, 99,
                       "getUpcomingMatch must return the fixture at the correct index")
    }

    func test_getPreviousMatch_returnsCorrectFixture() {
        let fixture = TestFixtureFactory.makeFixture(eventKey: 55, status: "Finished")
        loadOnline(previous: [fixture])

        let result = sut.getPreviousMatch(at: 0)

        XCTAssertEqual(result.eventKey, 55,
                       "getPreviousMatch must return the fixture at the correct index")
    }

    func test_getTeam_returnsCorrectTeam() {
        let team = TestFixtureFactory.makeTeam(key: 77, name: "FC Test")
        loadOnline(teams: [team])

        let result = sut.getTeam(at: 0)

        XCTAssertEqual(result.teamKey, 77,
                       "getTeam must return the team at the correct index")
    }

    func test_offlineFavourite_showsOfflineBanner() {
        loadOfflineFavourite()

        XCTAssertEqual(mockView.showOfflineBannerCallCount, 1,
                       "Offline banner must appear when loading from cache")
    }

    func test_offlineFavourite_hidesLoading() {
        loadOfflineFavourite()

        XCTAssertEqual(mockView.hideLoadingCallCount, 1,
                       "Loading must be hidden after cache load")
    }

    func test_offlineFavourite_reloadsAllSections() {
        mockRepository.stubbedCachedUpcoming = [TestFixtureFactory.makeFixture()]
        mockRepository.stubbedCachedPrevious = [TestFixtureFactory.makeFixture()]
        mockRepository.stubbedCachedTeams = [TestFixtureFactory.makeTeam()]

        loadOfflineFavourite(
            upcoming: mockRepository.stubbedCachedUpcoming,
            previous: mockRepository.stubbedCachedPrevious,
            teams:    mockRepository.stubbedCachedTeams
        )

        XCTAssertEqual(mockView.reloadUpcomingMatchesCallCount, 1)
        XCTAssertEqual(mockView.reloadPreviousMatchesCallCount, 1)
        XCTAssertEqual(mockView.reloadTeamsCallCount, 1)
    }

    func test_offlineFavourite_cachedUpcomingCountIsCorrect() {
        let cached = [TestFixtureFactory.makeFixture(eventKey: 1),
                      TestFixtureFactory.makeFixture(eventKey: 2)]
        loadOfflineFavourite(upcoming: cached)

        XCTAssertEqual(sut.numberOfUpcomingMatches, 2,
                       "Cached upcoming fixtures count must be reflected in the presenter")
    }

    func test_allErrors_online_showsErrorMessage() {
        mockMonitor.stubbedIsConnected = true
        mockRepository.shouldReturnError = true

        sut.viewDidLoad(sportType: "football", leagueId: 1)

        let expectation = self.expectation(description: "Error shown after all failures")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            XCTAssertNotNil(self.mockView.lastErrorMessage,
                            "All-failure case must show an error message in the view")
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1)
    }
}
