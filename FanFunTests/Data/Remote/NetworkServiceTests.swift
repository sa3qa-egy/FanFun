import XCTest
@testable import FanFun

class NetworkServiceTests: XCTestCase {

    var sut: NetworkService!
    var mockClient: MockNetworkClient!

    override func setUp() {
        super.setUp()
        mockClient = MockNetworkClient()
        sut = NetworkService(networkClient: mockClient)
    }

    override func tearDown() {
        sut = nil
        mockClient = nil
        super.tearDown()
    }

    func test_fetchLeagues_whenSuccess_returnsLeagues() {
        let jsonLeague: [String: Any] = ["league_key": 1, "league_name": "Premier League"]
        mockClient.expectedResult = ResponseFactory.makeLeagueResponse(leagues: [jsonLeague])

        let expectation = XCTestExpectation(description: "Fetch leagues")
        sut.fetchLeagues(for: "football") { result in
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
    }

    func test_fetchLeagues_whenFailure_returnsError() {
        mockClient.shouldReturnError = true

        let expectation = XCTestExpectation(description: "Fetch leagues error")
        sut.fetchLeagues(for: "football") { result in
            switch result {
            case .success:
                XCTFail("Expected error")
            case .failure(let error):
                XCTAssertNotNil(error)
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1.0)
    }
    
    func test_fetchFixtures_whenSuccess_returnsFixtures() {
        let jsonFixture: [String: Any] = [
            "event_key": 1,
            "event_home_team": "Team A",
            "event_away_team": "Team B",
            "event_date": "2023-05-15",
            "event_time": "18:00"
        ]
        mockClient.expectedResult = ResponseFactory.makeFixtureResponse(fixtures: [jsonFixture])

        let expectation = XCTestExpectation(description: "Fetch fixtures")
        sut.fetchFixtures(for: "football", leagueId: 1, from: "2023-01-01", to: "2023-12-31") { result in
            switch result {
            case .success(let fixtures):
                XCTAssertEqual(fixtures.count,  1)
                XCTAssertEqual(fixtures.first?.eventKey, 1)
            case .failure:
                XCTFail("Expected success")
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1.0)
    }

    func test_fetchTeams_whenSuccess_returnsTeams() {
        let jsonTeam: [String: Any] = ["team_key": 1, "team_name": "Arsenal"]
        mockClient.expectedResult = ResponseFactory.makeTeamResponse(teams: [jsonTeam])

        let expectation = XCTestExpectation(description: "Fetch teams")
        sut.fetchTeams(for: "football", leagueId: 1) { result in
            switch result {
            case .success(let teams):
                XCTAssertEqual(teams.count, 1)
                XCTAssertEqual(teams.first?.teamKey, 1)
            case .failure:
                XCTFail("Expected success")
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1.0)
    }
    
    func test_fetchPlayers_whenSuccess_returnsPlayers() {
        let jsonPlayer: [String: Any] = ["player_key": "1", "player_name": "Saka"]
        mockClient.expectedResult = ResponseFactory.makePlayerResponse(players: [jsonPlayer])

        let expectation = XCTestExpectation(description: "Fetch players")
        sut.fetchPlayers(for: "tennis", leagueId: 1) { result in
            switch result {
            case .success(let players):
                XCTAssertEqual(players.count, 1)
                XCTAssertEqual(players.first?.playerKey, "1")
            case .failure:
                XCTFail("Expected success")
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1.0)
    }

    func test_fetchTeamDetails_whenSuccess_returnsTeamDetail() {
        let jsonDetail: [String: Any] = ["team_key": "1", "team_name": "Arsenal"]
        mockClient.expectedResult = ResponseFactory.makeTeamDetailResponse(details: [jsonDetail])

        let expectation = XCTestExpectation(description: "Fetch team details")
        sut.fetchTeamDetails(teamId: 1) { result in
            switch result {
            case .success(let detail):
                XCTAssertEqual(detail.teamKey, "1")
            case .failure:
                XCTFail("Expected success")
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1.0)
    }
    
    func test_fetchTeamDetails_whenEmptyResult_returnsError() {
        mockClient.expectedResult = ResponseFactory.makeTeamDetailResponse(details: [])

        let expectation = XCTestExpectation(description: "Fetch team details empty")
        sut.fetchTeamDetails(teamId: 1) { result in
            switch result {
            case .success:
                XCTFail("Expected error")
            case .failure(let error as NSError):
                XCTAssertEqual(error.code, 404)
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1.0)
    }

    func test_fetchTennisPlayerDetails_whenSuccess_returnsTennisPlayerDetail() {
        let jsonDetail: [String: Any] = ["player_key": "1", "player_name": "Federer"]
        mockClient.expectedResult = ResponseFactory.makeTennisPlayerDetailResponse(details: [jsonDetail])

        let expectation = XCTestExpectation(description: "Fetch tennis player details")
        sut.fetchTennisPlayerDetails(playerId: 1) { result in
            switch result {
            case .success(let detail):
                XCTAssertEqual(detail.playerKey, "1")
            case .failure:
                XCTFail("Expected success")
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1.0)
    }
    
    func test_fetchTennisPlayerDetails_whenEmptyResult_returnsError() {
        mockClient.expectedResult = ResponseFactory.makeTennisPlayerDetailResponse(details: [])

        let expectation = XCTestExpectation(description: "Fetch tennis player details empty")
        sut.fetchTennisPlayerDetails(playerId: 1) { result in
            switch result {
            case .success:
                XCTFail("Expected error")
            case .failure(let error as NSError):
                XCTAssertEqual(error.code, 404)
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1.0)
    }
}
