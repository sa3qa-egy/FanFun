//
//  PlayerResponse.swift
//  FanFun
//
//  Created by yassen on 02/06/2026.
//

struct PlayerResponse: Codable {
    let success: Int
    let result: [Player]?
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        success = try container.decode(Int.self, forKey: .success)
        result = try container.decodeIfPresent([Player].self, forKey: .result)
    }
}

struct Player: Codable {
    let playerKey: String?
    let playerName: String?
    let playerLogo: String?
    
    enum CodingKeys: String, CodingKey {
        case playerKey = "player_key"
        case playerName = "player_name"
        case playerLogo = "player_logo"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        if let intVal = try? container.decode(Int.self, forKey: .playerKey) {
            playerKey = String(intVal)
        } else if let strVal = try? container.decode(String.self, forKey: .playerKey) {
            playerKey = strVal
        } else {
            playerKey = nil
        }
        
        playerName = try container.decodeIfPresent(String.self, forKey: .playerName)
        playerLogo = try container.decodeIfPresent(String.self, forKey: .playerLogo)
    }
}
