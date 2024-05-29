//
//  RadioDB.swift
//  MyRadio
//
//  Created by Aaron on 2024/5/3.
//

import CoreData
import Foundation

@objc(RadioDB)
class RadioDB: NSManagedObject {
    @NSManaged var radio_id: Int16
    @NSManaged var radio_urlPath: String
    @NSManaged var radio_cover: String
    @NSManaged var program_name: String
    @NSManaged var favorite: Bool // 收藏
    @NSManaged var create_at: Date
    @NSManaged var update_at: Date
    @NSManaged var radio_name: String?
}
