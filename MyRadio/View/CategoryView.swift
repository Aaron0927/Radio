//
//  CategoryView.swift
//  MyRadio
//
//  Created by xiaoerlong on 2023/10/12.
//

import SwiftUI

/// 分类视图
struct CategoryView: View {
    @ObservedObject var viewModel: CategoryViewModel
    
    var body: some View {
        NavigationView {
            List(viewModel.categories) { category in
                NavigationLink(category.radio_category_name) {
//                    RadioListView(category_id: category.id, viewModel: viewModel)
                }
            }
            .navigationTitle("Categories")
            .navigationBarTitleDisplayMode(.large)
        }
        .onAppear {
            viewModel.getCategoryList()
        }
    }
}

struct CategoryView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = CategoryViewModel()
        viewModel.categories = previewCategories()
        return CategoryView(viewModel: viewModel)
    }
}
