import CoreData

extension DataManager {

    func createDailyInfo(date: String, mood: String, good: String, bad: String, thanks: String, highlight: String, month: Int16, year: Int16, completion: (() -> ())? = nil) {
        mainContext.perform {
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
    
    func fetchTask(_ month: Int16, _ year: Int16) -> [DailyInfoEntity] {
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
                
            }
        }
        
        return list
    }
    
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
        }
    }
    
    func deleteTask(entity: DailyInfoEntity, completion: (()->())? = nil) {
        mainContext.perform {
            self.mainContext.delete(entity)
            self.saveContent()
            completion?()
        }
    }
}
