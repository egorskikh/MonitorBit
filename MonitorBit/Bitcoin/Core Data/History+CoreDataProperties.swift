//
//  History+CoreDataProperties.swift
//  MonitorBit
//
//  Created by Egor Gorskikh on 26.05.2021.
//
//

import Foundation
import CoreData


extension History {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<History> {
        return NSFetchRequest<History>(entityName: "History")
    }

    @NSManaged public var date: String?
    @NSManaged public var eur: String?
    @NSManaged public var rub: String?
    @NSManaged public var upd: String?
    @NSManaged public var btc: BTC?

}

extension History : Identifiable {

}
