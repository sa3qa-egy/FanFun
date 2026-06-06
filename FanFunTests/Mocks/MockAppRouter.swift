import UIKit
@testable import FanFun

class MockAppRouter: AppRouterProtocol {

    var navigateToLeagueScreenCallCount = 0
    var navigateToLeagueDetailsCallCount = 0
    var navigateToTeamDetailsCallCount = 0
    var navigateToTennisPlayerDetailsCallCount = 0

    var lastLeagueScreenSportType: String?
    var lastLeagueDetailsSportType: String?
    var lastLeagueDetailsLeagueId: Int?
    var lastLeagueDetailsLeagueName: String?

    func navigateToLeagueScreen(from view: UIViewController?, sportType: String) {
        navigateToLeagueScreenCallCount += 1
        lastLeagueScreenSportType = sportType
    }

    func navigateToLeagueDetails(from view: UIViewController?, sportType: String, leagueId: Int, leagueName: String) {
        navigateToLeagueDetailsCallCount += 1
        lastLeagueDetailsSportType = sportType
        lastLeagueDetailsLeagueId = leagueId
        lastLeagueDetailsLeagueName = leagueName
    }

    func navigateToTeamDetails(from view: UIViewController?, teamId: Int, teamName: String) {
        navigateToTeamDetailsCallCount += 1
    }

    func navigateToTennisPlayerDetails(from view: UIViewController?, playerId: Int, playerName: String) {
        navigateToTennisPlayerDetailsCallCount += 1
    }
}
