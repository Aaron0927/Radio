//
//  RadioHomeView.swift
//  MyRadio
//
//  Created by xiaoerlong on 2024/3/4.
//

import SwiftUI

struct RadioHomeView: View {
    @State private var searchText: String = ""
    let texts = ["Text 1", "Text 2", "Text 3", "Text 4", "Text 5", "Text 6", "Text 7", "Text 8", "Text 9", "Text 11", "Text 12", "Text 13", "Text 14", "Text 15", "Text 16", "Text 17", "Text 18", "Text 19"]
    @ObservedObject var viewModel = RadioHomeViewModel()
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack {
                    Spacer(minLength: 15)
                    // 推荐
                    VStack(alignment: .leading) {
                        Text("推荐")
                            .font(.title2.bold())
                        ScrollView(.horizontal, showsIndicators: false) {
                            LazyHStack(spacing: 20) {
                                ForEach(0..<10) { index in
                                    NavigationLink {
                                        
                                    } label: {
                                        RadioCardView()
                                    }
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 15)
                    .padding(.bottom, 15)
                    
                    // 本地
                    VStack(alignment: .leading) {
                        Text("本地")
                            .font(.title2.bold())
                        ScrollView(.horizontal, showsIndicators: false) {
                            LazyHStack(spacing: 20) {
                                ForEach(0..<10) { index in
                                    RadioCardView()
                                }
                            }
                        }
                    }
                    .padding(.leading, 15)
                    .padding(.bottom, 15)
                    
                    // 分类
                    VStack(alignment: .leading) {
                        Text("电台分类")
                            .font(.title2.bold())
                        LazyVGrid(columns: [
                            GridItem.init(.flexible(), spacing: 10, alignment: .center),
                            GridItem.init(.flexible(), spacing: 10, alignment: .center),
                            GridItem.init(.flexible(), spacing: 10, alignment: .center),
                        ], spacing: 10) {
                            ForEach(viewModel.categories) { category in
                                NavigationLink {
                                    RadioList(category: category)
                                } label: {
                                    Text(category.radio_category_name)
                                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                                        .padding(.horizontal, 10)
                                        .padding(.vertical, 5)
                                        .background(Color(hex: "#22D453"))
                                        .foregroundColor(.white)
                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                }

                            }
                        }
                        .padding(.trailing, 15)
                    }
                    .padding(.leading, 15)
                    .padding(.bottom, 15)
                }
            }
            .navigationTitle("Home")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
//                    if let radio = player.radio {
//                        NavigationLink("Help") {
////                            PlayView1(radio: radio)
//                        }
//                    }
                }
            }
            .searchable(text: $searchText)
            .onAppear {
                viewModel.refreshData()
            }
        }
    }
}

#Preview {
    RadioHomeView()
}
