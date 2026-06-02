import Foundation
import Alamofire

protocol NetworkServiceProtocol {
    func fetchLeagues(for sport: String, completion: @escaping (Result<[League], Error>) -> Void)
    func fetchFixtures(for sport: String, leagueId: Int, from: String, to: String, completion: @escaping (Result<[Fixture], Error>) -> Void)
    func fetchTeams(for sport: String, leagueId: Int, completion: @escaping (Result<[Team], Error>) -> Void)
}

class NetworkService: NetworkServiceProtocol {
    private let baseDomain = "https://apiv2.allsportsapi.com/"
    
    private let session: Session = {
        let interceptor = APIKeyInterceptor()
        
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest  = 30
        configuration.timeoutIntervalForResource = 30
        
        return Session(configuration: configuration, interceptor: interceptor)
    }()
    
    func fetchLeagues(for sport: String, completion: @escaping (Result<[League], Error>) -> Void) {
        let url = baseDomain + sport.lowercased()
        let parameters: [String: Any] = ["met": "Leagues"]
        
        session.request(url, parameters: parameters).responseDecodable(of: LeagueResponse.self) { response in
            switch response.result {
            case .success(let leagueResponse):
                completion(.success(leagueResponse.result))
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
        
        session.request(url, parameters: parameters).responseDecodable(of: FixtureResponse.self) { response in
            switch response.result {
            case .success(let fixtureResponse):
                print("✅ Fixtures fetched: \(fixtureResponse.result.count) events for leagueId=\(leagueId)")
                completion(.success(fixtureResponse.result))
            case .failure(let error):
                print("❌ Fixtures fetch failed for leagueId=\(leagueId): \(error)")
                if let data = response.data, let raw = String(data: data.prefix(500), encoding: .utf8) {
                    print("📋 Raw response (first 500 chars): \(raw)")
                }
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
        
        session.request(url, parameters: parameters).responseDecodable(of: TeamResponse.self) { response in
            switch response.result {
            case .success(let teamResponse):
                print("✅ Teams fetched: \(teamResponse.result.count) teams for leagueId=\(leagueId)")
                completion(.success(teamResponse.result))
            case .failure(let error):
                print("❌ Teams fetch failed for leagueId=\(leagueId): \(error)")
                if let data = response.data, let raw = String(data: data.prefix(500), encoding: .utf8) {
                    print("📋 Raw response (first 500 chars): \(raw)")
                }
                completion(.failure(error))
            }
        }
    }
}
