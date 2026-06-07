import CoreData

class FavoriteLocalDataSource {
    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext = CoreDataManager.shared.context) {
        self.context = context
    }

    func addFavorite(league: League, sportType: String) {
        guard !isFavorite(leagueKey: league.leagueKey, sportType: sportType) else { return }
        let entity = FavoriteLeagueEntity(context: context)
        entity.leagueKey = NSNumber(value: league.leagueKey)
        entity.leagueName = league.leagueName
        entity.countryKey = NSNumber(value: league.countryKey ?? 0)
        entity.countryName = league.countryName
        entity.leagueLogo = league.leagueLogo
        entity.countryLogo = league.countryLogo
        entity.leagueYear = league.leagueYear
        entity.sportType = sportType.lowercased()
        saveContext()
    }

    func removeFavorite(leagueKey: Int, sportType: String) {
        let request: NSFetchRequest<FavoriteLeagueEntity> = FavoriteLeagueEntity.fetchRequest()
        request.predicate = NSPredicate(format: "leagueKey == %lld AND sportType == %@", Int64(leagueKey), sportType.lowercased())
        do {
            let entities = try context.fetch(request)
            entities.forEach { context.delete($0) }
        } catch {}
        deleteCachedFixtures(leagueKey: leagueKey, sportType: sportType)
        deleteCachedTeams(leagueKey: leagueKey, sportType: sportType)
        saveContext()
    }

    func isFavorite(leagueKey: Int, sportType: String) -> Bool {
        let request: NSFetchRequest<FavoriteLeagueEntity> = FavoriteLeagueEntity.fetchRequest()
        request.predicate = NSPredicate(format: "leagueKey == %lld AND sportType == %@", Int64(leagueKey), sportType.lowercased())
        request.fetchLimit = 1
        do {
            let count = try context.count(for: request)
            return count > 0
        } catch {
            return false
        }
    }

    func fetchFavorites(for sportType: String) -> [League] {
        let request: NSFetchRequest<FavoriteLeagueEntity> = FavoriteLeagueEntity.fetchRequest()
        request.predicate = NSPredicate(format: "sportType == %@", sportType.lowercased())
        request.sortDescriptors = [NSSortDescriptor(key: "leagueName", ascending: true)]
        do {
            let entities = try context.fetch(request)
            return entities.map { mapToLeague($0) }
        } catch {
            return []
        }
    }

    func fetchAllFavorites() -> [String: [League]] {
        let request: NSFetchRequest<FavoriteLeagueEntity> = FavoriteLeagueEntity.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "leagueName", ascending: true)]
        do {
            let entities = try context.fetch(request)
            var grouped: [String: [League]] = [:]
            for entity in entities {
                let sport = entity.sportType ?? "unknown"
                let league = mapToLeague(entity)
                grouped[sport, default: []].append(league)
            }
            return grouped
        } catch {
            return [:]
        }
    }

    func cacheFixtures(_ fixtures: [Fixture], leagueKey: Int, sportType: String, isUpcoming: Bool) {
        deleteCachedFixtures(leagueKey: leagueKey, sportType: sportType, isUpcoming: isUpcoming)
        for fixture in fixtures {
            let entity = CachedFixtureEntity(context: context)
            entity.eventKey = NSNumber(value: fixture.eventKey)
            entity.eventDate = fixture.eventDate
            entity.eventTime = fixture.eventTime
            entity.eventHomeTeam = fixture.eventHomeTeam
            entity.homeTeamKey = NSNumber(value: fixture.homeTeamKey)
            entity.eventAwayTeam = fixture.eventAwayTeam
            entity.awayTeamKey = NSNumber(value: fixture.awayTeamKey)
            entity.eventFinalResult = fixture.eventFinalResult
            entity.eventStatus = fixture.eventStatus
            entity.homeTeamLogo = fixture.homeTeamLogo
            entity.awayTeamLogo = fixture.awayTeamLogo
            entity.leagueKey = NSNumber(value: leagueKey)
            entity.sportType = sportType.lowercased()
            entity.isUpcoming = isUpcoming
        }
        saveContext()
    }

    func cacheTeams(_ teams: [Team], leagueKey: Int, sportType: String) {
        deleteCachedTeams(leagueKey: leagueKey, sportType: sportType)
        for team in teams {
            let entity = CachedTeamEntity(context: context)
            entity.teamKey = NSNumber(value: team.teamKey)
            entity.teamName = team.teamName
            entity.teamLogo = team.teamLogo
            entity.leagueKey = NSNumber(value: leagueKey)
            entity.sportType = sportType.lowercased()
        }
        saveContext()
    }

    func fetchCachedUpcomingFixtures(leagueKey: Int, sportType: String) -> [Fixture] {
        return fetchCachedFixtures(leagueKey: leagueKey, sportType: sportType, isUpcoming: true)
    }

    func fetchCachedPreviousFixtures(leagueKey: Int, sportType: String) -> [Fixture] {
        return fetchCachedFixtures(leagueKey: leagueKey, sportType: sportType, isUpcoming: false)
    }

    func fetchCachedTeams(leagueKey: Int, sportType: String) -> [Team] {
        let request: NSFetchRequest<CachedTeamEntity> = CachedTeamEntity.fetchRequest()
        request.predicate = NSPredicate(format: "leagueKey == %lld AND sportType == %@", Int64(leagueKey), sportType.lowercased())
        request.sortDescriptors = [NSSortDescriptor(key: "teamName", ascending: true)]
        do {
            let entities = try context.fetch(request)
            return entities.map { entity in
                Team(
                    teamKey: entity.teamKey?.intValue ?? 0,
                    teamName: entity.teamName ?? "",
                    teamLogo: entity.teamLogo
                )
            }
        } catch {
            return []
        }
    }

    private func fetchCachedFixtures(leagueKey: Int, sportType: String, isUpcoming: Bool) -> [Fixture] {
        let request: NSFetchRequest<CachedFixtureEntity> = CachedFixtureEntity.fetchRequest()
        request.predicate = NSPredicate(format: "leagueKey == %lld AND sportType == %@ AND isUpcoming == %@", Int64(leagueKey), sportType.lowercased(), NSNumber(value: isUpcoming))
        request.sortDescriptors = [NSSortDescriptor(key: "eventDate", ascending: !isUpcoming)]
        do {
            let entities = try context.fetch(request)
            return entities.map { mapToFixture($0) }
        } catch {
            return []
        }
    }

    private func deleteCachedFixtures(leagueKey: Int, sportType: String, isUpcoming: Bool? = nil) {
        let request: NSFetchRequest<CachedFixtureEntity> = CachedFixtureEntity.fetchRequest()
        if let isUpcoming = isUpcoming {
            request.predicate = NSPredicate(format: "leagueKey == %lld AND sportType == %@ AND isUpcoming == %@", Int64(leagueKey), sportType.lowercased(), NSNumber(value: isUpcoming))
        } else {
            request.predicate = NSPredicate(format: "leagueKey == %lld AND sportType == %@", Int64(leagueKey), sportType.lowercased())
        }
        do {
            let entities = try context.fetch(request)
            entities.forEach { context.delete($0) }
        } catch {}
    }

    private func deleteCachedTeams(leagueKey: Int, sportType: String) {
        let request: NSFetchRequest<CachedTeamEntity> = CachedTeamEntity.fetchRequest()
        request.predicate = NSPredicate(format: "leagueKey == %lld AND sportType == %@", Int64(leagueKey), sportType.lowercased())
        do {
            let entities = try context.fetch(request)
            entities.forEach { context.delete($0) }
        } catch {}
    }

    private func mapToLeague(_ entity: FavoriteLeagueEntity) -> League {
        let leagueKey = entity.leagueKey?.intValue ?? 0
        let countryKey = entity.countryKey?.intValue ?? 0
        return League(
            leagueKey: leagueKey,
            leagueName: entity.leagueName ?? "",
            countryKey: countryKey != 0 ? countryKey : nil,
            countryName: entity.countryName,
            leagueLogo: entity.leagueLogo,
            countryLogo: entity.countryLogo,
            leagueYear: entity.leagueYear
        )
    }

    private func mapToFixture(_ entity: CachedFixtureEntity) -> Fixture {
        return Fixture(
            eventKey: entity.eventKey?.intValue ?? 0,
            eventDate: entity.eventDate ?? "",
            eventTime: entity.eventTime ?? "",
            eventHomeTeam: entity.eventHomeTeam ?? "",
            homeTeamKey: entity.homeTeamKey?.intValue ?? 0,
            eventAwayTeam: entity.eventAwayTeam ?? "",
            awayTeamKey: entity.awayTeamKey?.intValue ?? 0,
            eventFinalResult: entity.eventFinalResult,
            eventStatus: entity.eventStatus,
            homeTeamLogo: entity.homeTeamLogo,
            awayTeamLogo: entity.awayTeamLogo
        )
    }

    private func saveContext() {
        guard context.hasChanges else { return }
        do {
            try context.save()
        } catch {}
    }
}
