//
//  RadioDB.swift
//  MyRadio
//
//  Created by Aaron on 2024/5/8.
//

import Foundation
import CoreData

@objc(RadioDB)
class RadioDB: NSManagedObject {
    @NSManaged var radio_id: Int64
    @NSManaged var schedule_id: Int64
    @NSManaged var radio_name: String
}
