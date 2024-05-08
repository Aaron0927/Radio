//
//  Radio.swift
//  MyRadio
//
//  Created by xiaoerlong on 2023/10/15.
//

import Foundation
import CoreData

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

final class RadioListData: ObservableObject {
    @Published var radios: [Radio] = []
    private let moc = DataController.shared.container.viewContext
    
    // 请求分类下的广播电台列表
    func getRadiosList(in category_id: Int) {
        XMNetwork.shared.provider.request(.get_radios_by_category(id: category_id)) { result in
            switch result {
            case let .success(res):
                do {
                    let model = try JSONDecoder().decode(RadioModel.self, from: res.data)
                    self.radios = model.radios
                    // 保存数据库中
                    for radio in model.radios {
                        let radioDB = self.getRadioDB(radio_id: Int64(radio.id))
                        radioDB?.schedule_id = Int64(radio.schedule_id)
                        radioDB?.radio_name = radio.radio_name
                    }
                    do {
                        try self.moc.save()
                    } catch {
                        self.moc.rollback()
                    }
                } catch {
                    print(error)
                }
            case let .failure(err):
                print(err)
            }
        }
    }
    
    // 保存数据到数据库中
    // 获取数据库对象
    private func getRadioDB(radio_id: Int64) -> RadioDB? {
        let request = NSFetchRequest<RadioDB>(entityName: "RadioDB")
        request.predicate = NSPredicate(format: "radio_id == %ld", radio_id)
        let result = try? moc.fetch(request)
        if result?.count == 0 {
            guard let radioDB = NSEntityDescription.insertNewObject(forEntityName: "RadioDB", into: moc) as? RadioDB else {
                return nil
            }
            radioDB.radio_id = radio_id
            return radioDB
        } else {
            return result?.first
        }
    }
}



func previewRadio() -> Radio {
    var model = Radio(id: 1, radio_name: "广东广播电视台文体广播", radio_desc: "", program_name: "新闻进行时", schedule_id: 1, support_bitrates: [], rate24_aac_url: "http://live.xmcdn.com/live/967/24.m3u8", rate64_aac_url: "http://live.xmcdn.com/live/967/24.m3u8", rate24_ts_url: "http://live.xmcdn.com/live/967/24.m3u8", rate64_ts_url: "http://live.xmcdn.com/live/967/24.m3u8", updated_at: 0, radio_play_count: 10, cover_url_small: "http://imagev2.xmcdn.com/group73/M00/A2/B8/wKgO0V6DEKDw15waAAAxpAd2B2A240.png!op_type=3&columns=640&rows=640", cover_url_large: "http://imagev2.xmcdn.com/group73/M00/A2/B8/wKgO0V6DEKDw15waAAAxpAd2B2A240.png!op_type=3&columns=640&rows=640")
    return model
}

func previewRadios() -> [Radio] {
    var tmp = [Radio]()
    for i in 0..<10 {
        var model = Radio(id: 1, radio_name: "广东广播电视台文体广播", radio_desc: "", program_name: "新闻进行时", schedule_id: 1, support_bitrates: [], rate24_aac_url: "http://live.xmcdn.com/live/967/24.m3u8", rate64_aac_url: "http://live.xmcdn.com/live/967/24.m3u8", rate24_ts_url: "http://live.xmcdn.com/live/967/24.m3u8", rate64_ts_url: "http://live.xmcdn.com/live/967/24.m3u8", updated_at: 0, radio_play_count: 10, cover_url_small: "http://imagev2.xmcdn.com/group73/M00/A2/B8/wKgO0V6DEKDw15waAAAxpAd2B2A240.png!op_type=3&columns=640&rows=640", cover_url_large: "http://imagev2.xmcdn.com/group73/M00/A2/B8/wKgO0V6DEKDw15waAAAxpAd2B2A240.png!op_type=3&columns=640&rows=640")
        tmp.append(model)
    }
    return tmp
}
