import Foundation

protocol FavoritesViewProtocol: AnyObject {
    func reloadData()
    func showEmptyState()
    func hideEmptyState()
}

protocol FavoritesPresenterProtocol {
    var numberOfSections: Int { get }
    func sectionTitle(for section: Int) -> String
    func numberOfLeagues(in section: Int) -> Int
    func getLeague(at indexPath: IndexPath) -> League
    func getSportType(for section: Int) -> String
    func viewWillAppear()
    func didSelectLeague(at indexPath: IndexPath)
    func removeFavorite(at indexPath: IndexPath)
}
