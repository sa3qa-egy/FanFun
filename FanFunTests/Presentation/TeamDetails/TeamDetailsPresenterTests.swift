import XCTest
@testable import FanFun

final class TeamDetailsPresenterTests: XCTestCase {

    var mockView: MockTeamDetailsView!
    var mockRepository: MockSportsRepository!

    override func setUp() {
        super.setUp()
        mockView = MockTeamDetailsView()
        mockRepository = MockSportsRepository()
    }

    override func tearDown() {
        mockView = nil
        mockRepository = nil
        super.tearDown()
    }

    private func makeSUT(detailsType: TeamDetailsType) -> TeamDetailsPresenter {
        let sut = TeamDetailsPresenter(repository: mockRepository, detailsType: detailsType)
        sut.view = mockView
        return sut
    }

    func test_team_viewDidLoad_showsLoading() {
        let sut = makeSUT(detailsType: .team(id: 1))
        mockRepository.stubbedTeamDetail = TestFixtureFactory.makeTeamDetail()

        sut.viewDidLoad()

        XCTAssertEqual(mockView.showLoadingCallCount, 1,
                       "viewDidLoad must show loading immediately")
    }

    func test_team_viewDidLoad_onSuccess_hidesLoading() {
        let sut = makeSUT(detailsType: .team(id: 1))
        mockRepository.stubbedTeamDetail = TestFixtureFactory.makeTeamDetail()

        sut.viewDidLoad()

        let exp = expectation(description: "Loading hidden")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertEqual(self.mockView.hideLoadingCallCount, 1,
                           "Loading must be hidden after a successful team fetch")
            exp.fulfill()
        }
        waitForExpectations(timeout: 1)
    }

    func test_team_viewDidLoad_onSuccess_reloadsData() {
        let sut = makeSUT(detailsType: .team(id: 1))
        mockRepository.stubbedTeamDetail = TestFixtureFactory.makeTeamDetail()

        sut.viewDidLoad()

        let exp = expectation(description: "Data reloaded")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertEqual(self.mockView.reloadDataCallCount, 1,
                           "reloadData must be called after a successful fetch")
            exp.fulfill()
        }
        waitForExpectations(timeout: 1)
    }

    func test_team_viewDidLoad_onError_showsError() {
        let sut = makeSUT(detailsType: .team(id: 1))
        mockRepository.shouldReturnError = true

        sut.viewDidLoad()

        let exp = expectation(description: "Error shown")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertNotNil(self.mockView.lastErrorMessage,
                            "An error from the repository must trigger showError in the view")
            exp.fulfill()
        }
        waitForExpectations(timeout: 1)
    }

    func test_team_headerName_isTeamName() {
        let sut = makeSUT(detailsType: .team(id: 1))
        mockRepository.stubbedTeamDetail = TestFixtureFactory.makeTeamDetail(teamName: "Arsenal")
        sut.viewDidLoad()

        let exp = expectation(description: "Header set")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertEqual(sut.headerName, "Arsenal",
                           "headerName must reflect the team name returned by the repository")
            exp.fulfill()
        }
        waitForExpectations(timeout: 1)
    }

    func test_team_headerName_beforeLoad_isEmpty() {
        let sut = makeSUT(detailsType: .team(id: 1))

        XCTAssertEqual(sut.headerName, "",
                       "headerName should be empty before data is loaded")
    }

    func test_team_numberOfSections_isOne() {
        let sut = makeSUT(detailsType: .team(id: 1))

        XCTAssertEqual(sut.numberOfSections, 1,
                       "Team mode always has exactly one section")
    }

    func test_team_sectionTitle_isPlayers() {
        let sut = makeSUT(detailsType: .team(id: 1))

        XCTAssertEqual(sut.sectionTitle(for: 0), "Players",
                       "The only section title in team mode is 'Players'")
    }

    func test_team_numberOfRows_matchesPlayerCount() {
        let sut = makeSUT(detailsType: .team(id: 1))
        mockRepository.stubbedTeamDetail = TestFixtureFactory.makeTeamDetail()
        sut.viewDidLoad()

        let exp = expectation(description: "Rows counted")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertEqual(sut.numberOfRows(in: 0), 1,
                           "numberOfRows should match the number of players in the team detail")
            exp.fulfill()
        }
        waitForExpectations(timeout: 1)
    }

    func test_team_isEmptySection_whenNoPlayers_isTrue() {
        let sut = makeSUT(detailsType: .team(id: 1))

        XCTAssertTrue(sut.isEmptySection(0),
                      "Section is empty when no team detail is loaded")
    }

    func test_team_rowViewModel_returnsPlayerCase() {
        let sut = makeSUT(detailsType: .team(id: 1))
        mockRepository.stubbedTeamDetail = TestFixtureFactory.makeTeamDetail()
        sut.viewDidLoad()

        let exp = expectation(description: "ViewModel returned")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            let vm = sut.rowViewModel(at: IndexPath(row: 0, section: 0))
            if case .player(let name, _, _, _) = vm {
                XCTAssertEqual(name, "John Doe")
            } else {
                XCTFail("Expected .player view model for team mode")
            }
            exp.fulfill()
        }
        waitForExpectations(timeout: 1)
    }

    func test_tennisPlayer_viewDidLoad_showsLoading() {
        let sut = makeSUT(detailsType: .tennisPlayer(id: 42))
        mockRepository.stubbedTennisPlayerDetail = TestFixtureFactory.makeTennisPlayerDetail()

        sut.viewDidLoad()

        XCTAssertEqual(mockView.showLoadingCallCount, 1,
                       "viewDidLoad must show loading in tennis player mode too")
    }

    func test_tennisPlayer_viewDidLoad_onSuccess_reloadsData() {
        let sut = makeSUT(detailsType: .tennisPlayer(id: 42))
        mockRepository.stubbedTennisPlayerDetail = TestFixtureFactory.makeTennisPlayerDetail()
        sut.viewDidLoad()

        let exp = expectation(description: "Reload called")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertEqual(self.mockView.reloadDataCallCount, 1)
            exp.fulfill()
        }
        waitForExpectations(timeout: 1)
    }

    func test_tennisPlayer_viewDidLoad_onError_showsError() {
        let sut = makeSUT(detailsType: .tennisPlayer(id: 42))
        mockRepository.shouldReturnError = true
        sut.viewDidLoad()

        let exp = expectation(description: "Error shown")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertNotNil(self.mockView.lastErrorMessage)
            exp.fulfill()
        }
        waitForExpectations(timeout: 1)
    }

    func test_tennisPlayer_headerName_isPlayerName() {
        let sut = makeSUT(detailsType: .tennisPlayer(id: 42))
        mockRepository.stubbedTennisPlayerDetail = TestFixtureFactory.makeTennisPlayerDetail(playerName: "Novak Djokovic")
        sut.viewDidLoad()

        let exp = expectation(description: "Header set")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertEqual(sut.headerName, "Novak Djokovic")
            exp.fulfill()
        }
        waitForExpectations(timeout: 1)
    }

    func test_tennisPlayer_headerName_beforeLoad_isEmpty() {
        let sut = makeSUT(detailsType: .tennisPlayer(id: 42))

        XCTAssertEqual(sut.headerName, "")
    }

    func test_tennisPlayer_numberOfSections_isTwo() {
        let sut = makeSUT(detailsType: .tennisPlayer(id: 42))

        XCTAssertEqual(sut.numberOfSections, 2,
                       "Tennis player mode must have exactly two sections")
    }

    func test_tennisPlayer_sectionTitle_statsSection() {
        let sut = makeSUT(detailsType: .tennisPlayer(id: 42))

        XCTAssertEqual(sut.sectionTitle(for: 0), "Season Stats",
                       "Section 0 title must be 'Season Stats' for tennis player")
    }

    func test_tennisPlayer_sectionTitle_tournamentsSection() {
        let sut = makeSUT(detailsType: .tennisPlayer(id: 42))

        XCTAssertEqual(sut.sectionTitle(for: 1), "Tournaments",
                       "Section 1 title must be 'Tournaments' for tennis player")
    }

    func test_tennisPlayer_numberOfRows_inStatsSection_matchesStubCount() {
        let sut = makeSUT(detailsType: .tennisPlayer(id: 42))
        mockRepository.stubbedTennisPlayerDetail = TestFixtureFactory.makeTennisPlayerDetail()
        sut.viewDidLoad()

        let exp = expectation(description: "Rows counted")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertEqual(sut.numberOfRows(in: 0), 1,
                           "Stats section row count must match the stub")
            exp.fulfill()
        }
        waitForExpectations(timeout: 1)
    }

    func test_tennisPlayer_numberOfRows_inTournamentsSection_matchesStubCount() {
        let sut = makeSUT(detailsType: .tennisPlayer(id: 42))
        mockRepository.stubbedTennisPlayerDetail = TestFixtureFactory.makeTennisPlayerDetail()
        sut.viewDidLoad()

        let exp = expectation(description: "Rows counted")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertEqual(sut.numberOfRows(in: 1), 1,
                           "Tournaments section row count must match the stub")
            exp.fulfill()
        }
        waitForExpectations(timeout: 1)
    }

    func test_tennisPlayer_isEmptySection_beforeLoad_isTrue() {
        let sut = makeSUT(detailsType: .tennisPlayer(id: 42))

        XCTAssertTrue(sut.isEmptySection(0))
        XCTAssertTrue(sut.isEmptySection(1))
    }

    func test_tennisPlayer_rowViewModel_statsSection_returnsStatCase() {
        let sut = makeSUT(detailsType: .tennisPlayer(id: 42))
        mockRepository.stubbedTennisPlayerDetail = TestFixtureFactory.makeTennisPlayerDetail()
        sut.viewDidLoad()

        let exp = expectation(description: "ViewModel returned")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            let vm = sut.rowViewModel(at: IndexPath(row: 0, section: 0))
            if case .stat(let season, _, _, _, _, _) = vm {
                XCTAssertEqual(season, "2024")
            } else {
                XCTFail("Expected .stat view model for tennis stats section")
            }
            exp.fulfill()
        }
        waitForExpectations(timeout: 1)
    }

    func test_tennisPlayer_rowViewModel_tournamentsSection_returnsTournamentCase() {
        let sut = makeSUT(detailsType: .tennisPlayer(id: 42))
        mockRepository.stubbedTennisPlayerDetail = TestFixtureFactory.makeTennisPlayerDetail()
        sut.viewDidLoad()

        let exp = expectation(description: "ViewModel returned")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            let vm = sut.rowViewModel(at: IndexPath(row: 0, section: 1))
            if case .tournament(let name, _, _, _) = vm {
                XCTAssertEqual(name, "Roland Garros")
            } else {
                XCTFail("Expected .tournament view model for tennis tournaments section")
            }
            exp.fulfill()
        }
        waitForExpectations(timeout: 1)
    }
}
