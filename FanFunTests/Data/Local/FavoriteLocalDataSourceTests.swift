import XCTest
import CoreData
@testable import FanFun

final class FavoriteLocalDataSourceTests: XCTestCase {

    // MARK: - Properties

    var sut: FavoriteLocalDataSource!
    var context: NSManagedObjectContext!

    // MARK: - Setup & Teardown

    override func setUp() {
        super.setUp()
        context = makeInMemoryContext()
        sut = FavoriteLocalDataSource(context: context)
    }

    override func tearDown() {
        sut = nil
        context = nil
        super.tearDown()
    }

    // MARK: - Helpers

    private func makeInMemoryContext() -> NSManagedObjectContext {
        let modelURL = Bundle.main.url(forResource: "FanFun", withExtension: "momd")!
        let model = NSManagedObjectModel(contentsOf: modelURL)!
        let container = NSPersistentContainer(name: "FanFun", managedObjectModel: model)
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        container.persistentStoreDescriptions = [description]

        var loadError: Error?
        container.loadPersistentStores { _, error in
            loadError = error
        }
        XCTAssertNil(loadError, "Failed to load in-memory store: \(loadError?.localizedDescription ?? "")")
        return container.viewContext
    }

    private func makeLeague(key: Int = 1,
                            name: String = "Premier League",
                            countryKey: Int? = 44,
                            countryName: String? = "England",
                            leagueLogo: String? = "https://logo.png",
                            countryLogo: String? = "https://flag.png",
                            leagueYear: String? = "2024-2025") -> League {
        return League(
            leagueKey: key,
            leagueName: name,
            countryKey: countryKey,
            countryName: countryName,
            leagueLogo: leagueLogo,
            countryLogo: countryLogo,
            leagueYear: leagueYear
        )
    }

    private func makeFixture(eventKey: Int = 100,
                             date: String = "2025-01-15",
                             time: String = "20:00",
                             homeTeam: String = "Liverpool",
                             homeKey: Int = 10,
                             awayTeam: String = "Man City",
                             awayKey: Int = 20,
                             result: String? = "2 - 1",
                             status: String? = "Finished",
                             homeLogo: String? = "https://home.png",
                             awayLogo: String? = "https://away.png") -> Fixture {
        return Fixture(
            eventKey: eventKey,
            eventDate: date,
            eventTime: time,
            eventHomeTeam: homeTeam,
            homeTeamKey: homeKey,
            eventAwayTeam: awayTeam,
            awayTeamKey: awayKey,
            eventFinalResult: result,
            eventStatus: status,
            homeTeamLogo: homeLogo,
            awayTeamLogo: awayLogo
        )
    }

    private func makeTeam(key: Int = 50,
                          name: String = "Liverpool",
                          logo: String? = "https://team.png") -> Team {
        return Team(teamKey: key, teamName: name, teamLogo: logo)
    }

    // ====================================================================
    // MARK: - addFavorite Tests
    // ====================================================================

    func test_addFavorite_savesLeagueToStore() {
        // Given
        let league = makeLeague(key: 1, name: "La Liga")

        // When
        sut.addFavorite(league: league, sportType: "football")

        // Then
        XCTAssertTrue(sut.isFavorite(leagueKey: 1, sportType: "football"))
    }

    func test_addFavorite_mapsAllLeagueProperties() {
        // Given
        let league = makeLeague(key: 42, name: "Serie A", countryKey: 10,
                                countryName: "Italy", leagueLogo: "https://seriea.png",
                                countryLogo: "https://italy.png", leagueYear: "2024")

        // When
        sut.addFavorite(league: league, sportType: "football")

        // Then
        let fetched = sut.fetchFavorites(for: "football")
        XCTAssertEqual(fetched.count, 1)
        let result = fetched.first!
        XCTAssertEqual(result.leagueKey, 42)
        XCTAssertEqual(result.leagueName, "Serie A")
        XCTAssertEqual(result.countryKey, 10)
        XCTAssertEqual(result.countryName, "Italy")
        XCTAssertEqual(result.leagueLogo, "https://seriea.png")
        XCTAssertEqual(result.countryLogo, "https://italy.png")
        XCTAssertEqual(result.leagueYear, "2024")
    }

    func test_addFavorite_preventsduplicates() {
        // Given
        let league = makeLeague(key: 1, name: "Premier League")

        // When
        sut.addFavorite(league: league, sportType: "football")
        sut.addFavorite(league: league, sportType: "football")

        // Then – only one entry should exist
        let fetched = sut.fetchFavorites(for: "football")
        XCTAssertEqual(fetched.count, 1)
    }

    func test_addFavorite_allowsSameLeagueForDifferentSports() {
        // Given
        let league = makeLeague(key: 1, name: "League A")

        // When
        sut.addFavorite(league: league, sportType: "football")
        sut.addFavorite(league: league, sportType: "basketball")

        // Then
        XCTAssertTrue(sut.isFavorite(leagueKey: 1, sportType: "football"))
        XCTAssertTrue(sut.isFavorite(leagueKey: 1, sportType: "basketball"))
    }

    func test_addFavorite_storesSportTypeInLowercase() {
        // Given
        let league = makeLeague(key: 7)

        // When
        sut.addFavorite(league: league, sportType: "FOOTBALL")

        // Then – fetching with lowercase should return the entry
        XCTAssertTrue(sut.isFavorite(leagueKey: 7, sportType: "football"))
    }

    func test_addFavorite_handlesNilCountryKey() {
        // Given
        let league = makeLeague(key: 99, countryKey: nil)

        // When
        sut.addFavorite(league: league, sportType: "tennis")

        // Then
        let fetched = sut.fetchFavorites(for: "tennis")
        XCTAssertEqual(fetched.count, 1)
        XCTAssertNil(fetched.first?.countryKey)
    }

    // ====================================================================
    // MARK: - removeFavorite Tests
    // ====================================================================

    func test_removeFavorite_deletesLeagueFromStore() {
        // Given
        let league = makeLeague(key: 1)
        sut.addFavorite(league: league, sportType: "football")
        XCTAssertTrue(sut.isFavorite(leagueKey: 1, sportType: "football"))

        // When
        sut.removeFavorite(leagueKey: 1, sportType: "football")

        // Then
        XCTAssertFalse(sut.isFavorite(leagueKey: 1, sportType: "football"))
    }

    func test_removeFavorite_doesNotAffectOtherSports() {
        // Given
        let league = makeLeague(key: 1)
        sut.addFavorite(league: league, sportType: "football")
        sut.addFavorite(league: league, sportType: "basketball")

        // When
        sut.removeFavorite(leagueKey: 1, sportType: "football")

        // Then
        XCTAssertFalse(sut.isFavorite(leagueKey: 1, sportType: "football"))
        XCTAssertTrue(sut.isFavorite(leagueKey: 1, sportType: "basketball"))
    }

    func test_removeFavorite_doesNotAffectOtherLeagues() {
        // Given
        let league1 = makeLeague(key: 1, name: "League 1")
        let league2 = makeLeague(key: 2, name: "League 2")
        sut.addFavorite(league: league1, sportType: "football")
        sut.addFavorite(league: league2, sportType: "football")

        // When
        sut.removeFavorite(leagueKey: 1, sportType: "football")

        // Then
        XCTAssertFalse(sut.isFavorite(leagueKey: 1, sportType: "football"))
        XCTAssertTrue(sut.isFavorite(leagueKey: 2, sportType: "football"))
    }

    func test_removeFavorite_alsoCleansUpCachedFixturesAndTeams() {
        // Given
        let league = makeLeague(key: 1)
        sut.addFavorite(league: league, sportType: "football")
        sut.cacheFixtures([makeFixture()], leagueKey: 1, sportType: "football", isUpcoming: true)
        sut.cacheTeams([makeTeam()], leagueKey: 1, sportType: "football")

        // When
        sut.removeFavorite(leagueKey: 1, sportType: "football")

        // Then – cached data should also be deleted
        XCTAssertTrue(sut.fetchCachedUpcomingFixtures(leagueKey: 1, sportType: "football").isEmpty)
        XCTAssertTrue(sut.fetchCachedTeams(leagueKey: 1, sportType: "football").isEmpty)
    }

    func test_removeFavorite_noErrorWhenLeagueDoesNotExist() {
        // When / Then – should not crash
        sut.removeFavorite(leagueKey: 999, sportType: "football")
    }

    // ====================================================================
    // MARK: - isFavorite Tests
    // ====================================================================

    func test_isFavorite_returnsTrueForExistingFavorite() {
        // Given
        sut.addFavorite(league: makeLeague(key: 1), sportType: "football")

        // Then
        XCTAssertTrue(sut.isFavorite(leagueKey: 1, sportType: "football"))
    }

    func test_isFavorite_returnsFalseForNonExistentFavorite() {
        // Then
        XCTAssertFalse(sut.isFavorite(leagueKey: 999, sportType: "football"))
    }

    func test_isFavorite_isCaseInsensitiveOnSportType() {
        // Given
        sut.addFavorite(league: makeLeague(key: 5), sportType: "Football")

        // Then – both upper and lower should find it
        XCTAssertTrue(sut.isFavorite(leagueKey: 5, sportType: "FOOTBALL"))
        XCTAssertTrue(sut.isFavorite(leagueKey: 5, sportType: "football"))
    }

    // ====================================================================
    // MARK: - fetchFavorites Tests
    // ====================================================================

    func test_fetchFavorites_returnsOnlyMatchingSport() {
        // Given
        sut.addFavorite(league: makeLeague(key: 1, name: "League A"), sportType: "football")
        sut.addFavorite(league: makeLeague(key: 2, name: "League B"), sportType: "basketball")
        sut.addFavorite(league: makeLeague(key: 3, name: "League C"), sportType: "football")

        // When
        let result = sut.fetchFavorites(for: "football")

        // Then
        XCTAssertEqual(result.count, 2)
        XCTAssertTrue(result.allSatisfy { $0.leagueKey == 1 || $0.leagueKey == 3 })
    }

    func test_fetchFavorites_returnsSortedByName() {
        // Given
        sut.addFavorite(league: makeLeague(key: 1, name: "Zebra League"), sportType: "football")
        sut.addFavorite(league: makeLeague(key: 2, name: "Alpha League"), sportType: "football")
        sut.addFavorite(league: makeLeague(key: 3, name: "Middle League"), sportType: "football")

        // When
        let result = sut.fetchFavorites(for: "football")

        // Then
        XCTAssertEqual(result.map { $0.leagueName }, ["Alpha League", "Middle League", "Zebra League"])
    }

    func test_fetchFavorites_returnsEmptyForUnknownSport() {
        // When
        let result = sut.fetchFavorites(for: "cricket")

        // Then
        XCTAssertTrue(result.isEmpty)
    }

    // ====================================================================
    // MARK: - fetchAllFavorites Tests
    // ====================================================================

    func test_fetchAllFavorites_groupsBySportType() {
        // Given
        sut.addFavorite(league: makeLeague(key: 1, name: "PL"), sportType: "football")
        sut.addFavorite(league: makeLeague(key: 2, name: "NBA"), sportType: "basketball")
        sut.addFavorite(league: makeLeague(key: 3, name: "La Liga"), sportType: "football")

        // When
        let grouped = sut.fetchAllFavorites()

        // Then
        XCTAssertEqual(grouped.count, 2)
        XCTAssertEqual(grouped["football"]?.count, 2)
        XCTAssertEqual(grouped["basketball"]?.count, 1)
    }

    func test_fetchAllFavorites_returnsEmptyDictionaryWhenNoFavorites() {
        // When
        let grouped = sut.fetchAllFavorites()

        // Then
        XCTAssertTrue(grouped.isEmpty)
    }

    // ====================================================================
    // MARK: - cacheFixtures / fetchCachedFixtures Tests
    // ====================================================================

    func test_cacheFixtures_savesUpcomingFixtures() {
        // Given
        let fixtures = [
            makeFixture(eventKey: 1, date: "2025-02-01"),
            makeFixture(eventKey: 2, date: "2025-02-10")
        ]

        // When
        sut.cacheFixtures(fixtures, leagueKey: 100, sportType: "football", isUpcoming: true)

        // Then
        let cached = sut.fetchCachedUpcomingFixtures(leagueKey: 100, sportType: "football")
        XCTAssertEqual(cached.count, 2)
    }

    func test_cacheFixtures_savesPreviousFixtures() {
        // Given
        let fixtures = [makeFixture(eventKey: 3, date: "2024-12-01")]

        // When
        sut.cacheFixtures(fixtures, leagueKey: 100, sportType: "football", isUpcoming: false)

        // Then
        let cached = sut.fetchCachedPreviousFixtures(leagueKey: 100, sportType: "football")
        XCTAssertEqual(cached.count, 1)
        XCTAssertEqual(cached.first?.eventKey, 3)
    }

    func test_cacheFixtures_replacesOldCacheForSameTypeFlag() {
        // Given – cache some fixtures first
        sut.cacheFixtures([makeFixture(eventKey: 1)], leagueKey: 100, sportType: "football", isUpcoming: true)
        XCTAssertEqual(sut.fetchCachedUpcomingFixtures(leagueKey: 100, sportType: "football").count, 1)

        // When – cache new set (should replace)
        sut.cacheFixtures([makeFixture(eventKey: 2), makeFixture(eventKey: 3)], leagueKey: 100, sportType: "football", isUpcoming: true)

        // Then
        let cached = sut.fetchCachedUpcomingFixtures(leagueKey: 100, sportType: "football")
        XCTAssertEqual(cached.count, 2)
        XCTAssertFalse(cached.contains { $0.eventKey == 1 })
    }

    func test_cacheFixtures_doesNotAffectDifferentLeagueOrSport() {
        // Given
        sut.cacheFixtures([makeFixture(eventKey: 1)], leagueKey: 100, sportType: "football", isUpcoming: true)
        sut.cacheFixtures([makeFixture(eventKey: 2)], leagueKey: 200, sportType: "football", isUpcoming: true)

        // When – re-cache league 100
        sut.cacheFixtures([makeFixture(eventKey: 3)], leagueKey: 100, sportType: "football", isUpcoming: true)

        // Then – league 200 should be untouched
        let cached200 = sut.fetchCachedUpcomingFixtures(leagueKey: 200, sportType: "football")
        XCTAssertEqual(cached200.count, 1)
        XCTAssertEqual(cached200.first?.eventKey, 2)
    }

    func test_cacheFixtures_mapsAllFixtureProperties() {
        // Given
        let fixture = makeFixture(eventKey: 42, date: "2025-03-15", time: "19:30",
                                  homeTeam: "Barcelona", homeKey: 11,
                                  awayTeam: "Real Madrid", awayKey: 22,
                                  result: "3 - 2", status: "Finished",
                                  homeLogo: "https://barca.png", awayLogo: "https://real.png")

        // When
        sut.cacheFixtures([fixture], leagueKey: 100, sportType: "football", isUpcoming: false)

        // Then
        let cached = sut.fetchCachedPreviousFixtures(leagueKey: 100, sportType: "football")
        XCTAssertEqual(cached.count, 1)
        let result = cached.first!
        XCTAssertEqual(result.eventKey, 42)
        XCTAssertEqual(result.eventDate, "2025-03-15")
        XCTAssertEqual(result.eventTime, "19:30")
        XCTAssertEqual(result.eventHomeTeam, "Barcelona")
        XCTAssertEqual(result.homeTeamKey, 11)
        XCTAssertEqual(result.eventAwayTeam, "Real Madrid")
        XCTAssertEqual(result.awayTeamKey, 22)
        XCTAssertEqual(result.eventFinalResult, "3 - 2")
        XCTAssertEqual(result.eventStatus, "Finished")
        XCTAssertEqual(result.homeTeamLogo, "https://barca.png")
        XCTAssertEqual(result.awayTeamLogo, "https://real.png")
    }

    func test_fetchCachedUpcomingFixtures_returnsEmptyWhenNothingCached() {
        // When
        let result = sut.fetchCachedUpcomingFixtures(leagueKey: 999, sportType: "football")

        // Then
        XCTAssertTrue(result.isEmpty)
    }

    func test_fetchCachedPreviousFixtures_returnsEmptyWhenNothingCached() {
        // When
        let result = sut.fetchCachedPreviousFixtures(leagueKey: 999, sportType: "football")

        // Then
        XCTAssertTrue(result.isEmpty)
    }

    // ====================================================================
    // MARK: - cacheTeams / fetchCachedTeams Tests
    // ====================================================================

    func test_cacheTeams_savesTeams() {
        // Given
        let teams = [
            makeTeam(key: 1, name: "Liverpool"),
            makeTeam(key: 2, name: "Arsenal")
        ]

        // When
        sut.cacheTeams(teams, leagueKey: 100, sportType: "football")

        // Then
        let cached = sut.fetchCachedTeams(leagueKey: 100, sportType: "football")
        XCTAssertEqual(cached.count, 2)
    }

    func test_cacheTeams_replacesOldCache() {
        // Given
        sut.cacheTeams([makeTeam(key: 1, name: "Old Team")], leagueKey: 100, sportType: "football")

        // When
        sut.cacheTeams([makeTeam(key: 2, name: "New Team A"), makeTeam(key: 3, name: "New Team B")], leagueKey: 100, sportType: "football")

        // Then
        let cached = sut.fetchCachedTeams(leagueKey: 100, sportType: "football")
        XCTAssertEqual(cached.count, 2)
        XCTAssertFalse(cached.contains { $0.teamKey == 1 })
    }

    func test_cacheTeams_mapsAllTeamProperties() {
        // Given
        let team = makeTeam(key: 77, name: "Chelsea", logo: "https://chelsea.png")

        // When
        sut.cacheTeams([team], leagueKey: 100, sportType: "football")

        // Then
        let cached = sut.fetchCachedTeams(leagueKey: 100, sportType: "football")
        XCTAssertEqual(cached.count, 1)
        let result = cached.first!
        XCTAssertEqual(result.teamKey, 77)
        XCTAssertEqual(result.teamName, "Chelsea")
        XCTAssertEqual(result.teamLogo, "https://chelsea.png")
    }

    func test_fetchCachedTeams_returnsSortedByName() {
        // Given
        let teams = [
            makeTeam(key: 1, name: "Zebra FC"),
            makeTeam(key: 2, name: "Alpha FC"),
            makeTeam(key: 3, name: "Middle FC")
        ]
        sut.cacheTeams(teams, leagueKey: 100, sportType: "football")

        // When
        let cached = sut.fetchCachedTeams(leagueKey: 100, sportType: "football")

        // Then
        XCTAssertEqual(cached.map { $0.teamName }, ["Alpha FC", "Middle FC", "Zebra FC"])
    }

    func test_fetchCachedTeams_returnsEmptyWhenNothingCached() {
        // When
        let result = sut.fetchCachedTeams(leagueKey: 999, sportType: "football")

        // Then
        XCTAssertTrue(result.isEmpty)
    }

    func test_cacheTeams_doesNotAffectDifferentLeague() {
        // Given
        sut.cacheTeams([makeTeam(key: 1, name: "Team A")], leagueKey: 100, sportType: "football")
        sut.cacheTeams([makeTeam(key: 2, name: "Team B")], leagueKey: 200, sportType: "football")

        // When – re-cache league 100
        sut.cacheTeams([makeTeam(key: 3, name: "Team C")], leagueKey: 100, sportType: "football")

        // Then – league 200 unaffected
        let cached200 = sut.fetchCachedTeams(leagueKey: 200, sportType: "football")
        XCTAssertEqual(cached200.count, 1)
        XCTAssertEqual(cached200.first?.teamKey, 2)
    }
}
