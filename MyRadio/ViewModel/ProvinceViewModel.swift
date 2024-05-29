//
//  ProvinceViewModel.swift
//  MyRadio
//
//  Created by xiaoerlong on 2024/1/4.
//

import Foundation

class ProvinceViewModel: ObservableObject {
    @Published var provinces: [Province] = [Province]()
    
    func requestProvinces() {
        XMNetwork.shared.provider.request(.provinces) { result in
            switch result {
            case .success(let res):
                do {
                    let arr = try JSONDecoder().decode([Province].self, from: res.data)
                    self.provinces = arr
                } catch {
                    print(error)
                }
            case .failure(let err):
                print(err)
            }
        }
    }
}
