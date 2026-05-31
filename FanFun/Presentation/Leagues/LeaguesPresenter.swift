import Foundation

class LeaguePresenter: LeaguePresenterProtocol {
    private weak var view: LeagueViewProtocol?
    private let repository: LeagueRepositoryProtocol
    private let sportType: String
    private let networkMonitor: NetworkMonitor
    
    private var allLeagues: [League] = []
    private var filteredLeagues: [League] = []
    
    init(
        view: LeagueViewProtocol,
        repository: LeagueRepositoryProtocol = LeagueRepository(),
        sportType: String,
        networkMonitor: NetworkMonitor = NetworkMonitor.shared
    ) {
        self.view = view
        self.repository = repository
        self.sportType = sportType
        self.networkMonitor = networkMonitor
    }
    
    var numberOfLeagues: Int {
        return filteredLeagues.count
    }
    
    func viewDidLoad() {
        fetchLeagues()
    }
    
    func getLeague(at index: Int) -> League {
        return filteredLeagues[index]
    }
    
    func filterLeagues(with query: String) {
        if query.trimmingCharacters(in: .whitespaces).isEmpty {
            filteredLeagues = allLeagues
        } else {
            filteredLeagues = allLeagues.filter { $0.leagueName.localizedCaseInsensitiveContains(query) }
        }
        view?.reloadTableView()
    }
    
    private func fetchLeagues() {
        view?.showLoading()
        repository.getLeagues(for: sportType) { [weak self] result in
            guard let self = self else { return }
            self.view?.hideLoading()
            
            switch result {
            case .success(let leagues):
                self.allLeagues = leagues
                self.filteredLeagues = leagues
                self.view?.reloadTableView()
                
                if self.networkMonitor.isConnected {
                    self.view?.hideOfflineNotice()
                } else {
                    self.view?.showOfflineNotice()
                }
                
            case .failure(let error):
                self.view?.showError(message: error.localizedDescription)
            }
        }
    }
}
