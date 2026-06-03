import UIKit

protocol AppRouterProtocol {
    func navigateToLeagueScreen(from view: UIViewController?, sportType: String)
    func navigateToLeagueDetails(from view: UIViewController?, sportType: String, leagueId: Int, leagueName: String)
    func navigateToTeamDetails(from view: UIViewController?, teamId: Int, teamName: String)
    func navigateToTennisPlayerDetails(from view: UIViewController?, playerId: Int, playerName: String)
}

final class AppRouter: AppRouterProtocol {
    static let shared = AppRouter()
    
    private init() {}
    
    func navigateToLeagueScreen(from view: UIViewController?, sportType: String) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "LeagueViewController") { coder in
            let presenter = LeaguePresenter()
            let leagueVC = LeagueViewController(coder: coder, presenter: presenter, sportType: sportType)
            presenter.view = leagueVC
            return leagueVC
        }
        vc.hidesBottomBarWhenPushed = true
        view?.navigationController?.pushViewController(vc, animated: true)
    }
    
    func navigateToLeagueDetails(from view: UIViewController?, sportType: String, leagueId: Int, leagueName: String) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "LeagueDetailsViewController") { coder in
            let presenter = LeagueDetailsPresenter()
            let detailsVC = LeagueDetailsViewController(coder: coder, presenter: presenter, leagueName: leagueName, sportType: sportType, leagueId: leagueId)
            presenter.view = detailsVC
            return detailsVC
        }
        vc.hidesBottomBarWhenPushed = true
        view?.navigationController?.pushViewController(vc, animated: true)
    }

    func navigateToTeamDetails(from view: UIViewController?, teamId: Int, teamName: String) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "TeamDetailsViewController") { coder in
            let presenter = TeamDetailsPresenter(detailsType: .team(id: teamId))
            let detailsVC = TeamDetailsViewController(coder: coder, presenter: presenter)
            presenter.view = detailsVC
            return detailsVC
        }
        vc.hidesBottomBarWhenPushed = true
        view?.navigationController?.pushViewController(vc, animated: true)
    }

    func navigateToTennisPlayerDetails(from view: UIViewController?, playerId: Int, playerName: String) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "TeamDetailsViewController") { coder in
            let presenter = TeamDetailsPresenter(detailsType: .tennisPlayer(id: playerId))
            let detailsVC = TeamDetailsViewController(coder: coder, presenter: presenter)
            presenter.view = detailsVC
            return detailsVC
        }
        vc.hidesBottomBarWhenPushed = true
        view?.navigationController?.pushViewController(vc, animated: true)
    }
}
