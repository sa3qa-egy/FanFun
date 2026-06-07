import Foundation

protocol NetworkServiceProtocol {
    func fetchLeagues(for sport: String, completion: @escaping (Result<[League], Error>) -> Void)
    func fetchFixtures(for sport: String, leagueId: Int, from: String, to: String, completion: @escaping (Result<[Fixture], Error>) -> Void)
    func fetchTeams(for sport: String, leagueId: Int, completion: @escaping (Result<[Team], Error>) -> Void)
    func fetchPlayers(for sport: String, leagueId: Int, completion: @escaping (Result<[Player], Error>) -> Void)
    func fetchTeamDetails(teamId: Int, completion: @escaping (Result<TeamDetail, Error>) -> Void)
    func fetchTennisPlayerDetails(playerId: Int, completion: @escaping (Result<TennisPlayerDetail, Error>) -> Void)
}
