//
//  DailyInfoEntity+CoreDataProperties.swift
//  DailyRecordProject
//
//  Created by 김도연 on 2022/06/17.
//
//

import Foundation
import CoreData


extension DailyInfoEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DailyInfoEntity> {
        return NSFetchRequest<DailyInfoEntity>(entityName: "DailyInfo")
    }

    @NSManaged public var bad: String?
    @NSManaged public var date: String?
    @NSManaged public var good: String?
    @NSManaged public var highlight: String?
    @NSManaged public var month: Int16
    @NSManaged public var mood: String?
    @NSManaged public var thanks: String?
    @NSManaged public var year: Int16

}

extension DailyInfoEntity : Identifiable {

}
