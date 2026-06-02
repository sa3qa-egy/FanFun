import Foundation
import CoreData

extension LeagueEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<LeagueEntity> {
        return NSFetchRequest<LeagueEntity>(entityName: "LeagueEntity")
    }

    @NSManaged public var leagueKey: NSNumber?
    @NSManaged public var leagueName: String?
    @NSManaged public var countryKey: NSNumber?
    @NSManaged public var countryName: String?
    @NSManaged public var leagueLogo: String?
    @NSManaged public var countryLogo: String?
    @NSManaged public var leagueYear: String?
    @NSManaged public var sportType: String?
}
