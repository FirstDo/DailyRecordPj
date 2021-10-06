//
//  DataManager+DailyInfo.swift
//  DailyRecordProject
//
//  Created by 김도연 on 2021/10/05.
//

import Foundation
import CoreData

extension DataManager {
    //entity를 create하는 함수
    func createDailyInfo(date: String, mood: String, good: String, bad: String, thanks: String, highlight: String, month: Int16, year: Int16, completion: (() -> ())? = nil) {
        mainContext.perform {
            print("CREATE")
            let newTask = DailyInfoEntity(context: self.mainContext)
            newTask.date = date
            newTask.mood = mood
            newTask.good = good
            newTask.bad = bad
            newTask.thanks = thanks
            newTask.highlight = highlight
            newTask.month = month
            newTask.year = year
            
            self.saveContent()
            completion?()
        }
    }
    
    //특정 month의 기록들을 fetch하는 함수
    func fetchTask(_ month: Int16, _ year: Int16) -> [DailyInfoEntity] {
        print("FETCH")
        var list = [DailyInfoEntity]()
        
        mainContext.performAndWait {
            let request: NSFetchRequest<DailyInfoEntity> = DailyInfoEntity.fetchRequest()
            
            let sortByDate = NSSortDescriptor(key: #keyPath(DailyInfoEntity.date), ascending: false)
            
            let monthPredicate = NSPredicate(format: "%K == %d", #keyPath(DailyInfoEntity.month), month)
            let yearPredicate = NSPredicate(format: "%K == %d", #keyPath(DailyInfoEntity.year), year)

            let combinePredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [yearPredicate, monthPredicate])
            
            request.sortDescriptors = [sortByDate]
            request.predicate = combinePredicate
            
            do {
                list = try mainContext.fetch(request)
            } catch {
                print(error.localizedDescription)
            }
        }
        return list
    }
    
    //인자로 전달된 entity를 update하는 함수
    func updateTask(entity: DailyInfoEntity, date: String, mood: String, good: String, bad: String, thanks: String, highlight: String, month: Int16, year: Int16,completion: (()->())? = nil) {
        mainContext.perform {
            
            entity.date = date
            entity.mood = mood
            entity.good = good
            entity.bad = bad
            entity.thanks = thanks
            entity.highlight = highlight
            entity.month = month
            entity.year = year
            
            self.saveContent()
            completion?()
            print("UPDATE")
        }
    }
    
    //entity를 삭제하는 함수
    func deleteTask(entity: DailyInfoEntity, completion: (()->())? = nil) {
        mainContext.perform {
            print("DELETE")
            self.mainContext.delete(entity)
            self.saveContent()
            completion?()
        }
    }
    
}
