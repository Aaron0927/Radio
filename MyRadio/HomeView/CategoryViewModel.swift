//
//  CategoryViewModel.swift
//  MyRadio
//
//  Created by xiaoerlong on 2023/10/16.
//

import Foundation

class CategoryViewModel: ObservableObject {
    @Published var categories: [RadioCategory] = []
    @Published var radios: [Radio] = [Radio]()
    
    
    // 请求分类列表
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
    
    // 请求分类下的广播电台列表
    func getRadiosList(in category_id: Int) {
        XMNetwork.shared.provider.request(.get_radios_by_category(id: category_id)) { result in
            switch result {
            case let .success(res):
                do {
                    let model = try JSONDecoder().decode(RadioModel.self, from: res.data)
                    self.radios = model.radios
                } catch {
                    print(error)
                }
            case let .failure(err):
                print(err)
            }
        }
    }
}
