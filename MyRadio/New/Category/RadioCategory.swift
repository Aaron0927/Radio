//
//  RadioCategory.swift
//  MyRadio
//
//  Created by xiaoerlong on 2023/10/12.
//

import Foundation

struct RadioCategory: Codable, Identifiable {
    var id: Int // 广播分类ID
    var kind: String // 固定值"radio_category"
    var radio_category_name: String // 广播分类名称
    var order_num: Int // 排序值，值越小排序越在前
}

final class RadioCategoryData: ObservableObject {
    @Published var categories: [RadioCategory] = []
    
    func getCategoryList() {
        XMNetwork.shared.provider.request(.radio_categories) { result in
            switch result {
            case let .success(res):
                do {
                    let arr = try JSONDecoder().decode([RadioCategory].self, from: res.data)
                    self.categories = arr
                } catch {
                    print(error)
                }
            case let .failure(err):
                print(err)
            }
        }
    }
}



func previewCategory() -> RadioCategory {
    return RadioCategory(id: 1, kind: "category", radio_category_name: "分类名称\(1)", order_num: 20)
}

 func previewCategories() -> [RadioCategory] {
    var tmp = [RadioCategory]()
    for i in 0..<10 {
        let category = RadioCategory(id: i, kind: "category", radio_category_name: "分类名称\(i)", order_num: 20)
        tmp.append(category)
    }
    return tmp
}
