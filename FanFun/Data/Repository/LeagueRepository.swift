import Foundation

protocol LeagueRepositoryProtocol {
    func getLeagues(for sport: String, completion: @escaping (Result<[League], Error>) -> Void)
}

class LeagueRepository: LeagueRepositoryProtocol {
    private let networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol = NetworkService()) {
        self.networkService = networkService
    }
    
    func getLeagues(for sport: String, completion: @escaping (Result<[League], Error>) -> Void) {
        networkService.fetchLeagues(for: sport, completion: completion)
    }
}
