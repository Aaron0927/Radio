//
//  Province.swift
//  MyRadio
//
//  Created by Aaron on 2024/1/4.
//

import Foundation

// 省市模型
struct Province: Codable, Identifiable {
    var id: Int // 省市ID
    var kind: String // 固定值"province"
    var province_code: Int // 省市代码，比如110000
    var province_name: String // 省市名称
    var created_at: Int // 创建时间，Unix毫秒数时间戳
    
    enum CodingKeys: CodingKey {
        case id
        case kind
        case province_code
        case province_name
        case created_at
    }
    
    static func preview() -> [Province] {
        var arr = [Province]()
        for index in 0..<10 {
            arr.append(Province(id: index, kind: "province", province_code: 110000, province_name: "北京", created_at: 000))
        }
        return arr
    }
}

