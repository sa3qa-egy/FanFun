import Foundation

class LeagueDetailsPresenter: LeagueDetailsPresenterProtocol {
    
    weak var view: LeagueDetailsViewProtocol?
    private let repository: SportsRepositoryProtocol
    private let networkMonitor: NetworkMonitorProtocol
    private var sportType: String = ""
    private var leagueId: Int = 0
    
    private var upcomingMatches: [Fixture] = []
    private var previousMatches: [Fixture] = []
    private var teams: [Team] = []
    
    private let dispatchGroup = DispatchGroup()
    
    init(
        repository: SportsRepositoryProtocol = SportsRepositoryImpl(),
        networkMonitor: NetworkMonitorProtocol = NetworkMonitor.shared
    ) {
        self.repository = repository
        self.networkMonitor = networkMonitor
    }
    
    
    var numberOfUpcomingMatches: Int {
        return upcomingMatches.count
    }
    
    var numberOfPreviousMatches: Int {
        return previousMatches.count
    }
    
    var numberOfTeams: Int {
        return teams.count
    }
    
    func viewDidLoad(sportType: String, leagueId: Int) {
        self.sportType = sportType
        self.leagueId = leagueId
        view?.showLoading()
        fetchAllData()
    }
    
    func getUpcomingMatch(at index: Int) -> Fixture {
        return upcomingMatches[index]
    }
    
    func getPreviousMatch(at index: Int) -> Fixture {
        return previousMatches[index]
    }
    
    func getTeam(at index: Int) -> Team {
        return teams[index]
    }
    
    private func fetchAllData() {
        if !networkMonitor.isConnected && repository.isFavorite(leagueKey: leagueId, sportType: sportType) {
            loadFromCache()
        } else {
            loadFromNetwork()
        }
    }

    private func loadFromCache() {
        upcomingMatches = repository.getCachedUpcomingFixtures(leagueKey: leagueId, sportType: sportType)
        previousMatches = repository.getCachedPreviousFixtures(leagueKey: leagueId, sportType: sportType)
        teams = repository.getCachedTeams(leagueKey: leagueId, sportType: sportType)
        
        view?.reloadUpcomingMatches()
        view?.reloadPreviousMatches()
        view?.reloadTeams()
        
        view?.hideLoading()
        view?.showOfflineBanner()
    }

    private func loadFromNetwork() {
        view?.hideOfflineBanner()
        var fetchErrors: [Error] = []
        
        dispatchGroup.enter()
        repository.getUpcomingFixtures(for: sportType, leagueId: leagueId) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let fixtures):
                self.upcomingMatches = fixtures
                self.view?.reloadUpcomingMatches()
            case .failure(let error):
                fetchErrors.append(error)
            }
            self.dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        repository.getPreviousFixtures(for: sportType, leagueId: leagueId) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let fixtures):
                self.previousMatches = fixtures
                self.view?.reloadPreviousMatches()
            case .failure(let error):
                fetchErrors.append(error)
            }
            self.dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        repository.getTeams(for: sportType, leagueId: leagueId) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let teams):
                self.teams = teams
                self.view?.reloadTeams()
            case .failure(let error):
                fetchErrors.append(error)
            }
            self.dispatchGroup.leave()
        }
        
        dispatchGroup.notify(queue: .main) { [weak self] in
            guard let self = self else { return }
            self.view?.hideLoading()
            if !fetchErrors.isEmpty && self.upcomingMatches.isEmpty && self.previousMatches.isEmpty && self.teams.isEmpty {
                self.view?.showError(message: "Failed to load league data.")
            }
        }
    }
}
