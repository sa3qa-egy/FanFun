import Foundation
import UIKit

class LeaguePresenter: LeaguePresenterProtocol {
    weak var view: LeagueViewProtocol?
    private let repository: SportsRepositoryProtocol
    private let router: AppRouterProtocol
    private var sportType: String = ""
    private let networkMonitor: NetworkMonitorProtocol

    private var allLeagues: [League] = []
    private var filteredLeagues: [League] = []

    init(
        repository: SportsRepositoryProtocol = SportsRepositoryImpl(),
        router: AppRouterProtocol = AppRouter.shared,
        networkMonitor: NetworkMonitorProtocol = NetworkMonitor.shared
    ) {
        self.repository = repository
        self.router = router
        self.networkMonitor = networkMonitor
    }

    var numberOfLeagues: Int {
        return filteredLeagues.count
    }

    func viewDidLoad(sportType: String) {
        self.sportType = sportType
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

    func didSelectLeague(at index: Int) {
        let league = filteredLeagues[index]
        
        if !networkMonitor.isConnected {
            view?.showError(message: "No internet connection. Cannot navigate to details.")
            return
        }
        
        router.navigateToLeagueDetails(from: view as? UIViewController, sportType: sportType, leagueId: league.leagueKey, leagueName: league.leagueName)
    }

    func isFavorite(at index: Int) -> Bool {
        let league = filteredLeagues[index]
        return repository.isFavorite(leagueKey: league.leagueKey, sportType: sportType)
    }

    func toggleFavorite(at index: Int) {
        let league = filteredLeagues[index]
        if repository.isFavorite(leagueKey: league.leagueKey, sportType: sportType) {
            repository.removeFavorite(leagueKey: league.leagueKey, sportType: sportType)
            view?.updateFavoriteStatus(at: index, isFavorite: false)
        } else {
            repository.addFavorite(league: league, sportType: sportType) { [weak self] in
                self?.view?.updateFavoriteStatus(at: index, isFavorite: true)
            }
        }
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
