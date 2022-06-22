//
//  PersistantManager.swift
//  DailyRecordProject
//
//  Created by dudu on 2021/09/28.
//

import CoreData

final class PersistantManager {
    
    init(modelName: String) {
        persistentContainer = NSPersistentContainer(name: modelName)
        persistentContainer.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
    }
    
    private let persistentContainer: NSPersistentContainer
    
    private var mainContext: NSManagedObjectContext {
        return persistentContainer.viewContext
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
        newEntity.createdDate = userRecord.createdDate
        
        saveContent()
        completion?()
    }
    
    func fetchAll(target date: Date) -> [DailyRecord]? {
        var dateComponent = DateComponents(calendar: .current, year: date.year, month: date.month, day: 1)
        let firstDayOfMonth = dateComponent.date!
        
        if date.month == 12 {
            dateComponent.year = date.year + 1
            dateComponent.month = date.month
        } else {
            dateComponent.month = date.month + 1
        }
        
        let firstDayOfNextMonth = dateComponent.date!
        
        let request = DailyRecordEntity.fetchRequest()
        let sortByDate = NSSortDescriptor(key: #keyPath(DailyRecordEntity.createdDate), ascending: true)
        let predicate = NSPredicate(
            format: "createdDate >= %@ AND createdDate < %@", firstDayOfMonth as CVarArg, firstDayOfNextMonth as CVarArg
        )
        
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
    
    private func fetch(date: Date) -> DailyRecordEntity? {
        let request = DailyRecordEntity.fetchRequest()
        
        let predicate = NSPredicate(format: "createdDate == %@", date as CVarArg)
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
    
    func deleteAll() {
        let request = DailyRecordEntity.fetchRequest()
        let results = try? mainContext.fetch(request)
        
        results?.forEach { entity in
            mainContext.delete(entity)
        }
        
        saveContent()
    }
}
