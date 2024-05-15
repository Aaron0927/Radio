//
//  Radio.swift
//  MyRadio
//
//  Created by xiaoerlong on 2023/10/15.
//

import Foundation

struct RadioModel: Codable {
    var total_page: Int
    var total_count: Int
    var current_page: Int
    var radios: [Radio]
}

// 电台模型
struct Radio: Codable, Identifiable {
    var id: Int
    var kind: String = "radio"
    var radio_name: String // 电台名称
    var radio_desc: String // 电台简介
    var program_name: String // 正在直播的节目名称
    var schedule_id: Int // 正在直播的节目时间表ID
    var support_bitrates: [Int] // 支持的码率列
    var rate24_aac_url: String
    var rate64_aac_url: String
    var rate24_ts_url: String
    var rate64_ts_url: String
    var updated_at: Int // 更新时间
    var radio_play_count: Int // 电台累计收听次数
    var cover_url_small: String // 电台封面小图
    var cover_url_large: String // 电台封面大图
    
    var program: Program {
        var program = Program(id: id, program_name: program_name, back_pic_url: "", support_bitrates: support_bitrates, rate24_aac_url: rate24_aac_url, rate64_aac_url: rate64_aac_url, rate24_ts_url: rate24_ts_url, rate64_ts_url: rate64_ts_url, updated_at: updated_at)
        return program
    }
}
