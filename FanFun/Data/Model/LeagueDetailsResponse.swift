import Foundation

// MARK: - Fixture Response
struct FixtureResponse: Codable {
    let success: Int
    let result: [Fixture]
    
    // API returns {"success":1} without "result" key when no fixtures exist
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        success = try container.decode(Int.self, forKey: .success)
        result = (try? container.decode([Fixture].self, forKey: .result)) ?? []
    }
    
    enum CodingKeys: String, CodingKey {
        case success, result
    }
}

struct Fixture: Codable {
    let eventKey: Int
    let eventDate: String
    let eventTime: String
    let eventHomeTeam: String
    let homeTeamKey: Int
    let eventAwayTeam: String
    let awayTeamKey: Int
    let eventHalftimeResult: String?
    let eventFinalResult: String?
    let eventFtResult: String?
    let eventPenaltyResult: String?
    let eventStatus: String?
    let countryName: String?
    let leagueName: String?
    let leagueKey: String?
    let leagueRound: String?
    let leagueSeason: String?
    let eventLive: String?
    let eventStadium: String?
    let homeTeamLogo: String?
    let awayTeamLogo: String?
    let leagueLogo: String?
    let countryLogo: String?
    
    enum CodingKeys: String, CodingKey {
        case eventKey = "event_key"
        case eventDate = "event_date"
        case eventTime = "event_time"
        case eventHomeTeam = "event_home_team"
        case homeTeamKey = "home_team_key"
        case eventAwayTeam = "event_away_team"
        case awayTeamKey = "away_team_key"
        case eventHalftimeResult = "event_halftime_result"
        case eventFinalResult = "event_final_result"
        case eventFtResult = "event_ft_result"
        case eventPenaltyResult = "event_penalty_result"
        case eventStatus = "event_status"
        case countryName = "country_name"
        case leagueName = "league_name"
        case leagueKey = "league_key"
        case leagueRound = "league_round"
        case leagueSeason = "league_season"
        case eventLive = "event_live"
        case eventStadium = "event_stadium"
        case homeTeamLogo = "home_team_logo"
        case awayTeamLogo = "away_team_logo"
        case leagueLogo = "league_logo"
        case countryLogo = "country_logo"
    }
    
    // Custom decoder to handle flexible types from the API
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        // event_key: can be Int or String
        if let intVal = try? container.decode(Int.self, forKey: .eventKey) {
            eventKey = intVal
        } else if let strVal = try? container.decode(String.self, forKey: .eventKey),
                  let intVal = Int(strVal) {
            eventKey = intVal
        } else {
            eventKey = 0
        }
        
        eventDate = try container.decode(String.self, forKey: .eventDate)
        eventTime = try container.decode(String.self, forKey: .eventTime)
        eventHomeTeam = try container.decode(String.self, forKey: .eventHomeTeam)
        eventAwayTeam = try container.decode(String.self, forKey: .eventAwayTeam)
        
        // home_team_key / away_team_key: API returns as Int (number), not String
        if let intVal = try? container.decode(Int.self, forKey: .homeTeamKey) {
            homeTeamKey = intVal
        } else if let strVal = try? container.decode(String.self, forKey: .homeTeamKey),
                  let intVal = Int(strVal) {
            homeTeamKey = intVal
        } else {
            homeTeamKey = 0
        }
        
        if let intVal = try? container.decode(Int.self, forKey: .awayTeamKey) {
            awayTeamKey = intVal
        } else if let strVal = try? container.decode(String.self, forKey: .awayTeamKey),
                  let intVal = Int(strVal) {
            awayTeamKey = intVal
        } else {
            awayTeamKey = 0
        }
        
        eventHalftimeResult = try container.decodeIfPresent(String.self, forKey: .eventHalftimeResult)
        eventFinalResult = try container.decodeIfPresent(String.self, forKey: .eventFinalResult)
        eventFtResult = try container.decodeIfPresent(String.self, forKey: .eventFtResult)
        eventPenaltyResult = try container.decodeIfPresent(String.self, forKey: .eventPenaltyResult)
        eventStatus = try container.decodeIfPresent(String.self, forKey: .eventStatus)
        countryName = try container.decodeIfPresent(String.self, forKey: .countryName)
        leagueName = try container.decodeIfPresent(String.self, forKey: .leagueName)
        
        // league_key can be Int or String
        if let strVal = try? container.decode(String.self, forKey: .leagueKey) {
            leagueKey = strVal
        } else if let intVal = try? container.decode(Int.self, forKey: .leagueKey) {
            leagueKey = String(intVal)
        } else {
            leagueKey = nil
        }
        
        leagueRound = try container.decodeIfPresent(String.self, forKey: .leagueRound)
        leagueSeason = try container.decodeIfPresent(String.self, forKey: .leagueSeason)
        
        // event_live can be String or Int
        if let strVal = try? container.decode(String.self, forKey: .eventLive) {
            eventLive = strVal
        } else if let intVal = try? container.decode(Int.self, forKey: .eventLive) {
            eventLive = String(intVal)
        } else {
            eventLive = nil
        }
        
        eventStadium = try container.decodeIfPresent(String.self, forKey: .eventStadium)
        homeTeamLogo = try container.decodeIfPresent(String.self, forKey: .homeTeamLogo)
        awayTeamLogo = try container.decodeIfPresent(String.self, forKey: .awayTeamLogo)
        leagueLogo = try container.decodeIfPresent(String.self, forKey: .leagueLogo)
        countryLogo = try container.decodeIfPresent(String.self, forKey: .countryLogo)
    }
}

// MARK: - Team Response
struct TeamResponse: Codable {
    let success: Int
    let result: [Team]
    
    // API may omit "result" key when no teams exist
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        success = try container.decode(Int.self, forKey: .success)
        result = (try? container.decode([Team].self, forKey: .result)) ?? []
    }
    
    enum CodingKeys: String, CodingKey {
        case success, result
    }
}

struct Team: Codable {
    let teamKey: Int
    let teamName: String
    let teamLogo: String?
    
    enum CodingKeys: String, CodingKey {
        case teamKey = "team_key"
        case teamName = "team_name"
        case teamLogo = "team_logo"
    }
    
    // Custom decoder: team_key can be Int or String, team_name can be null
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        if let intVal = try? container.decode(Int.self, forKey: .teamKey) {
            teamKey = intVal
        } else if let strVal = try? container.decode(String.self, forKey: .teamKey),
                  let intVal = Int(strVal) {
            teamKey = intVal
        } else {
            teamKey = 0
        }
        
        // team_name can be null in some API responses
        teamName = (try? container.decode(String.self, forKey: .teamName)) ?? "Unknown"
        teamLogo = try container.decodeIfPresent(String.self, forKey: .teamLogo)
    }
}
