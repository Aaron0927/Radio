//
//  RadioCategory.swift
//  MyRadio
//
//  Created by Aaron on 2023/10/12.
//

import Foundation

struct RadioCategory: Codable, Identifiable {
    var id: Int // 广播分类ID
    var kind: String // 固定值"radio_category"
    var radio_category_name: String // 广播分类名称
    var order_num: Int // 排序值，值越小排序越在前
}
