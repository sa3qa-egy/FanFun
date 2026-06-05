import Foundation
import UIKit

class FavoritesPresenter: FavoritesPresenterProtocol {
    weak var view: FavoritesViewProtocol?
    private let repository: SportsRepositoryProtocol
    private let router: AppRouterProtocol

    private let sportOrder = ["football", "tennis", "cricket", "basketball"]
    private var sections: [(sport: String, leagues: [League])] = []

    init(
        repository: SportsRepositoryProtocol = SportsRepositoryImpl(),
        router: AppRouterProtocol = AppRouter.shared
    ) {
        self.repository = repository
        self.router = router
    }

    var numberOfSections: Int {
        return sections.count
    }

    func sectionTitle(for section: Int) -> String {
        return sections[section].sport.capitalized
    }

    func numberOfLeagues(in section: Int) -> Int {
        return sections[section].leagues.count
    }

    func getLeague(at indexPath: IndexPath) -> League {
        return sections[indexPath.section].leagues[indexPath.row]
    }

    func getSportType(for section: Int) -> String {
        return sections[section].sport
    }

    func viewWillAppear() {
        loadFavorites()
    }

    func didSelectLeague(at indexPath: IndexPath) {
        let league = sections[indexPath.section].leagues[indexPath.row]
        let sport = sections[indexPath.section].sport
        router.navigateToLeagueDetails(from: view as? UIViewController, sportType: sport, leagueId: league.leagueKey, leagueName: league.leagueName)
    }

    func removeFavorite(at indexPath: IndexPath) {
        let league = sections[indexPath.section].leagues[indexPath.row]
        let sport = sections[indexPath.section].sport
        repository.removeFavorite(leagueKey: league.leagueKey, sportType: sport)
        loadFavorites()
    }

    private func loadFavorites() {
        let allFavorites = repository.getAllFavorites()
        sections = sportOrder.compactMap { sport in
            guard let leagues = allFavorites[sport], !leagues.isEmpty else { return nil }
            return (sport: sport, leagues: leagues)
        }
        if sections.isEmpty {
            view?.showEmptyState()
        } else {
            view?.hideEmptyState()
        }
        view?.reloadData()
    }
}
