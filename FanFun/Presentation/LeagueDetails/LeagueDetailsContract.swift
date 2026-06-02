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
}

protocol LeagueDetailsPresenterProtocol {
    var numberOfUpcomingMatches: Int { get }
    var numberOfPreviousMatches: Int { get }
    var numberOfTeams: Int { get }
    func viewDidLoad()
    func getUpcomingMatch(at index: Int) -> Fixture
    func getPreviousMatch(at index: Int) -> Fixture
    func getTeam(at index: Int) -> Team
}
