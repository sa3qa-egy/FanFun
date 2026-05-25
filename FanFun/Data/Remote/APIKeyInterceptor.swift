import Foundation
import Alamofire

class APIKeyInterceptor: RequestInterceptor {
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        var request = urlRequest
        
        guard let urlString = request.url?.absoluteString else {
            completion(.success(request))
            return
        }
        
        if var urlComponents = URLComponents(string: urlString) {
            var queryItems = urlComponents.queryItems ?? []
            queryItems.append(URLQueryItem(name: "APIkey", value: Secrets.apiKey))
            urlComponents.queryItems = queryItems
            
            request.url = urlComponents.url
        }
        
        completion(.success(request))
    }
}
