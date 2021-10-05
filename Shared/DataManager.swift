//
//  DataManager.swift
//  DailyRecordProject
//
//  Created by 김도연 on 2021/10/05.
//

import Foundation
import CoreData

class DataManager {
    static let shared = DataManager()
    
    private init() {}
    
    var container: NSPersistentContainer?
    
    var mainContext: NSManagedObjectContext {
        guard let context = container?.viewContext else {
            print("CoreDataError")
            return NSManagedObjectContext()
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
                    print("save Error")
                }
            }
        }
    }
}
