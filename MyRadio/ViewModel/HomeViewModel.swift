//
//  HomeViewModel.swift
//  MyRadio
//
//  Created by xiaoerlong on 2024/1/21.
//

import Foundation
import Moya

class HomeViewModel: ObservableObject {
    
    // 请求状态
    var isRequesting = false
    
    private let provider = MoyaProvider<XMNetworkType>()
    var categoryVM = CategoryViewModel()
    
    func request() {
        categoryVM.getCategoryList()
    }
}
