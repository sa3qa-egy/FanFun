//
//  TeamDetailsContract.swift
//  FanFun
//

import Foundation


enum TeamDetailsType {
    case team(id: Int)
    case tennisPlayer(id: Int)
}


protocol TeamDetailsViewProtocol: AnyObject {
    func showLoading()
    func hideLoading()
    func reloadData()
    func showError(message: String)
}


protocol TeamDetailsPresenterProtocol {
    var headerImageURL: String? { get }
    var headerName: String { get }
    var numberOfSections: Int { get }
    func sectionTitle(for section: Int) -> String
    func numberOfRows(in section: Int) -> Int
    func isEmptySection(_ section: Int) -> Bool
    func rowViewModel(at indexPath: IndexPath) -> TeamDetailsRowViewModel
    func viewDidLoad()
}


enum TeamDetailsRowViewModel {
    case player(name: String, number: String?, position: String?, imageURL: String?)

    case stat(season: String, type: String, rank: String, titles: String,
              matchesWon: String, matchesLost: String)

    case tournament(name: String, season: String, surface: String, prize: String)
}
