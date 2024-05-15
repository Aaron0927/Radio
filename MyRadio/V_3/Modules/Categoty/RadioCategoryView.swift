//
//  RadioCategoryView.swift
//  MyRadio
//
//  Created by Aaron on 2024/4/10.
//

import SwiftUI

struct RadioCategoryView: View {
    @State private var categories: [RadioCategory] = []
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(categories) { category in
                    NavigationLink {
                        RadioListView(category_id: category.id)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background(.red)
                            .toolbar(.hidden, for: .tabBar)
                    } label: {
                        Text(category.radio_category_name)
                    }
                }
            }
            .navigationTitle("Category")
        }
        .onAppear(perform: {
            getCategoryList()
        })
    }
    
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

#Preview {
    RadioCategoryView()
}
