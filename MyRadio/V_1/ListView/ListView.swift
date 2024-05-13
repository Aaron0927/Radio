//
//  ListView.swift
//  MyRadio
//
//  Created by xiaoerlong on 2024/1/14.
//

import SwiftUI
import Refresh

struct ListView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: ListViewModel
    
    var body: some View {
        ScrollView(.vertical) {
            RefreshHeader(refreshing: $viewModel.headerRefreshing, action: reload) { progress in
                if self.viewModel.headerRefreshing {
                    Text("refreshing...")
                } else {
                    Text("Pull to refresh")
                }
            }
            LazyVStack {
                ForEach(viewModel.radios) { radio in
                    NavigationLink {
                        Text("aa")
                    } label: {
                        CardView(radio: radio)
                    }

                }
                .padding()
            }
            
            RefreshFooter(refreshing: $viewModel.footerRefreshing, action: loadMore) {
                if self.viewModel.noMore {
                    Text("No more data !")
                } else {
                    Text("refreshing...")
                }
            }
            .noMore(self.viewModel.noMore)
            .preload(offset: 50)
        }
        .enableRefresh()
        .navigationTitle(viewModel.title)
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button(action: {
                    dismiss()
                }, label: {
                    Image(systemName: "chevron.left")
                        .foregroundStyle(Color.gray)
                })
            }
        }
        .onAppear {
            viewModel.request()
        }
    }
    
    private func reload() {
        viewModel.headerRefreshing = false
    }
    
    private func loadMore() {
        viewModel.footerRefreshing = false
    }
}

#Preview {
    let vm = ListViewModel(title: "国家台", radio_type: 1, province_code: nil)
    vm.radios = previewRadios()
    return NavigationView(content: {
        ListView(viewModel: vm)
            .navigationBarTitleDisplayMode(.inline)
    })
}
