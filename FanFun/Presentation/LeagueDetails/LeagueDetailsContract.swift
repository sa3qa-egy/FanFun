//
//  LeagueDetailsContract.swift
//  FanFun
//

import Foundation

protocol LeagueDetailsViewProtocol: AnyObject {
    func showLoading()
    func hideLoading()
    func reloadUpcomingMatches()
    func reloadPreviousMatches()
    func reloadTeams()
    func showError(message: String)
    func showOfflineBanner()
    func hideOfflineBanner()
    func updateFavoriteIcon(isFavorite: Bool)
}

protocol LeagueDetailsPresenterProtocol {
    var numberOfUpcomingMatches: Int { get }
    var numberOfPreviousMatches: Int { get }
    var numberOfTeams: Int { get }
    func viewDidLoad(sportType: String, leagueId: Int, leagueName: String)
    func getUpcomingMatch(at index: Int) -> Fixture
    func getPreviousMatch(at index: Int) -> Fixture
    func getTeam(at index: Int) -> Team
    func toggleFavorite()
}
