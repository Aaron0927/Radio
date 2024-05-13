//
//  SearchView.swift
//  MyRadio
//
//  Created by xiaoerlong on 2024/1/14.
//

import SwiftUI

struct SearchView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var text: String = ""
    
    var body: some View {
        VStack {
            // 自定义导航栏
            HStack {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .foregroundStyle(Color.black)
                }
                HStack {
                    Image(systemName: "magnifyingglass")
                    TextField("请输入关键字", text: $text)
                }
                .padding(10)
                .background(Color.white)
                .clipShape(.capsule)
            }
            .frame(height: 44)
            .padding(15)
            
            Spacer(minLength: 5)
            
            ScrollView(.vertical) {
                VStack(alignment: .leading) {
                    Text("热门搜索")
                        .font(.headline.bold())
                    LazyVGrid(columns: [GridItem(), GridItem()]){
                        ForEach(0 ..< 10){ index in
                            HStack {
                                Text("\(index + 1)")
                                Text("福建交通广播")
                                    .foregroundStyle(Color.black)
                                Spacer()
                            }
                            .frame(height: 50)
                        }
                    }
                }
            }
            .padding()
            
            Spacer()
        }
//        .ignoresSafeArea(.all, edges: .top)
        .background(Color.yellow)
        .toolbar(.hidden)
    }
}

#Preview {
    NavigationView(content: {
        SearchView()
    })
}
