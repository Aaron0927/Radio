//
//  ContentView.swift
//  MyRadio
//
//  Created by xiaoerlong on 2023/8/20.
//

import SwiftUI

struct ContentView: View {
    
    @State private var presented = false
    
    var body: some View {
        VStack {
            Button("Test") {
                XMNetwork.request(target: .radio_categories) { result in
                    
                }
            }
            
            // 电台播放页面
            TopContentView()

            // 全部电台、收藏按钮
            HStack {
                Button {
                    presented.toggle()
                } label: {
                    HStack {
                        Text("全部电台(730)")
                        Image(systemName: "triangle.fill")
                    }
                    .padding(EdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 15))
                    .frame(height: 30)
                    .background {
                        Color.red
                    }
                    .cornerRadius(30)
                }
                .sheet(isPresented: $presented) {
                    Text("aaa")
                        .frame(height: 300)
                }
                
                Button {
                    
                } label: {
                    Text("我的收藏")
                }
                Spacer()
            }
            .foregroundColor(.white)

            
            // 列表
            GridComponent()
        }
        .padding()
        .background {
            Color(hex: "#3b3b3e")
        }
    }
    
}

// MARK: Play Cover
struct TopContentView: View {
    var body: some View {
        ZStack {
            VStack(spacing: 15) {
                Text("电台名称")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                Spacer()
                HStack(spacing: 25) {
                    Image(systemName: "backward.end")
                        .font(.title)
                        .foregroundColor(.white)
                        .onTapGesture {
                            print("上一个")
                        }
                    Image(systemName: "play")
                        .font(.title)
                        .foregroundColor(.white)
                        .onTapGesture {
                            print("播放/暂停")
                        }
                    Image(systemName: "forward.end")
                        .font(.title)
                        .foregroundColor(.white)
                        .onTapGesture {
                            print("下一个")
                        }
                    Spacer()
                    Image(systemName: "star")
                        .font(.title)
                        .foregroundColor(.white)
                        .onTapGesture {
                            print("下一个")
                        }
                }
                .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
            }
        }
        .frame(height: 150)
        .padding()
        .background(Color.red)
        .cornerRadius(10)
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
