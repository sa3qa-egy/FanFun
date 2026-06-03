//
//  TeamDetailsResponse.swift
//  FanFun
//

import Foundation


struct TeamDetailResponse: Codable {
    let success: Int
    let result: [TeamDetail]

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        success = try container.decode(Int.self, forKey: .success)
        result = (try? container.decode([TeamDetail].self, forKey: .result)) ?? []
    }

    enum CodingKeys: String, CodingKey {
        case success, result
    }
}

struct TeamDetail: Codable {
    let teamKey: String
    let teamName: String
    let teamLogo: String?
    let players: [TeamPlayer]

    enum CodingKeys: String, CodingKey {
        case teamKey  = "team_key"
        case teamName = "team_name"
        case teamLogo = "team_logo"
        case players
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        if let strVal = try? container.decode(String.self, forKey: .teamKey) {
            teamKey = strVal
        } else if let intVal = try? container.decode(Int.self, forKey: .teamKey) {
            teamKey = String(intVal)
        } else {
            teamKey = "0"
        }

        teamName = (try? container.decode(String.self, forKey: .teamName)) ?? "Unknown"
        teamLogo = try? container.decode(String.self, forKey: .teamLogo)
        players  = (try? container.decode([TeamPlayer].self, forKey: .players)) ?? []
    }
}

struct TeamPlayer: Codable {
    let playerKey: Int
    let playerName: String
    let playerNumber: String?
    let playerCountry: String?
    let playerType: String?
    let playerAge: String?
    let playerMatchPlayed: String?
    let playerGoals: String?
    let playerYellowCards: String?
    let playerRedCards: String?
    let playerImage: String?

    enum CodingKeys: String, CodingKey {
        case playerKey         = "player_key"
        case playerName        = "player_name"
        case playerNumber      = "player_number"
        case playerCountry     = "player_country"
        case playerType        = "player_type"
        case playerAge         = "player_age"
        case playerMatchPlayed = "player_match_played"
        case playerGoals       = "player_goals"
        case playerYellowCards = "player_yellow_cards"
        case playerRedCards    = "player_red_cards"
        case playerImage       = "player_image"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        if let intVal = try? container.decode(Int.self, forKey: .playerKey) {
            playerKey = intVal
        } else if let dblVal = try? container.decode(Double.self, forKey: .playerKey) {
            playerKey = Int(dblVal)
        } else {
            playerKey = 0
        }

        playerName        = (try? container.decode(String.self, forKey: .playerName)) ?? "Unknown"
        playerNumber      = try? container.decode(String.self, forKey: .playerNumber)
        playerCountry     = try? container.decode(String.self, forKey: .playerCountry)
        playerType        = try? container.decode(String.self, forKey: .playerType)
        playerAge         = try? container.decode(String.self, forKey: .playerAge)
        playerMatchPlayed = try? container.decode(String.self, forKey: .playerMatchPlayed)
        playerGoals       = try? container.decode(String.self, forKey: .playerGoals)
        playerYellowCards = try? container.decode(String.self, forKey: .playerYellowCards)
        playerRedCards    = try? container.decode(String.self, forKey: .playerRedCards)
        playerImage       = try? container.decode(String.self, forKey: .playerImage)
    }
}


struct TennisPlayerDetailResponse: Codable {
    let success: Int
    let result: [TennisPlayerDetail]

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        success = try container.decode(Int.self, forKey: .success)
        result  = (try? container.decode([TennisPlayerDetail].self, forKey: .result)) ?? []
    }

    enum CodingKeys: String, CodingKey {
        case success, result
    }
}

struct TennisPlayerDetail: Codable {
    let playerKey: String
    let playerName: String
    let playerCountry: String?
    let playerBirthday: String?
    let playerLogo: String?
    let stats: [TennisPlayerStat]
    let tournaments: [TennisTournament]

    enum CodingKeys: String, CodingKey {
        case playerKey     = "player_key"
        case playerName    = "player_name"
        case playerCountry = "player_country"
        case playerBirthday = "player_bday"
        case playerLogo    = "player_logo"
        case stats
        case tournaments
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        if let strVal = try? container.decode(String.self, forKey: .playerKey) {
            playerKey = strVal
        } else if let intVal = try? container.decode(Int.self, forKey: .playerKey) {
            playerKey = String(intVal)
        } else {
            playerKey = "0"
        }

        playerName     = (try? container.decode(String.self, forKey: .playerName)) ?? "Unknown"
        playerCountry  = try? container.decode(String.self, forKey: .playerCountry)
        playerBirthday = try? container.decode(String.self, forKey: .playerBirthday)
        playerLogo     = try? container.decode(String.self, forKey: .playerLogo)
        stats          = (try? container.decode([TennisPlayerStat].self, forKey: .stats)) ?? []
        tournaments    = (try? container.decode([TennisTournament].self, forKey: .tournaments)) ?? []
    }
}

struct TennisPlayerStat: Codable {
    let season: String?
    let type: String?
    let rank: String?
    let titles: String?
    let matchesWon: String?
    let matchesLost: String?
    let hardWon: String?
    let hardLost: String?
    let clayWon: String?
    let clayLost: String?
    let grassWon: String?
    let grassLost: String?

    enum CodingKeys: String, CodingKey {
        case season
        case type
        case rank
        case titles
        case matchesWon  = "matches_won"
        case matchesLost = "matches_lost"
        case hardWon     = "hard_won"
        case hardLost    = "hard_lost"
        case clayWon     = "clay_won"
        case clayLost    = "clay_lost"
        case grassWon    = "grass_won"
        case grassLost   = "grass_lost"
    }
}

struct TennisTournament: Codable {
    let name: String?
    let season: String?
    let type: String?
    let surface: String?
    let prize: String?
}
