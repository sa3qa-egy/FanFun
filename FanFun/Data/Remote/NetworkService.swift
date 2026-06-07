import Foundation

class NetworkService: NetworkServiceProtocol {
    private let baseDomain = "https://apiv2.allsportsapi.com/"
    private let networkClient: NetworkClientProtocol
    
    init(networkClient: NetworkClientProtocol = NetworkClient()) {
        self.networkClient = networkClient
    }
    
    func fetchLeagues(for sport: String, completion: @escaping (Result<[League], Error>) -> Void) {
        let url = baseDomain + sport.lowercased()
        let parameters: [String: Any] = ["met": "Leagues"]
        
        networkClient.request(url: url, parameters: parameters) { (result: Result<LeagueResponse, Error>) in
            switch result {
            case .success(let response):
                completion(.success(response.result))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func fetchFixtures(for sport: String, leagueId: Int, from: String, to: String, completion: @escaping (Result<[Fixture], Error>) -> Void) {
        let url = baseDomain + sport.lowercased()
        let parameters: [String: Any] = [
            "met": "Fixtures",
            "leagueId": leagueId,
            "from": from,
            "to": to
        ]
        
        networkClient.request(url: url, parameters: parameters) { (result: Result<FixtureResponse, Error>) in
            switch result {
            case .success(let response):
                print("✅ Fixtures fetched: \(response.result.count) events for leagueId=\(leagueId)")
                completion(.success(response.result))
            case .failure(let error):
                print("❌ Fixtures fetch failed for leagueId=\(leagueId): \(error)")
                completion(.failure(error))
            }
        }
    }
    
    func fetchTeams(for sport: String, leagueId: Int, completion: @escaping (Result<[Team], Error>) -> Void) {
        let url = baseDomain + sport.lowercased()
        let parameters: [String: Any] = [
            "met": "Teams",
            "leagueId": leagueId
        ]
        
        networkClient.request(url: url, parameters: parameters) { (result: Result<TeamResponse, Error>) in
            switch result {
            case .success(let response):
                print("✅ Teams fetched: \(response.result.count) teams for leagueId=\(leagueId)")
                completion(.success(response.result))
            case .failure(let error):
                print("❌ Teams fetch failed for leagueId=\(leagueId): \(error)")
                completion(.failure(error))
            }
        }
        
    }
    func fetchPlayers(for sport: String, leagueId: Int, completion: @escaping (Result<[Player], Error>) -> Void) {
        let url = baseDomain + sport.lowercased()
        let parameters: [String: Any] = [
            "met": "Players",
            "leagueId": leagueId
        ]
        
        networkClient.request(url: url, parameters: parameters) { (result: Result<PlayerResponse, Error>) in
            switch result {
            case .success(let response):
                print("✅ Players fetched: \(response.result?.count ?? 0) players for leagueId=\(leagueId)")
                completion(.success(response.result ?? []))
            case .failure(let error):
                print("❌ Players fetch failed for leagueId=\(leagueId): \(error)")
                completion(.failure(error))
            }
        }
    }

    func fetchTeamDetails(teamId: Int, completion: @escaping (Result<TeamDetail, Error>) -> Void) {
        let url = baseDomain + "football"
        let parameters: [String: Any] = [
            "met": "Teams",
            "teamId": teamId
        ]

        networkClient.request(url: url, parameters: parameters) { (result: Result<TeamDetailResponse, Error>) in
            switch result {
            case .success(let response):
                if let first = response.result.first {
                    print("✅ TeamDetail fetched for teamId=\(teamId): \(first.teamName)")
                    completion(.success(first))
                } else {
                    completion(.failure(NSError(domain: "TeamDetails", code: 404,
                                               userInfo: [NSLocalizedDescriptionKey: "Team not found"])))
                }
            case .failure(let error):
                print("❌ TeamDetail fetch failed for teamId=\(teamId): \(error)")
                completion(.failure(error))
            }
        }
    }

    func fetchTennisPlayerDetails(playerId: Int, completion: @escaping (Result<TennisPlayerDetail, Error>) -> Void) {
        let url = baseDomain + "tennis"
        let parameters: [String: Any] = [
            "met": "Players",
            "playerId": playerId
        ]

        networkClient.request(url: url, parameters: parameters) { (result: Result<TennisPlayerDetailResponse, Error>) in
            switch result {
            case .success(let response):
                if let first = response.result.first {
                    print("✅ TennisPlayerDetail fetched for playerId=\(playerId): \(first.playerName)")
                    completion(.success(first))
                } else {
                    completion(.failure(NSError(domain: "PlayerDetails", code: 404,
                                               userInfo: [NSLocalizedDescriptionKey: "Player not found"])))
                }
            case .failure(let error):
                print("❌ TennisPlayerDetail fetch failed for playerId=\(playerId): \(error)")
                completion(.failure(error))
            }
        }
    }
}
