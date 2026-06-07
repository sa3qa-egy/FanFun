import Foundation

protocol NetworkClientProtocol {
    func request<T: Decodable>(url: String, parameters: [String: Any], completion: @escaping (Result<T, Error>) -> Void)
}
