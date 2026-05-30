//
//  HomeContract.swift
//  FanFun
//
//  Created by yassen on 25/05/2026.
//

import Foundation

protocol HomeViewProtocol: AnyObject {
    func reloadCollectionView()
    func navigateToLeagueScreen(with sportType: String)
}

protocol HomePresenterProtocol {
    var numberOfSports: Int { get }
    func viewDidLoad()
    func getSport(at index: Int) -> Sport
    func didSelectSport(at index: Int)
}
