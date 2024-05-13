//
//  HomeView.swift
//  MyRadio
//
//  Created by xiaoerlong on 2024/1/11.
//

import SwiftUI



struct HomeView: View {
    struct RadioType: Identifiable {
        var id = UUID().uuidString
        var name: String
        var code: Int
        var province_code: Int?
    }
    var titles = [
        RadioType(name: "国家台", code: 1),
        RadioType(name: "省市台", code: 2),
        RadioType(name: "网络台", code: 3)
    ]
    
    @ObservedObject var categoryVM = CategoryViewModel()
    @ObservedObject var homeViewModel = HomeViewModel()
//    var categorites = ["新闻台", "音乐台", "交通台", "体育台", "经济台", "新闻台", "音乐台", "交通台", "体育台", "经济台", "新闻台", "音乐台", "交通台", "体育台", "经济台"]
    
    
    var body: some View {
        NavigationView {
            ScrollView(.vertical) {
                VStack {
                    Spacer(minLength: 15)
                    HStack(spacing: 50) {
                        ForEach(titles) { radioType in
                            NavigationLink {
                                ListView(viewModel: ListViewModel(title: radioType.name, radio_type: radioType.code, province_code: radioType.province_code))
                            } label: {
                                VStack {
                                    Image("test_1")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                    Text(radioType.name)
                                        .foregroundStyle(Color.gray)
                                }
                            }

                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: 100)
                    .padding(.horizontal, 30)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(categoryVM.categories) { category in
                                NavigationLink {
                                    ListView(viewModel: ListViewModel(title: category.radio_category_name, category_id: category.id))
                                } label: {
                                    Text(category.radio_category_name)
                                        .font(.body)
                                        .foregroundStyle(.orange)
                                        .padding(5)
                                        .background(.yellow)
                                        .border(Color.orange)
                                        .clipShape(RoundedRectangle(cornerRadius: 5))
                                }
                                
                            }
                        }
                    }.padding()
                    
                    
                    // 本地热听
                    VStack {
                        HStack {
                            Text("本地热听")
                            Spacer()
                            NavigationLink {
                                ListView(viewModel: ListViewModel(title: "本地热听", category_id: 1))
                            } label: {
                                HStack {
                                    Text("更多")
                                    Image(systemName: "chevron.right")
                                }
                                .font(.footnote)
                                .foregroundStyle(Color.gray)
                            }

                        }
                        
                        VStack(spacing: 5) {
                            ForEach(0..<5) { _ in
                                HStack(alignment: .top) {
                                    Image("test_1")
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 80, height: 80)
                                        .clipShape(RoundedRectangle(cornerRadius: 5))
                                    
                                    VStack {
                                        VStack(alignment: .leading, spacing: 5) {
                                            Text("京津冀之声")
                                                .font(.title3)
                                            HStack {
                                                Image(systemName: "pause")
                                                    .frame(width: 15)
                                                Text("正在直播:社会心理指导周末课堂")
                                            }
                                            .font(.callout)
                                            .lineLimit(1)
                                            .minimumScaleFactor(0.5)
                                            HStack {
                                                Image(systemName: "headphones")
                                                    .frame(width: 15)
                                                Text("收听人数:1.5万")
                                                Text("内容由喜马拉雅APP提供")
                                            }
                                            .font(.footnote)
                                            .lineLimit(1)
                                            .minimumScaleFactor(0.5)
                                        }
                                        Spacer()
                                        Divider()
                                    }
                                    Spacer()
                                }
                                .frame(height: 80)
                                .padding(.vertical, 5)
                            }
                        }
                        .padding(10)
                        .background(Color.yellow)
                        .clipShape(RoundedRectangle(cornerRadius: 5))
                    }.padding()
                    
                    
                    // 排行榜
                    VStack {
                        HStack {
                            Text("排行榜")
                            Spacer()
                            NavigationLink {
                                ListView(viewModel: ListViewModel(title: "排行榜", radio_type: 1))
                            } label: {
                                HStack {
                                    Text("更多")
                                    Image(systemName: "chevron.right")
                                }
                                .font(.footnote)
                                .foregroundStyle(Color.gray)
                            }

                        }
                        
                        VStack(spacing: 5) {
                            ForEach(0..<5) { _ in
                                HStack(alignment: .top) {
                                    Image("test_1")
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 80, height: 80)
                                        .clipShape(RoundedRectangle(cornerRadius: 5))
                                    
                                    VStack(alignment: .leading) {
                                        Text("京津冀之声")
                                            .font(.title3)
                                        HStack {
                                            Image(systemName: "pause")
                                                .frame(width: 15)
                                            Text("正在直播:社会心理指导周末课堂")
                                        }
                                        .font(.callout)
                                        .lineLimit(1)
                                        .minimumScaleFactor(0.5)
                                        HStack {
                                            Image(systemName: "headphones")
                                                .frame(width: 15)
                                            Text("收听人数:1.5万")
                                            Text("内容由喜马拉雅APP提供")
                                        }
                                        .font(.footnote)
                                        .lineLimit(1)
                                        .minimumScaleFactor(0.5)
                                        
                                        Spacer()
                                        
                                        Divider()
                                    }
                                    Spacer()
                                }
                                .frame(height: 80)
                                .padding(.vertical, 5)
                            }
                        }
                        .padding(10)
                        .background(Color.yellow)
                        .clipShape(RoundedRectangle(cornerRadius: 5))
                    }.padding()
                    
                    Spacer()
                }
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Text("电台")
                            .font(.title)
                    }
                    ToolbarItem(placement: .topBarTrailing) {
                        NavigationLink {
                            SearchView()
                        } label: {
                            HStack {
                                Image(systemName: "magnifyingglass")
                                Text("搜索")
                            }
                        }

                    }
                }
            }
        }
        .onAppear {
            categoryVM.getCategoryList()
        }
    }
}

#Preview {
    HomeView()
}
