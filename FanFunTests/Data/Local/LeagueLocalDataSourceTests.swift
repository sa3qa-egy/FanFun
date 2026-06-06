import XCTest
import CoreData
@testable import FanFun

final class LeagueLocalDataSourceTests: XCTestCase {

    // MARK: - Properties

    var sut: LeagueLocalDataSource!
    var context: NSManagedObjectContext!

    // MARK: - Setup & Teardown

    override func setUp() {
        super.setUp()
        context = makeInMemoryContext()
        sut = LeagueLocalDataSource(context: context)
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

    // ====================================================================
    // MARK: - saveLeagues Tests
    // ====================================================================

    func test_saveLeagues_storesLeaguesForSport() {
        // Given
        let leagues = [
            makeLeague(key: 1, name: "Premier League"),
            makeLeague(key: 2, name: "La Liga")
        ]

        // When
        sut.saveLeagues(leagues, for: "football")

        // Then
        let fetched = sut.fetchLeagues(for: "football")
        XCTAssertEqual(fetched.count, 2)
    }

    func test_saveLeagues_mapsAllProperties() {
        // Given
        let league = makeLeague(key: 42, name: "Serie A", countryKey: 10,
                                countryName: "Italy", leagueLogo: "https://seriea.png",
                                countryLogo: "https://italy.png", leagueYear: "2024")

        // When
        sut.saveLeagues([league], for: "football")

        // Then
        let fetched = sut.fetchLeagues(for: "football")
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

    func test_saveLeagues_replacesExistingLeaguesForSameSport() {
        // Given – save initial set
        sut.saveLeagues([
            makeLeague(key: 1, name: "Old League A"),
            makeLeague(key: 2, name: "Old League B")
        ], for: "football")
        XCTAssertEqual(sut.fetchLeagues(for: "football").count, 2)

        // When – save new set
        sut.saveLeagues([
            makeLeague(key: 3, name: "New League C")
        ], for: "football")

        // Then – old leagues should be gone, only new one remains
        let fetched = sut.fetchLeagues(for: "football")
        XCTAssertEqual(fetched.count, 1)
        XCTAssertEqual(fetched.first?.leagueKey, 3)
        XCTAssertEqual(fetched.first?.leagueName, "New League C")
    }

    func test_saveLeagues_doesNotAffectOtherSports() {
        // Given
        sut.saveLeagues([makeLeague(key: 1, name: "NBA")], for: "basketball")
        sut.saveLeagues([makeLeague(key: 2, name: "Premier League")], for: "football")

        // When – replace only football
        sut.saveLeagues([makeLeague(key: 3, name: "La Liga")], for: "football")

        // Then – basketball data should remain
        let basketball = sut.fetchLeagues(for: "basketball")
        XCTAssertEqual(basketball.count, 1)
        XCTAssertEqual(basketball.first?.leagueName, "NBA")
    }

    func test_saveLeagues_storesSportTypeInLowercase() {
        // Given
        let league = makeLeague(key: 1, name: "Test League")

        // When
        sut.saveLeagues([league], for: "FOOTBALL")

        // Then – should be fetchable with lowercase
        let fetched = sut.fetchLeagues(for: "football")
        XCTAssertEqual(fetched.count, 1)
    }

    func test_saveLeagues_savesEmptyArray() {
        // Given – first save some leagues
        sut.saveLeagues([makeLeague(key: 1)], for: "football")
        XCTAssertEqual(sut.fetchLeagues(for: "football").count, 1)

        // When – save empty array (clears all)
        sut.saveLeagues([], for: "football")

        // Then
        let fetched = sut.fetchLeagues(for: "football")
        XCTAssertTrue(fetched.isEmpty)
    }

    func test_saveLeagues_handlesNilCountryKey() {
        // Given
        let league = makeLeague(key: 5, countryKey: nil)

        // When
        sut.saveLeagues([league], for: "tennis")

        // Then
        let fetched = sut.fetchLeagues(for: "tennis")
        XCTAssertEqual(fetched.count, 1)
        XCTAssertNil(fetched.first?.countryKey)
    }

    func test_saveLeagues_handlesLargeDataSets() {
        // Given
        let leagues = (1...100).map { makeLeague(key: $0, name: "League \($0)") }

        // When
        sut.saveLeagues(leagues, for: "football")

        // Then
        let fetched = sut.fetchLeagues(for: "football")
        XCTAssertEqual(fetched.count, 100)
    }

    // ====================================================================
    // MARK: - fetchLeagues Tests
    // ====================================================================

    func test_fetchLeagues_returnsSortedByName() {
        // Given
        sut.saveLeagues([
            makeLeague(key: 1, name: "Zebra League"),
            makeLeague(key: 2, name: "Alpha League"),
            makeLeague(key: 3, name: "Middle League")
        ], for: "football")

        // When
        let fetched = sut.fetchLeagues(for: "football")

        // Then
        XCTAssertEqual(fetched.map { $0.leagueName }, ["Alpha League", "Middle League", "Zebra League"])
    }

    func test_fetchLeagues_returnsEmptyForUnknownSport() {
        // When
        let result = sut.fetchLeagues(for: "cricket")

        // Then
        XCTAssertTrue(result.isEmpty)
    }

    func test_fetchLeagues_isCaseInsensitiveOnSportType() {
        // Given
        sut.saveLeagues([makeLeague(key: 1)], for: "Football")

        // Then
        let fetched = sut.fetchLeagues(for: "football")
        XCTAssertEqual(fetched.count, 1)
    }

    func test_fetchLeagues_returnsEmptyAfterDeletion() {
        // Given
        sut.saveLeagues([makeLeague(key: 1)], for: "football")
        XCTAssertEqual(sut.fetchLeagues(for: "football").count, 1)

        // When – replace with empty (triggers delete + save)
        sut.saveLeagues([], for: "football")

        // Then
        XCTAssertTrue(sut.fetchLeagues(for: "football").isEmpty)
    }

    func test_fetchLeagues_multiSportIsolation() {
        // Given
        sut.saveLeagues([
            makeLeague(key: 1, name: "EPL"),
            makeLeague(key: 2, name: "La Liga")
        ], for: "football")

        sut.saveLeagues([
            makeLeague(key: 3, name: "NBA"),
            makeLeague(key: 4, name: "EuroLeague"),
            makeLeague(key: 5, name: "CBA")
        ], for: "basketball")

        // Then – each sport returns only its own leagues
        XCTAssertEqual(sut.fetchLeagues(for: "football").count, 2)
        XCTAssertEqual(sut.fetchLeagues(for: "basketball").count, 3)
    }
}
