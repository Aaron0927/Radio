//
//  RadioLIst.swift
//  MyRadio
//
//  Created by xiaoerlong on 2024/3/7.
//

import SwiftUI

struct RadioList: View {
    var category: RadioCategory
    @ObservedObject var viewModel = RadioListViewModel()
    
    var body: some View {
        NavigationStack {
            List(viewModel.radios) { radio in
                ZStack {
                    RadioCell(radio: radio)
                    NavigationLink {
                        Text("Test")
                    } label: {
                        EmptyView()
                    }
                    .opacity(0)
                }
            }
            .navigationTitle(category.radio_category_name)
            .onAppear {
                viewModel.getRadiosList(in: category.id)
            }
        }
    }
}

#Preview {
    RadioList(category: previewCategory())
}
