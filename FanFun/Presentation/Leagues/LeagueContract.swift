protocol LeagueViewProtocol: AnyObject {
    func showLoading()
    func hideLoading()
    func reloadTableView()
    func showError(message: String)
    func showOfflineNotice()
    func hideOfflineNotice()
    func updateFavoriteStatus(at index: Int, isFavorite: Bool)
}

protocol LeaguePresenterProtocol {
    var numberOfLeagues: Int { get }
    func viewDidLoad(sportType: String)
    func getLeague(at index: Int) -> League
    func filterLeagues(with query: String)
    func didSelectLeague(at index: Int)
    func isFavorite(at index: Int) -> Bool
    func toggleFavorite(at index: Int)
}
