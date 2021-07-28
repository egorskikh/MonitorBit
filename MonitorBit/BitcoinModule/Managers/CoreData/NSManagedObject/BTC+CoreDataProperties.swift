//
//  BTC+CoreDataProperties.swift
//  MonitorBit
//
//  Created by Egor Gorskikh on 26.05.2021.
//
//

import Foundation
import CoreData


extension BTC {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BTC> {
        return NSFetchRequest<BTC>(entityName: "BTC")
    }

    @NSManaged public var user: String?
    @NSManaged public var history: NSOrderedSet?

}

// MARK: Generated accessors for history
extension BTC {

    @objc(insertObject:inHistoryAtIndex:)
    @NSManaged public func insertIntoHistory(_ value: History, at idx: Int)

    @objc(removeObjectFromHistoryAtIndex:)
    @NSManaged public func removeFromHistory(at idx: Int)

    @objc(insertHistory:atIndexes:)
    @NSManaged public func insertIntoHistory(_ values: [History], at indexes: NSIndexSet)

    @objc(removeHistoryAtIndexes:)
    @NSManaged public func removeFromHistory(at indexes: NSIndexSet)

    @objc(replaceObjectInHistoryAtIndex:withObject:)
    @NSManaged public func replaceHistory(at idx: Int, with value: History)

    @objc(replaceHistoryAtIndexes:withHistory:)
    @NSManaged public func replaceHistory(at indexes: NSIndexSet, with values: [History])

    @objc(addHistoryObject:)
    @NSManaged public func addToHistory(_ value: History)

    @objc(removeHistoryObject:)
    @NSManaged public func removeFromHistory(_ value: History)

    @objc(addHistory:)
    @NSManaged public func addToHistory(_ values: NSOrderedSet)

    @objc(removeHistory:)
    @NSManaged public func removeFromHistory(_ values: NSOrderedSet)

}

extension BTC : Identifiable {

}
