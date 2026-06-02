import Foundation
import Alamofire

protocol NetworkClientProtocol {
    func request<T: Decodable>(url: String, parameters: [String: Any], completion: @escaping (Result<T, Error>) -> Void)
}

class NetworkClient: NetworkClientProtocol {
    private let session: Session = {
        let interceptor = APIKeyInterceptor()
        
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest  = 30
        configuration.timeoutIntervalForResource = 30
        
        return Session(configuration: configuration, interceptor: interceptor)
    }()
    
    func request<T: Decodable>(url: String, parameters: [String: Any], completion: @escaping (Result<T, Error>) -> Void) {
        session.request(url, parameters: parameters).responseDecodable(of: T.self) { response in
            switch response.result {
            case .success(let value):
                completion(.success(value))
            case .failure(let error):
                if let data = response.data, let raw = String(data: data.prefix(500), encoding: .utf8) {
                    print("📋 Raw response (first 500 chars): \(raw)")
                }
                completion(.failure(error))
            }
        }
    }
}
