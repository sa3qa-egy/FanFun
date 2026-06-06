import Foundation
@testable import FanFun

class MockNetworkClient: NetworkClientProtocol {
    var shouldReturnError = false
    var expectedResult: Decodable?
    
    enum MockError: Error {
        case requestFailed
    }

    func request<T: Decodable>(url: String, parameters: [String: Any], completion: @escaping (Result<T, Error>) -> Void) {
        if shouldReturnError {
            completion(.failure(MockError.requestFailed))
        } else if let result = expectedResult as? T {
            completion(.success(result))
        } else {
            completion(.failure(MockError.requestFailed))
        }
    }
}
