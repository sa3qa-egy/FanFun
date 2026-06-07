import UIKit
import CoreData

class CoreDataManager {
    
    static let shared = CoreDataManager()
    
    private init() {}
    
    var context: NSManagedObjectContext {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("CoreDataManager: Could not get AppDelegate. Ensure the app is fully launched before accessing Core Data.")
        }
        return appDelegate.persistentContainer.viewContext
    }
}
