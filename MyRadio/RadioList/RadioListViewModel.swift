//
//  RadioLIstViewModel.swift
//  MyRadio
//
//  Created by xiaoerlong on 2024/3/7.
//

import Foundation

class RadioListViewModel: ObservableObject {
    @Published var radios: [Radio] = [Radio]()
    
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
