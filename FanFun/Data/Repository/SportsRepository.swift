import Foundation

enum OfflineError: LocalizedError {
    case noCache
    
    var errorDescription: String? {
        return "You're offline and no cached data is available. Please connect to the internet and try again."
    }
}

protocol SportsRepositoryProtocol {
    func getLeagues(for sport: String, completion: @escaping (Result<[League], Error>) -> Void)
    func getUpcomingFixtures(for sport: String, leagueId: Int, completion: @escaping (Result<[Fixture], Error>) -> Void)
    func getPreviousFixtures(for sport: String, leagueId: Int, completion: @escaping (Result<[Fixture], Error>) -> Void)
    func getTeams(for sport: String, leagueId: Int, completion: @escaping (Result<[Team], Error>) -> Void)
    func getTeamDetails(teamId: Int, completion: @escaping (Result<TeamDetail, Error>) -> Void)
    func getTennisPlayerDetails(playerId: Int, completion: @escaping (Result<TennisPlayerDetail, Error>) -> Void)
}

class SportsRepositoryImpl: SportsRepositoryProtocol {
    
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
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
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
    
    func getUpcomingFixtures(for sport: String, leagueId: Int, completion: @escaping (Result<[Fixture], Error>) -> Void) {
        let today = Date()
        let oneYearLater = Calendar.current.date(byAdding: .year, value: 1, to: today) ?? today
        
        let fromDate = dateFormatter.string(from: today)
        let toDate = dateFormatter.string(from: oneYearLater)
        
        networkService.fetchFixtures(for: sport, leagueId: leagueId, from: fromDate, to: toDate) { result in
            switch result {
            case .success(let fixtures):
                let upcoming = fixtures.filter { fixture in
                    let status = (fixture.eventStatus ?? "").trimmingCharacters(in: .whitespaces)
                    return status != "Finished" && status != "After Pen." && status != "After ET"
                }
                completion(.success(upcoming))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getPreviousFixtures(for sport: String, leagueId: Int, completion: @escaping (Result<[Fixture], Error>) -> Void) {
        let today = Date()
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: today) ?? today
        let oneYearAgo = Calendar.current.date(byAdding: .year, value: -1, to: today) ?? today
        
        let fromDate = dateFormatter.string(from: oneYearAgo)
        let toDate = dateFormatter.string(from: yesterday)
        
        networkService.fetchFixtures(for: sport, leagueId: leagueId, from: fromDate, to: toDate) { result in
            switch result {
            case .success(let fixtures):
                let finished = fixtures.filter { fixture in
                    let status = (fixture.eventStatus ?? "").trimmingCharacters(in: .whitespaces)
                    return status == "Finished" || status == "After Pen." || status == "After ET"
                }
                let sorted = finished.sorted { $0.eventDate > $1.eventDate }
                completion(.success(sorted))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getTeams(for sport: String, leagueId: Int, completion: @escaping (Result<[Team], Error>) -> Void) {
        if sport.lowercased() == "tennis" {
            networkService.fetchPlayers(for: sport, leagueId: leagueId) { result in
                switch result {
                case .success(let players):
                    let mappedTeams = players.compactMap { player -> Team? in
                        let keyString = player.playerKey ?? "0"
                        let key = Int(keyString) ?? 0
                        
                        return Team(
                            teamKey: key,
                            teamName: player.playerName ?? "Unknown Player",
                            teamLogo: player.playerLogo
                        )
                    }
                    completion(.success(mappedTeams))
                    
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        } else {
            networkService.fetchTeams(for: sport, leagueId: leagueId, completion: completion)
        }
    }

    func getTeamDetails(teamId: Int, completion: @escaping (Result<TeamDetail, Error>) -> Void) {
        networkService.fetchTeamDetails(teamId: teamId, completion: completion)
    }

    func getTennisPlayerDetails(playerId: Int, completion: @escaping (Result<TennisPlayerDetail, Error>) -> Void) {
        networkService.fetchTennisPlayerDetails(playerId: playerId, completion: completion)
    }
}
