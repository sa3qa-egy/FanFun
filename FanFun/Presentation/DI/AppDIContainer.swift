import UIKit

final class AppDIContainer {
    static let shared = AppDIContainer()
    
    private init() {}
    
    private lazy var networkMonitor = NetworkMonitor.shared
    private lazy var sportsRepository: SportsRepositoryProtocol = SportsRepositoryImpl()
    
    
    func injectHomeDependencies(view: HomeViewController) {
        let presenter = HomePresenter(view: view)
        view.presenter = presenter
    }
    
    func makeLeagueViewController(sportType: String) -> UIViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let view = storyboard.instantiateViewController(withIdentifier: "LeagueViewController") as? LeagueViewController else {
            fatalError("LeagueViewController not found in Storyboard")
        }
        let presenter = LeaguePresenter(
            view: view,
            repository: sportsRepository,
            sportType: sportType,
            networkMonitor: networkMonitor
        )
        view.presenter = presenter
        return view
    }
    
    func makeLeagueDetailsViewController(sportType: String, leagueId: Int, leagueName: String) -> UIViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let view = storyboard.instantiateViewController(withIdentifier: "LeagueDetailsViewController") as? LeagueDetailsViewController else {
            fatalError("LeagueDetailsViewController not found in Storyboard")
        }
        let presenter = LeagueDetailsPresenter(
            view: view,
            repository: sportsRepository,
            sportType: sportType,
            leagueId: leagueId
        )
        view.presenter = presenter
        view.leagueName = leagueName
        return view
    }
}
