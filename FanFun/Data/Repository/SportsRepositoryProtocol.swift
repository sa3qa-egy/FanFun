import Foundation

protocol SportsRepositoryProtocol {
    func getLeagues(for sport: String, completion: @escaping (Result<[League], Error>) -> Void)
    func getUpcomingFixtures(for sport: String, leagueId: Int, completion: @escaping (Result<[Fixture], Error>) -> Void)
    func getPreviousFixtures(for sport: String, leagueId: Int, completion: @escaping (Result<[Fixture], Error>) -> Void)
    func getTeams(for sport: String, leagueId: Int, completion: @escaping (Result<[Team], Error>) -> Void)
    func getTeamDetails(teamId: Int, completion: @escaping (Result<TeamDetail, Error>) -> Void)
    func getTennisPlayerDetails(playerId: Int, completion: @escaping (Result<TennisPlayerDetail, Error>) -> Void)
    func addFavorite(league: League, sportType: String, completion: @escaping () -> Void)
    func removeFavorite(leagueKey: Int, sportType: String)
    func isFavorite(leagueKey: Int, sportType: String) -> Bool
    func getFavorites(for sportType: String) -> [League]
    func getAllFavorites() -> [String: [League]]
    func getCachedUpcomingFixtures(leagueKey: Int, sportType: String) -> [Fixture]
    func getCachedPreviousFixtures(leagueKey: Int, sportType: String) -> [Fixture]
    func getCachedTeams(leagueKey: Int, sportType: String) -> [Team]
    var isDarkMode: Bool { get set }
}
