import Foundation

class LeaguePresenter: LeaguePresenterProtocol {
    private weak var view: LeagueViewProtocol?
    private let repository: LeagueRepositoryProtocol
    private let sportType: String
    
    private var allLeagues: [League] = []
    private var filteredLeagues: [League] = []
    
    init(view: LeagueViewProtocol, repository: LeagueRepositoryProtocol = LeagueRepository(), sportType: String) {
        self.view = view
        self.repository = repository
        self.sportType = sportType
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
            case .failure(let error):
                self.view?.showError(message: error.localizedDescription)
            }
        }
    }
}
