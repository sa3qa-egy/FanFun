import Foundation
@testable import FanFun

enum TestFixtureFactory {

    static func makeLeague(key: Int = 1, name: String = "Premier League") -> League {
        return League(
            leagueKey: key,
            leagueName: name,
            countryKey: nil,
            countryName: nil,
            leagueLogo: nil,
            countryLogo: nil,
            leagueYear: nil
        )
    }

    static func makeFixture(eventKey: Int = 100, status: String = "Finished") -> Fixture {
        return Fixture(
            eventKey: eventKey,
            eventDate: "2025-01-01",
            eventTime: "20:00",
            eventHomeTeam: "Home FC",
            homeTeamKey: 10,
            eventAwayTeam: "Away FC",
            awayTeamKey: 20,
            eventFinalResult: "2 - 1",
            eventStatus: status,
            homeTeamLogo: nil,
            awayTeamLogo: nil
        )
    }

    static func makeTeam(key: Int = 50, name: String = "Team Alpha") -> Team {
        return Team(teamKey: key, teamName: name, teamLogo: nil)
    }

    static func makeTeamDetail(teamName: String = "Team Alpha") -> TeamDetail {
        let playerData: [String: Any] = [
            "player_key": 1,
            "player_name": "John Doe",
            "players": []
        ]
        let json: [String: Any] = [
            "team_key": "99",
            "team_name": teamName,
            "players": [playerData]
        ]
        let data = try! JSONSerialization.data(withJSONObject: json)
        return try! JSONDecoder().decode(TeamDetail.self, from: data)
    }

    static func makeTennisPlayerDetail(playerName: String = "Rafael Nadal") -> TennisPlayerDetail {
        let json: [String: Any] = [
            "player_key": "42",
            "player_name": playerName,
            "stats": [
                ["season": "2024", "type": "clay", "rank": "1", "titles": "5",
                 "matches_won": "30", "matches_lost": "3"]
            ],
            "tournaments": [
                ["name": "Roland Garros", "season": "2024", "surface": "Clay", "prize": "$2M"]
            ]
        ]
        let data = try! JSONSerialization.data(withJSONObject: json)
        return try! JSONDecoder().decode(TennisPlayerDetail.self, from: data)
    }
}
