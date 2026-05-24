import Foundation
import Alamofire

protocol NetworkServiceProtocol {
    func fetchLeagues(completion: @escaping (Result<[League], Error>) -> Void)
}

class NetworkService: NetworkServiceProtocol {
    private let baseUrl = "https://apiv2.allsportsapi.com/football"
    
    private let session: Session = {
        let interceptor = APIKeyInterceptor()
        return Session(interceptor: interceptor)
    }()
    
    func fetchLeagues(completion: @escaping (Result<[League], Error>) -> Void) {
        let parameters: [String: Any] = [
            "met": "Leagues"
        ]
        
        session.request(baseUrl, parameters: parameters).responseDecodable(of: LeagueResponse.self) { response in
            switch response.result {
            case .success(let leagueResponse):
                completion(.success(leagueResponse.result))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
