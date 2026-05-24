import Foundation

protocol LeagueRepositoryProtocol {
    func getLeagues(completion: @escaping (Result<[League], Error>) -> Void)
}

class LeagueRepository: LeagueRepositoryProtocol {
    private let networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol = NetworkService()) {
        self.networkService = networkService
    }
    
    func getLeagues(completion: @escaping (Result<[League], Error>) -> Void) {
        networkService.fetchLeagues { result in
            completion(result)
        }
    }
}
