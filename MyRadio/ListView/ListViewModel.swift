//
//  ListViewModel.swift
//  MyRadio
//
//  Created by xiaoerlong on 2024/1/16.
//

import Foundation

class ListViewModel: ObservableObject {
    @Published var radios: [Radio] = [Radio]()
    @Published var headerRefreshing = false
    @Published var footerRefreshing = false
    @Published var noMore = false
    
    var title: String
    private var radio_type: Int = 1
    private var province_code: Int?
    private var category_id: Int = 0
    private var type: ListViewModel.ListType
    private var page: Int = 1
    
    enum ListType {
        case radios
        case category
    }
    
    
    init(title: String, radio_type: Int, province_code: Int? = nil) {
        self.title = title
        self.radio_type = radio_type
        self.province_code = province_code
        self.type = .radios
    }
    
    init(title: String, category_id: Int) {
        self.title = title
        self.category_id = category_id
        self.type = .category
    }
    
    func request(page: Int = 1, count: Int = 20) {
        headerRefreshing = true
        noMore = false
        if page > 1 {
            footerRefreshing = true
        }
        self.page = page
        switch type {
        case .radios:
            requestRadios(radio_type: radio_type, province_code: nil) {
                self.headerRefreshing = false
                self.footerRefreshing = false
            }
        case .category:
            requestRadios(by: category_id) {
                self.headerRefreshing = false
                self.footerRefreshing = false
            }
        }
        
    }
    
    // 获取广播省市列表
    func requestRadios(radio_type: Int, province_code: Int? = nil, page: Int = 1, count: Int = 20, end: @escaping () -> Void) {
        XMNetwork.shared.provider.request(.radios(radio_type: radio_type, page: page, count: count)) { result in
            switch result {
            case .success(let res):
                do {
                    let model = try JSONDecoder().decode(Radios.self, from: res.data)
                    if page > 1 {
                        self.radios.append(contentsOf: model.radios)
                    } else {
                        self.radios = model.radios
                    }
                    if self.radios.count < 20 {
                        self.noMore = true
                    }
                } catch {
                    print(error)
                }
            case .failure(let err):
                print(err)
                if page  > 1 {
                    self.page -= 1
                }
            }
            end()
        }
    }
    
    // 根据电台分类获取分类下的广播电台列表
    func requestRadios(by radio_category_id: Int, page: Int = 1, count: Int = 20, end: @escaping () -> Void) {
        XMNetwork.request(target: .get_radios_by_category(id: radio_category_id, page: page, count: count)) { result in
            switch result {
            case .success(let res):
                do {
                    let model = try JSONDecoder().decode(RadioModel.self, from: res.data)
                    self.radios = model.radios
                    if self.radios.count < 20 {
                        self.noMore = true
                    }
                } catch {
                    print(error)
                }
            case .failure(let err):
                print(err)
            }
            end()
        }
    }
}
