import Foundation
import Alamofire

protocol NetworkServiceProtocol {
    func fetchLeagues(completion: @escaping (Result<[League], Error>) -> Void)
}

class NetworkService: NetworkServiceProtocol {
    private let baseUrl = "https://apiv2.allsportsapi.com/football"
    private let apiKey = "4f5c12b6f1f4d8eedfddc86465da5bc5232fa2b997973da9c29b62829c774cfd"
    
    func fetchLeagues(completion: @escaping (Result<[League], Error>) -> Void) {
        let parameters: [String: Any] = [
            "met": "Leagues",
            "APIkey": apiKey
        ]
        
        AF.request(baseUrl, parameters: parameters).responseDecodable(of: LeagueResponse.self) { response in
            switch response.result {
            case .success(let leagueResponse):
                completion(.success(leagueResponse.result))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
