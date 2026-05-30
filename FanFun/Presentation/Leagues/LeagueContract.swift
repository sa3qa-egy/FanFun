//
//  LeagueContract.swift
//  FanFun
//
//  Created by yassen on 30/05/2026.
//

protocol LeagueViewProtocol: AnyObject {
    func showLoading()
    func hideLoading()
    func reloadTableView()
    func showError(message: String)
}

protocol LeaguePresenterProtocol {
    var numberOfLeagues: Int { get }
    func viewDidLoad()
    func getLeague(at index: Int) -> League
    func filterLeagues(with query: String)
}
