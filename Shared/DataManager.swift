//DataManager Class. 코어데이터 setUp과 save를 담당

import Foundation
import CoreData


class DataManager {
    static let shared = DataManager()
    
    private init() {}
    
    var container: NSPersistentContainer?
    
    var mainContext: NSManagedObjectContext {
        guard let context = container?.viewContext else {
            return NSManagedObjectContext.init(concurrencyType: .mainQueueConcurrencyType)
        }
        return context
    }
    
    func setUp(modelName: String) {
        container = NSPersistentContainer(name: modelName)
        container?.loadPersistentStores(completionHandler: { desc, error in
            if let error = error {
                print(error.localizedDescription)
            }
        })
    }
    
    func saveContent() {
        mainContext.perform {
            if self.mainContext.hasChanges {
                do {
                    try self.mainContext.save()
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
}
