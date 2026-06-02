protocol LeagueViewProtocol: AnyObject {
    func showLoading()
    func hideLoading()
    func reloadTableView()
    func showError(message: String)
    func showOfflineNotice()
    func hideOfflineNotice()
    func navigateToLeagueDetails(sportType: String, leagueId: Int, leagueName: String)
}

protocol LeaguePresenterProtocol {
    var numberOfLeagues: Int { get }
    var sportType: String { get }
    func viewDidLoad()
    func getLeague(at index: Int) -> League
    func filterLeagues(with query: String)
    func didSelectLeague(at index: Int)
}
