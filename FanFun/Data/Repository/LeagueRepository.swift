import Foundation

enum OfflineError: LocalizedError {
    case noCache
    
    var errorDescription: String? {
        return "You're offline and no cached data is available. Please connect to the internet and try again."
    }
}

protocol LeagueRepositoryProtocol {
    func getLeagues(for sport: String, completion: @escaping (Result<[League], Error>) -> Void)
}

class LeagueRepository: LeagueRepositoryProtocol {
    
    private let networkService: NetworkServiceProtocol
    private let localDataSource: LeagueLocalDataSource
    private let networkMonitor: NetworkMonitor
    
    init(
        networkService: NetworkServiceProtocol = NetworkService(),
        localDataSource: LeagueLocalDataSource = LeagueLocalDataSource(),
        networkMonitor: NetworkMonitor = NetworkMonitor.shared
    ) {
        self.networkService = networkService
        self.localDataSource = localDataSource
        self.networkMonitor = networkMonitor
    }
    
    func getLeagues(for sport: String, completion: @escaping (Result<[League], Error>) -> Void) {
        
        guard networkMonitor.isConnected else {
            let cached = localDataSource.fetchLeagues(for: sport)
            if cached.isEmpty {
                completion(.failure(OfflineError.noCache))
            } else {
                completion(.success(cached))
            }
            return
        }
        
        networkService.fetchLeagues(for: sport) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let leagues):
                self.localDataSource.saveLeagues(leagues, for: sport)
                completion(.success(leagues))
                
            case .failure(let error):
                let cached = self.localDataSource.fetchLeagues(for: sport)
                if cached.isEmpty {
                    completion(.failure(error))
                } else {
                    completion(.success(cached))
                }
            }
        }
    }
}
