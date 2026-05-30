//
//  Presenter.swift
//  FanFun
//
//  Created by yassen on 25/05/2026.
//
import UIKit

class HomePresenter: HomePresenterProtocol {
    
    private weak var view: HomeViewProtocol?
    private var sports: [Sport] = []
    
    init(view: HomeViewProtocol) {
        self.view = view
    }
    
    func viewDidLoad() {
        fetchSports()
        view?.reloadCollectionView()
    }
    
    private func fetchSports() {
        sports = [
            Sport(name: "Football", image: UIImage(named: "football") ?? UIImage(systemName: "sportscourt")),
            Sport(name: "Tennis", image: UIImage(named: "tennis") ?? UIImage(systemName: "sportscourt")),
            Sport(name: "cricket", image: UIImage(named: "cricket") ?? UIImage(systemName: "sportscourt")),
            Sport(name: "Basketball", image: UIImage(named: "basketball") ?? UIImage(systemName: "sportscourt"))
        ]
    }
    
    func didSelectSport(at index: Int) {
            let selectedSport = getSport(at: index)
                        
            view?.navigateToLeagueScreen(with: selectedSport.name)
        }
    
    var numberOfSports: Int {
        return sports.count
    }
    
    func getSport(at index: Int) -> Sport {
        return sports[index]
    }
}
