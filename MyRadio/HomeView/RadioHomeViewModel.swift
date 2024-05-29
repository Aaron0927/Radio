//
//  RadioHomeViewModel.swift
//  MyRadio
//
//  Created by xiaoerlong on 2024/3/7.
//

import Foundation

class RadioHomeViewModel: ObservableObject {
    @Published var categories: [RadioCategory] = []
    
    func refreshData() {
        getCategoryList()
    }
    
    // 请求分类列表
    private func getCategoryList() {
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
