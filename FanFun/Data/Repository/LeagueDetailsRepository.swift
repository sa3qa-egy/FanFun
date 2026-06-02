//
//  LeagueDetailsRepository.swift
//  FanFun
//

import Foundation

protocol LeagueDetailsRepositoryProtocol {
    func getUpcomingFixtures(for sport: String, leagueId: Int, completion: @escaping (Result<[Fixture], Error>) -> Void)
    func getPreviousFixtures(for sport: String, leagueId: Int, completion: @escaping (Result<[Fixture], Error>) -> Void)
    func getTeams(for sport: String, leagueId: Int, completion: @escaping (Result<[Team], Error>) -> Void)
}

class LeagueDetailsRepository: LeagueDetailsRepositoryProtocol {
    
    private let networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol = NetworkService()) {
        self.networkService = networkService
    }
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }
    
    func getUpcomingFixtures(for sport: String, leagueId: Int, completion: @escaping (Result<[Fixture], Error>) -> Void) {
        let today = Date()
        let oneYearLater = Calendar.current.date(byAdding: .year, value: 1, to: today) ?? today
        
        let fromDate = dateFormatter.string(from: today)
        let toDate = dateFormatter.string(from: oneYearLater)
        
        networkService.fetchFixtures(for: sport, leagueId: leagueId, from: fromDate, to: toDate) { result in
            switch result {
            case .success(let fixtures):
                let upcoming = fixtures.filter { fixture in
                    let status = (fixture.eventStatus ?? "").trimmingCharacters(in: .whitespaces)
                    return status != "Finished" && status != "After Pen." && status != "After ET"
                }
                completion(.success(upcoming))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getPreviousFixtures(for sport: String, leagueId: Int, completion: @escaping (Result<[Fixture], Error>) -> Void) {
        let today = Date()
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: today) ?? today
        let oneYearAgo = Calendar.current.date(byAdding: .year, value: -1, to: today) ?? today
        
        let fromDate = dateFormatter.string(from: oneYearAgo)
        let toDate = dateFormatter.string(from: yesterday)
        
        networkService.fetchFixtures(for: sport, leagueId: leagueId, from: fromDate, to: toDate) { result in
            switch result {
            case .success(let fixtures):
                let finished = fixtures.filter { fixture in
                    let status = (fixture.eventStatus ?? "").trimmingCharacters(in: .whitespaces)
                    return status == "Finished" || status == "After Pen." || status == "After ET"
                }
                // Sort by date descending (most recent first)
                let sorted = finished.sorted { $0.eventDate > $1.eventDate }
                completion(.success(sorted))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getTeams(for sport: String, leagueId: Int, completion: @escaping (Result<[Team], Error>) -> Void) {
        networkService.fetchTeams(for: sport, leagueId: leagueId, completion: completion)
    }
}
