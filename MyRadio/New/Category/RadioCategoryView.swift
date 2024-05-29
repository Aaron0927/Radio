//
//  RadioCategoryView.swift
//  MyRadio
//
//  Created by Aaron on 2024/4/10.
//

import SwiftUI

struct RadioCategoryView: View {
    @ObservedObject private var data = RadioCategoryData()
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(data.categories) { category in
                    NavigationLink {
                        RadioListView(category_id: category.id)
                    } label: {
                        Text(category.radio_category_name)
                    }
                }
            }
            .navigationTitle("Category")
        }
        .onAppear(perform: {
            data.getCategoryList()
        })
    }
}

#Preview {
    RadioCategoryView()
}
