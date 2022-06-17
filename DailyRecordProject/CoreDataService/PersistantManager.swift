//
//  PersistantManager.swift
//  DailyRecordProject
//
//  Created by dudu on 2021/09/28.
//

import CoreData

final class PersistantManager {
    static let shared = PersistantManager()
    private init() {}
    
    private var persistentContainer: NSPersistentContainer?
    
    private var mainContext: NSManagedObjectContext {
        guard let context = persistentContainer?.viewContext else {
            return NSManagedObjectContext.init(concurrencyType: .mainQueueConcurrencyType)
        }
        
        return context
    }
    
    func setUp(modelName: String) {
        persistentContainer = NSPersistentContainer(name: modelName)
        
        persistentContainer?.loadPersistentStores { _, error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    func saveContent() {
        guard mainContext.hasChanges else { return }
        
        do {
            try self.mainContext.save()
        } catch {
            print(error.localizedDescription)
        }
    }
}

extension PersistantManager {
    
    func create(userRecord: DailyRecord, completion: (() -> Void)? = nil) {
        let newEntity = DailyRecordEntity(context: mainContext)
        newEntity.goodWork = userRecord.goodWork
        newEntity.badWork = userRecord.badWork
        newEntity.thanksWork = userRecord.thanksWork
        newEntity.highlight = userRecord.highlight
        newEntity.mood = Int64(userRecord.mood?.rawValue ?? 0)
        
        saveContent()
        completion?()
    }
    
    func fetchAll(for date: Date) -> [DailyRecord]? {
        let request = DailyRecordEntity.fetchRequest()
        let sortByDate = NSSortDescriptor(key: #keyPath(DailyRecordEntity.createdDate), ascending: true)
        let predicate = NSPredicate(format: "createdDate >= %@", date as NSDate)
        
        //        let monthPredicate = NSPredicate(format: "%K == %d", #keyPath(DailyRecordEntity.createdDate.year), date.year)
        //        let yearPredicate = NSPredicate(format: "%K == %d", #keyPath(DailyRecordEntity.createdDate), year)
        //        let combinePredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [yearPredicate, monthPredicate])
        //        request.predicate = combinePredicate
        
        request.sortDescriptors = [sortByDate]
        request.predicate = predicate
        
        return try? mainContext.fetch(request).map { entity in
            DailyRecord(
                mood: Mood(rawValue: Int(entity.mood)),
                goodWork: entity.goodWork,
                badWork: entity.badWork,
                thanksWork: entity.thanksWork,
                highlight: entity.highlight,
                createdDate: entity.createdDate
            )
        }
    }
    
    func fetch(date: Date) -> DailyRecordEntity? {
        let request = DailyRecordEntity.fetchRequest()
        let predicate = NSPredicate(format: "createdDate == %@", date as NSDate)
        request.predicate = predicate
        
        return try? mainContext.fetch(request).first
    }
    
    func update(with userRecord: DailyRecord, completion: (() -> Void)? = nil) {
        guard let idDate = userRecord.createdDate else { return }
        guard let entity = fetch(date: idDate) else { return }
        
        entity.mood = Int64(userRecord.mood?.rawValue ?? 0)
        entity.goodWork = userRecord.goodWork
        entity.badWork = userRecord.badWork
        entity.thanksWork = userRecord.thanksWork
        entity.highlight = userRecord.highlight
        
        saveContent()
        completion?()
    }
    
    func delete(target userRecord: DailyRecord, completion: (() -> Void)? = nil) {
        guard let idDate = userRecord.createdDate else { return }
        guard let entity = fetch(date: idDate) else { return }
        
        mainContext.delete(entity)
        saveContent()
        completion?()
    }
}
