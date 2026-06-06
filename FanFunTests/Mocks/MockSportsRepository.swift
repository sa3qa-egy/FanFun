import Foundation
@testable import FanFun

class MockSportsRepository: SportsRepositoryProtocol {

    var shouldReturnError: Bool

    var stubbedLeagues: [League] = []
    var stubbedUpcomingFixtures: [Fixture] = []
    var stubbedPreviousFixtures: [Fixture] = []
    var stubbedTeams: [Team] = []
    var stubbedTeamDetail: TeamDetail? = nil
    var stubbedTennisPlayerDetail: TennisPlayerDetail? = nil
    var stubbedAllFavorites: [String: [League]] = [:]
    var stubbedIsFavorite: Bool = false
    var stubbedCachedUpcoming: [Fixture] = []
    var stubbedCachedPrevious: [Fixture] = []
    var stubbedCachedTeams: [Team] = []

    var addFavoriteCallCount = 0
    var removeFavoriteCallCount = 0
    var lastRemovedLeagueKey: Int?
    var lastRemovedSportType: String?
    var isDarkMode: Bool = false

    enum MockError: Error {
        case repositoryError
    }

    init(shouldReturnError: Bool = false) {
        self.shouldReturnError = shouldReturnError
    }

    func getLeagues(for sport: String, completion: @escaping (Result<[League], Error>) -> Void) {
        if shouldReturnError {
            completion(.failure(MockError.repositoryError))
        } else {
            completion(.success(stubbedLeagues))
        }
    }

    func getUpcomingFixtures(for sport: String, leagueId: Int, completion: @escaping (Result<[Fixture], Error>) -> Void) {
        if shouldReturnError {
            completion(.failure(MockError.repositoryError))
        } else {
            completion(.success(stubbedUpcomingFixtures))
        }
    }

    func getPreviousFixtures(for sport: String, leagueId: Int, completion: @escaping (Result<[Fixture], Error>) -> Void) {
        if shouldReturnError {
            completion(.failure(MockError.repositoryError))
        } else {
            completion(.success(stubbedPreviousFixtures))
        }
    }

    func getTeams(for sport: String, leagueId: Int, completion: @escaping (Result<[Team], Error>) -> Void) {
        if shouldReturnError {
            completion(.failure(MockError.repositoryError))
        } else {
            completion(.success(stubbedTeams))
        }
    }

    func getTeamDetails(teamId: Int, completion: @escaping (Result<TeamDetail, Error>) -> Void) {
        if shouldReturnError {
            completion(.failure(MockError.repositoryError))
        } else if let detail = stubbedTeamDetail {
            completion(.success(detail))
        } else {
            completion(.failure(MockError.repositoryError))
        }
    }

    func getTennisPlayerDetails(playerId: Int, completion: @escaping (Result<TennisPlayerDetail, Error>) -> Void) {
        if shouldReturnError {
            completion(.failure(MockError.repositoryError))
        } else if let detail = stubbedTennisPlayerDetail {
            completion(.success(detail))
        } else {
            completion(.failure(MockError.repositoryError))
        }
    }

    func addFavorite(league: League, sportType: String, completion: @escaping () -> Void) {
        addFavoriteCallCount += 1
        completion()
    }

    func removeFavorite(leagueKey: Int, sportType: String) {
        removeFavoriteCallCount += 1
        lastRemovedLeagueKey = leagueKey
        lastRemovedSportType = sportType
    }

    func isFavorite(leagueKey: Int, sportType: String) -> Bool {
        return stubbedIsFavorite
    }

    func getFavorites(for sportType: String) -> [League] {
        return stubbedLeagues
    }

    func getAllFavorites() -> [String: [League]] {
        return stubbedAllFavorites
    }

    func getCachedUpcomingFixtures(leagueKey: Int, sportType: String) -> [Fixture] {
        return stubbedCachedUpcoming
    }

    func getCachedPreviousFixtures(leagueKey: Int, sportType: String) -> [Fixture] {
        return stubbedCachedPrevious
    }

    func getCachedTeams(leagueKey: Int, sportType: String) -> [Team] {
        return stubbedCachedTeams
    }
}
