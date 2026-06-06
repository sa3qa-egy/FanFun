import XCTest
import CoreData
@testable import FanFun

class SportsRepositoryTests: XCTestCase {

    var sut: SportsRepositoryImpl!
    var mockNetworkService: MockNetworkService!
    var mockNetworkMonitor: MockNetworkMonitor!
    var localDataSource: LeagueLocalDataSource!
    var favoriteDataSource: FavoriteLocalDataSource!
    var mockPreferencesDataSource: MockLocalPreferencesDataSource!
    var inMemoryContext: NSManagedObjectContext!

    override func setUp() {
        super.setUp()
        mockNetworkService = MockNetworkService()
        mockNetworkMonitor = MockNetworkMonitor()
        inMemoryContext = CoreDataTestHelper.makeInMemoryContext()
        localDataSource = LeagueLocalDataSource(context: inMemoryContext)
        favoriteDataSource = FavoriteLocalDataSource(context: inMemoryContext)
        mockPreferencesDataSource = MockLocalPreferencesDataSource()

        sut = SportsRepositoryImpl(
            networkService: mockNetworkService,
            localDataSource: localDataSource,
            favoriteDataSource: favoriteDataSource,
            networkMonitor: mockNetworkMonitor,
            preferencesDataSource: mockPreferencesDataSource
        )
    }

    override func tearDown() {
        sut = nil
        mockNetworkService = nil
        mockNetworkMonitor = nil
        localDataSource = nil
        favoriteDataSource = nil
        inMemoryContext = nil
        super.tearDown()
    }

    func test_getLeagues_whenOnline_returnsLeaguesAndCachesThem() {
        mockNetworkMonitor.stubbedIsConnected = true
        let expectedLeagues = [League(leagueKey: 1, leagueName: "Test", countryKey: nil, countryName: nil, leagueLogo: nil, countryLogo: nil, leagueYear: nil)]
        mockNetworkService.stubbedLeagues = expectedLeagues

        let expectation = XCTestExpectation(description: "Get leagues online")
        sut.getLeagues(for: "football") { result in
            switch result {
            case .success(let leagues):
                XCTAssertEqual(leagues.count, 1)
                XCTAssertEqual(leagues.first?.leagueKey, 1)
            case .failure:
                XCTFail("Expected success")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)

        // Verify cache
        let cached = localDataSource.fetchLeagues(for: "football")
        XCTAssertEqual(cached.count, 1)
        XCTAssertEqual(cached.first?.leagueKey, 1)
    }

    func test_getLeagues_whenOfflineWithCache_returnsCachedLeagues() {
        mockNetworkMonitor.stubbedIsConnected = false
        let cachedLeagues = [League(leagueKey: 2, leagueName: "Cached", countryKey: nil, countryName: nil, leagueLogo: nil, countryLogo: nil, leagueYear: nil)]
        localDataSource.saveLeagues(cachedLeagues, for: "football")

        let expectation = XCTestExpectation(description: "Get leagues offline")
        sut.getLeagues(for: "football") { result in
            switch result {
            case .success(let leagues):
                XCTAssertEqual(leagues.count, 1)
                XCTAssertEqual(leagues.first?.leagueKey, 2)
            case .failure:
                XCTFail("Expected success")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }

    func test_getLeagues_whenOfflineWithoutCache_returnsError() {
        mockNetworkMonitor.stubbedIsConnected = false

        let expectation = XCTestExpectation(description: "Get leagues offline empty")
        sut.getLeagues(for: "football") { result in
            switch result {
            case .success:
                XCTFail("Expected error")
            case .failure(let error):
                XCTAssertEqual(error as? OfflineError, OfflineError.noCache)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }

    func test_getUpcomingFixtures_returnsFilteredFixtures() {
        let fixtures = [
            Fixture(eventKey: 1, eventDate: "", eventTime: "", eventHomeTeam: "", homeTeamKey: 1, eventAwayTeam: "", awayTeamKey: 2, eventFinalResult: nil, eventStatus: "Finished", homeTeamLogo: nil, awayTeamLogo: nil),
            Fixture(eventKey: 2, eventDate: "", eventTime: "", eventHomeTeam: "", homeTeamKey: 3, eventAwayTeam: "", awayTeamKey: 4, eventFinalResult: nil, eventStatus: "Not Started", homeTeamLogo: nil, awayTeamLogo: nil)
        ]
        mockNetworkService.stubbedFixtures = fixtures

        let expectation = XCTestExpectation(description: "Get upcoming fixtures")
        sut.getUpcomingFixtures(for: "football", leagueId: 1) { result in
            switch result {
            case .success(let fetched):
                XCTAssertEqual(fetched.count, 1)
                XCTAssertEqual(fetched.first?.eventKey, 2)
            case .failure:
                XCTFail("Expected success")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }

    func test_getPreviousFixtures_returnsFilteredAndSortedFixtures() {
        let fixtures = [
            Fixture(eventKey: 1, eventDate: "2023-01-01", eventTime: "", eventHomeTeam: "", homeTeamKey: 1, eventAwayTeam: "", awayTeamKey: 2, eventFinalResult: nil, eventStatus: "Finished", homeTeamLogo: nil, awayTeamLogo: nil),
            Fixture(eventKey: 2, eventDate: "2023-01-02", eventTime: "", eventHomeTeam: "", homeTeamKey: 3, eventAwayTeam: "", awayTeamKey: 4, eventFinalResult: nil, eventStatus: "Finished", homeTeamLogo: nil, awayTeamLogo: nil)
        ]
        mockNetworkService.stubbedFixtures = fixtures

        let expectation = XCTestExpectation(description: "Get previous fixtures")
        sut.getPreviousFixtures(for: "football", leagueId: 1) { result in
            switch result {
            case .success(let fetched):
                XCTAssertEqual(fetched.count, 2)
                XCTAssertEqual(fetched.first?.eventKey, 2) // Should be sorted by date descending
            case .failure:
                XCTFail("Expected success")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }

    func test_getTeams_forTennis_fetchesPlayersAndMapsToTeams() {
        let jsonPlayer: [String: Any] = ["player_key": "123", "player_name": "Nadal"]
        let players = ResponseFactory.makePlayerResponse(players: [jsonPlayer]).result!
        mockNetworkService.stubbedPlayers = players

        let expectation = XCTestExpectation(description: "Get tennis teams")
        sut.getTeams(for: "tennis", leagueId: 1) { result in
            switch result {
            case .success(let teams):
                XCTAssertEqual(teams.count, 1)
                XCTAssertEqual(teams.first?.teamKey, 123)
                XCTAssertEqual(teams.first?.teamName, "Nadal")
            case .failure:
                XCTFail("Expected success")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }

    func test_getTeams_forFootball_fetchesTeamsDirectly() {
        let teams = [Team(teamKey: 1, teamName: "Liverpool", teamLogo: nil)]
        mockNetworkService.stubbedTeams = teams

        let expectation = XCTestExpectation(description: "Get football teams")
        sut.getTeams(for: "football", leagueId: 1) { result in
            switch result {
            case .success(let fetchedTeams):
                XCTAssertEqual(fetchedTeams.count, 1)
                XCTAssertEqual(fetchedTeams.first?.teamName, "Liverpool")
            case .failure:
                XCTFail("Expected success")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }
    
    func test_addFavorite_savesToDatabaseAndCachesData() {
        let league = League(leagueKey: 99, leagueName: "Test Fav", countryKey: nil, countryName: nil, leagueLogo: nil, countryLogo: nil, leagueYear: nil)
        mockNetworkService.stubbedFixtures = []
        mockNetworkService.stubbedTeams = []
        
        let expectation = XCTestExpectation(description: "Add favorite")
        sut.addFavorite(league: league, sportType: "football") {
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
        
        XCTAssertTrue(sut.isFavorite(leagueKey: 99, sportType: "football"))
        let favorites = sut.getFavorites(for: "football")
        XCTAssertEqual(favorites.count, 1)
        XCTAssertEqual(favorites.first?.leagueKey, 99)
    }
    
    func test_removeFavorite_removesFromDatabaseAndClearsCache() {
        let league = League(leagueKey: 88, leagueName: "Test Remove", countryKey: nil, countryName: nil, leagueLogo: nil, countryLogo: nil, leagueYear: nil)
        sut.addFavorite(league: league, sportType: "football") {}
        
        XCTAssertTrue(sut.isFavorite(leagueKey: 88, sportType: "football"))
        sut.removeFavorite(leagueKey: 88, sportType: "football")
        XCTAssertFalse(sut.isFavorite(leagueKey: 88, sportType: "football"))
    }

    func test_isDarkMode_getterAndSetter_delegatesToPreferencesDataSource() {
        mockPreferencesDataSource.stubbedIsDarkMode = true
        XCTAssertTrue(sut.isDarkMode)
        
        sut.isDarkMode = false
        XCTAssertEqual(mockPreferencesDataSource.isDarkModeSetCallCount, 1)
        XCTAssertFalse(mockPreferencesDataSource.stubbedIsDarkMode)
    }
}
