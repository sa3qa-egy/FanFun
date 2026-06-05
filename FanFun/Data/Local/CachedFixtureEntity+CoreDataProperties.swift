import Foundation
import CoreData

extension CachedFixtureEntity {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<CachedFixtureEntity> {
        return NSFetchRequest<CachedFixtureEntity>(entityName: "CachedFixtureEntity")
    }

    @NSManaged public var eventKey: NSNumber?
    @NSManaged public var eventDate: String?
    @NSManaged public var eventTime: String?
    @NSManaged public var eventHomeTeam: String?
    @NSManaged public var homeTeamKey: NSNumber?
    @NSManaged public var eventAwayTeam: String?
    @NSManaged public var awayTeamKey: NSNumber?
    @NSManaged public var eventFinalResult: String?
    @NSManaged public var eventStatus: String?
    @NSManaged public var homeTeamLogo: String?
    @NSManaged public var awayTeamLogo: String?
    @NSManaged public var leagueKey: NSNumber?
    @NSManaged public var sportType: String?
    @NSManaged public var isUpcoming: Bool
}
