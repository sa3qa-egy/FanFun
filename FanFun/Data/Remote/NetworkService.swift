import Foundation

protocol NetworkServiceProtocol {
    func fetchLeagues(for sport: String, completion: @escaping (Result<[League], Error>) -> Void)
    func fetchFixtures(for sport: String, leagueId: Int, from: String, to: String, completion: @escaping (Result<[Fixture], Error>) -> Void)
    func fetchTeams(for sport: String, leagueId: Int, completion: @escaping (Result<[Team], Error>) -> Void)
}

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
}
