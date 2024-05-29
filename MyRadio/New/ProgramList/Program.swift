//
//  Program.swift
//  MyRadio
//
//  Created by Aaron on 2024/4/11.
//

import Foundation

// 电台下面的节目模型
struct Program: Codable, Identifiable {
    var id: Int // 广播节目ID
    var kind: String = "program"
    var program_name: String // 节目名称
    var back_pic_url: String // 节目背景图URL
    var support_bitrates: [Int] // 支持的码率列表
    var rate24_aac_url: String
    var rate64_aac_url: String
    var rate24_ts_url: String
    var rate64_ts_url: String
    var updated_at: Int // 更新时间
}

// 节目排期模型
struct Schedule: Codable, Identifiable {
    var id: Int // 节目时间表ID
    var radio_id: Int // 所属广播ID
    var start_time: String // 节目开始时间
    var end_time: String // 节目结束时间
    var kind: String = "schedule"
    var updated_at: Int // 更新时间，Unix毫秒数时间戳
    var play_type: Int // 播放类型，0-广播
    var listen_back_url: String // 节目回听地址，无则返回空字符串""
    var can_listen_back: Bool // true表示支持回听，false表示没有回听
    var related_program: Program
}

final class ProgramData: ObservableObject {
    @Published var schedules: [Schedule] = []
    
    private(set) var schedule: Schedule? // 当前节目单
    private(set) var index: Int?
    
    // 是否有上一首
    var hasPrevious: Bool {
        guard var index = index else {
            return false
        }
        if index <= 0 {
            return false
        }
        index -= 1
        return schedules[index].can_listen_back
    }
    
    // 是否有下一首
    var hasNext: Bool {
        guard var index = index else {
            return false
        }
        if index >= schedules.count - 1 {
            return false
        }
        index += 1
        return schedules[index].can_listen_back
    }
    
    // 当前正在直播的节目
    func isPlaySchedule() -> Program? {
        guard let index = index else {
            return nil
        }
        return schedules[index].related_program
    }
    
    // 上一个节目
    func previousProgram() -> Program? {
        guard var index = index else {
            return nil
        }
        if !hasPrevious {
            return nil
        }
        index -= 1
        
        return schedules[index].related_program
    }
    
    // 下一个节目
    func nextProgram() -> Program? {
        guard var index = index else {
            return nil
        }
        if !hasPrevious {
            return nil
        }
        index += 1
        
        return schedules[index].related_program
    }
    
    // 请求电台下面的节目列表
    func getSchedules(radio_id: Int, weekday: Int = 0) {
        XMNetwork.shared.provider.request(.schedules(radio_id: radio_id, weekday: weekday)) { result in
              switch result {
              case let .success(res):
                  do {
                      let arr = try JSONDecoder().decode([Schedule].self, from: res.data)
                      self.schedules = arr
                  } catch {
                      print(error)
                  }
              case let .failure(err):
                  print(err)
              }
          }
    }
    
    
}
