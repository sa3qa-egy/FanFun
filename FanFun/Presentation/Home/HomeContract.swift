//
//  HomeContract.swift
//  FanFun
//
//  Created by yassen on 25/05/2026.
//

import Foundation

protocol HomeViewProtocol: AnyObject {
    func reloadCollectionView()
}

protocol HomePresenterProtocol {
    var numberOfSports: Int { get }
    func viewDidLoad()
    func getSport(at index: Int) -> Sport
    func didSelectSport(at index: Int)
}
