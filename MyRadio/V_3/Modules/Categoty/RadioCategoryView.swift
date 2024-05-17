//
//  RadioCategoryView.swift
//  MyRadio
//
//  Created by Aaron on 2024/4/10.
//

import SwiftUI

struct RadioCategoryView: View {
    @State private var isLoading = false
    @State private var categories: [RadioCategory] = []
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(categories) { category in
                    NavigationLink {
                        RadioListView(category_id: category.id)
                            .toolbar(.hidden, for: .tabBar)
                    } label: {
                        Text(category.radio_category_name)
                    }
                }
            }
            .loadingState($isLoading)
            .emptyState(categories.isEmpty && !isLoading, emptyContent: {
                Text("No Categories")
                    .font(.title3)
                    .foregroundColor(Color.secondary)
            })
            .navigationTitle("Category")
        }
        .onAppear(perform: {
            if categories.isEmpty {
                getCategoryList()
            }
        })
    }
    
    private func getCategoryList() {
        isLoading = true
        XMNetwork.shared.provider.request(.radio_categories) { result in
            self.isLoading = false
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

#Preview {
    RadioCategoryView()
}
