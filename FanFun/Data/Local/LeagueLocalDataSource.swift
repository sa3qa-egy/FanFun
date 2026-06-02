import CoreData

class LeagueLocalDataSource {
    
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext = CoreDataManager.shared.context) {
        self.context = context
    }
    
    func saveLeagues(_ leagues: [League], for sport: String) {
        deleteLeagues(for: sport)
        
        for league in leagues {
            let entity = LeagueEntity(context: context)
            entity.leagueKey   = NSNumber(value: league.leagueKey)
            entity.leagueName  = league.leagueName
            entity.countryKey  = NSNumber(value: league.countryKey ?? 0)
            entity.countryName = league.countryName
            entity.leagueLogo  = league.leagueLogo
            entity.countryLogo = league.countryLogo
            entity.leagueYear  = league.leagueYear
            entity.sportType   = sport.lowercased()
        }
        
        saveContext()
    }
    
    func fetchLeagues(for sport: String) -> [League] {
        let request: NSFetchRequest<LeagueEntity> = LeagueEntity.fetchRequest()
        request.predicate = NSPredicate(format: "sportType == %@", sport.lowercased())
        request.sortDescriptors = [NSSortDescriptor(key: "leagueName", ascending: true)]
        
        do {
            let entities = try context.fetch(request)
            return entities.map { entity in
                let leagueKey  = entity.leagueKey?.intValue ?? 0
                let countryKey = entity.countryKey?.intValue ?? 0
                return League(
                    leagueKey:   leagueKey,
                    leagueName:  entity.leagueName ?? "",
                    countryKey:  countryKey != 0 ? countryKey : nil,
                    countryName: entity.countryName,
                    leagueLogo:  entity.leagueLogo,
                    countryLogo: entity.countryLogo,
                    leagueYear:  entity.leagueYear
                )
            }
        } catch {
            print("⚠️ CoreData fetch failed: \(error.localizedDescription)")
            return []
        }
    }
    
    private func deleteLeagues(for sport: String) {
        let request: NSFetchRequest<LeagueEntity> = LeagueEntity.fetchRequest()
        request.predicate = NSPredicate(format: "sportType == %@", sport.lowercased())
        
        do {
            let entities = try context.fetch(request)
            entities.forEach { context.delete($0) }
        } catch {
            print("⚠️ CoreData delete fetch failed: \(error.localizedDescription)")
        }
    }
    
    private func saveContext() {
        guard context.hasChanges else { return }
        do {
            try context.save()
        } catch {
            print("⚠️ CoreData save failed: \(error.localizedDescription)")
        }
    }
}
