//
//  Radios.swift
//  MyRadio
//
//  Created by Aaron on 2024/1/4.
//

import Foundation

// 广播电台列表
struct Radios: Codable {
    var total_page: Int // 总共多少页
    var total_count: Int // 专辑总数
    var current_page: Int // 当前页码
    var radios: [Radio] // 参考模型 Raido模型
    
    enum CodingKeys: CodingKey {
        case total_page
        case total_count
        case current_page
        case radios
    }
}
