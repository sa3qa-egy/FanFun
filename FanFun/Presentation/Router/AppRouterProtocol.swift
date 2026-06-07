import UIKit

protocol AppRouterProtocol {
    func navigateToLeagueScreen(from view: UIViewController?, sportType: String)
    func navigateToLeagueDetails(from view: UIViewController?, sportType: String, leagueId: Int, leagueName: String)
    func navigateToTeamDetails(from view: UIViewController?, teamId: Int, teamName: String)
    func navigateToTennisPlayerDetails(from view: UIViewController?, playerId: Int, playerName: String)
}
