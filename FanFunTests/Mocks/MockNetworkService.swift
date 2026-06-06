import Foundation
@testable import FanFun

class MockNetworkService: NetworkServiceProtocol {
    var shouldReturnError = false
    
    var stubbedLeagues: [League] = []
    var stubbedFixtures: [Fixture] = []
    var stubbedTeams: [Team] = []
    var stubbedPlayers: [Player] = []
    var stubbedTeamDetail: TeamDetail?
    var stubbedTennisPlayerDetail: TennisPlayerDetail?

    enum MockError: Error {
        case requestFailed
    }

    func fetchLeagues(for sport: String, completion: @escaping (Result<[League], Error>) -> Void) {
        if shouldReturnError {
            completion(.failure(MockError.requestFailed))
        } else {
            completion(.success(stubbedLeagues))
        }
    }

    func fetchFixtures(for sport: String, leagueId: Int, from: String, to: String, completion: @escaping (Result<[Fixture], Error>) -> Void) {
        if shouldReturnError {
            completion(.failure(MockError.requestFailed))
        } else {
            completion(.success(stubbedFixtures))
        }
    }

    func fetchTeams(for sport: String, leagueId: Int, completion: @escaping (Result<[Team], Error>) -> Void) {
        if shouldReturnError {
            completion(.failure(MockError.requestFailed))
        } else {
            completion(.success(stubbedTeams))
        }
    }

    func fetchPlayers(for sport: String, leagueId: Int, completion: @escaping (Result<[Player], Error>) -> Void) {
        if shouldReturnError {
            completion(.failure(MockError.requestFailed))
        } else {
            completion(.success(stubbedPlayers))
        }
    }

    func fetchTeamDetails(teamId: Int, completion: @escaping (Result<TeamDetail, Error>) -> Void) {
        if shouldReturnError {
            completion(.failure(MockError.requestFailed))
        } else if let detail = stubbedTeamDetail {
            completion(.success(detail))
        } else {
            completion(.failure(MockError.requestFailed))
        }
    }

    func fetchTennisPlayerDetails(playerId: Int, completion: @escaping (Result<TennisPlayerDetail, Error>) -> Void) {
        if shouldReturnError {
            completion(.failure(MockError.requestFailed))
        } else if let detail = stubbedTennisPlayerDetail {
            completion(.success(detail))
        } else {
            completion(.failure(MockError.requestFailed))
        }
    }
}
