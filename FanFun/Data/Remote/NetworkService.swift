import Foundation
import Alamofire

protocol NetworkServiceProtocol {
    func fetchLeagues(for sport: String, completion: @escaping (Result<[League], Error>) -> Void)
}

class NetworkService: NetworkServiceProtocol {
    private let baseDomain = "https://apiv2.allsportsapi.com/"
        
        private let session: Session = {
            let interceptor = APIKeyInterceptor() 
            return Session(interceptor: interceptor)
        }()
        
        func fetchLeagues(for sport: String, completion: @escaping (Result<[League], Error>) -> Void) {
            let url = baseDomain + sport.lowercased()
            let parameters: [String: Any] = ["met": "Leagues"]
            print(url)
            print(parameters)
            session.request(url, parameters: parameters).responseDecodable(of: LeagueResponse.self) { response in
                print(response)
                switch response.result {
                case .success(let leagueResponse):
                    completion(.success(leagueResponse.result))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
}
