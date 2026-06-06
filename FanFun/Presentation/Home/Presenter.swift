//
//  Presenter.swift
//  FanFun
//
//  Created by yassen on 25/05/2026.
//
import UIKit

class HomePresenter: HomePresenterProtocol {
    
    weak var view: HomeViewProtocol?
    private let router: AppRouterProtocol
    private var repository: SportsRepositoryProtocol
    private var sports: [Sport] = []
    
    init(router: AppRouterProtocol = AppRouter.shared, repository: SportsRepositoryProtocol = SportsRepositoryImpl()) {
        self.router = router
        self.repository = repository
    }

    func viewDidLoad() {
        fetchSports()
        view?.reloadCollectionView()
        view?.applyTheme(isDark: repository.isDarkMode)
    }

    func toggleTheme() {
        repository.isDarkMode.toggle()
        view?.applyTheme(isDark: repository.isDarkMode)
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
        router.navigateToLeagueScreen(from: view as? UIViewController, sportType: selectedSport.name)
    }
    
    var numberOfSports: Int {
        return sports.count
    }
    
    func getSport(at index: Int) -> Sport {
        return sports[index]
    }
}
