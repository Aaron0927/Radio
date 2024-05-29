//
//  ProvinceView.swift
//  MyRadio
//
//  Created by xiaoerlong on 2024/1/4.
//

import SwiftUI

struct ProvinceView: View {
    @ObservedObject var viewModel = ProvinceViewModel()
    
    var body: some View {
        VStack {
            ForEach(viewModel.provinces, id: \.id) {
                Text($0.province_name)
            }
        }
        .onAppear {
            viewModel.requestProvinces()
        }
    }
}

#Preview {
    let viewModel = ProvinceViewModel()
    viewModel.provinces = Province.preview()
    return ProvinceView(viewModel: viewModel)
}
