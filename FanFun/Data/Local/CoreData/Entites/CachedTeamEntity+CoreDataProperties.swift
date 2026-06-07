import Foundation
import CoreData

extension CachedTeamEntity {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<CachedTeamEntity> {
        return NSFetchRequest<CachedTeamEntity>(entityName: "CachedTeamEntity")
    }

    @NSManaged public var teamKey: NSNumber?
    @NSManaged public var teamName: String?
    @NSManaged public var teamLogo: String?
    @NSManaged public var leagueKey: NSNumber?
    @NSManaged public var sportType: String?
}
