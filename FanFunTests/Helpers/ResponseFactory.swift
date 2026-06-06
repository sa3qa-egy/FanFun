import Foundation
@testable import FanFun

class ResponseFactory {
    static func makeLeagueResponse(success: Int = 1, leagues: [[String: Any]]) -> LeagueResponse {
        let json: [String: Any] = ["success": success, "result": leagues]
        let data = try! JSONSerialization.data(withJSONObject: json)
        return try! JSONDecoder().decode(LeagueResponse.self, from: data)
    }
    
    static func makeFixtureResponse(success: Int = 1, fixtures: [[String: Any]]) -> FixtureResponse {
        let json: [String: Any] = ["success": success, "result": fixtures]
        let data = try! JSONSerialization.data(withJSONObject: json)
        return try! JSONDecoder().decode(FixtureResponse.self, from: data)
    }
    
    static func makeTeamResponse(success: Int = 1, teams: [[String: Any]]) -> TeamResponse {
        let json: [String: Any] = ["success": success, "result": teams]
        let data = try! JSONSerialization.data(withJSONObject: json)
        return try! JSONDecoder().decode(TeamResponse.self, from: data)
    }
    
    static func makePlayerResponse(success: Int = 1, players: [[String: Any]]) -> PlayerResponse {
        let json: [String: Any] = ["success": success, "result": players]
        let data = try! JSONSerialization.data(withJSONObject: json)
        return try! JSONDecoder().decode(PlayerResponse.self, from: data)
    }
    
    static func makeTeamDetailResponse(success: Int = 1, details: [[String: Any]]) -> TeamDetailResponse {
        let json: [String: Any] = ["success": success, "result": details]
        let data = try! JSONSerialization.data(withJSONObject: json)
        return try! JSONDecoder().decode(TeamDetailResponse.self, from: data)
    }
    
    static func makeTennisPlayerDetailResponse(success: Int = 1, details: [[String: Any]]) -> TennisPlayerDetailResponse {
        let json: [String: Any] = ["success": success, "result": details]
        let data = try! JSONSerialization.data(withJSONObject: json)
        return try! JSONDecoder().decode(TennisPlayerDetailResponse.self, from: data)
    }
}
