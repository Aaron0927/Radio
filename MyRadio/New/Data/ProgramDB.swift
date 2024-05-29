//
//  ProgramDB.swift
//  MyRadio
//
//  Created by Aaron on 2024/5/7.
//

import Foundation
import CoreData

@objc(ProgramDB)
class ProgramDB: NSManagedObject {
    @NSManaged var radio_id: Int16
    @NSManaged var program_id: Int16
    @NSManaged var program_name: String
    @NSManaged var back_pic_url: String
    @NSManaged var rate_url: String
    @NSManaged var updated_at: Int64
    @NSManaged var created_at: Date
    @NSManaged var favorite: Bool
}
