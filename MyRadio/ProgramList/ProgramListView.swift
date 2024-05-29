//
//  ProgramListView.swift
//  MyRadio
//
//  Created by xiaoerlong on 2024/3/3.
//

import SwiftUI

struct ProgramListView: View {
    @State private var selectedTab = 1
    var radio_id: Int
    @ObservedObject var viewModel: ProgramViewModel
    
    init(radio_id: Int) {
        self.radio_id = radio_id
        self.viewModel = ProgramViewModel(radio_id: radio_id)
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Text("昨日")
                        .frame(maxWidth: .infinity, minHeight: 50)
                        .font(selectedTab == 0 ? .body.bold() : .body)
                        .foregroundStyle(selectedTab == 0 ? Color.init(hex: "#22D453") : Color.init(hex: "#171C26"))
                        .onTapGesture {
                            selectedTab = 0
                        }
                    Text("今日")
                        .frame(maxWidth: .infinity, minHeight: 50)
                        .font(selectedTab == 1 ? .body.bold() : .body)
                        .foregroundStyle(selectedTab == 1 ? Color.init(hex: "#22D453") : Color.init(hex: "#171C26"))
                        .onTapGesture {
                            selectedTab = 1
                        }
                    Text("明日")
                        .frame(maxWidth: .infinity, minHeight: 50)
                        .font(selectedTab == 2 ? .body.bold() : .body)
                        .foregroundStyle(selectedTab == 2 ? Color.init(hex: "#22D453") : Color.init(hex: "#171C26"))
                        .onTapGesture {
                            selectedTab = 2
                        }
                }
                
                if selectedTab == 0 {
                    Text("测试")
                } else if selectedTab == 1 {
//                    List(viewModel.programs) { model in
//                        ZStack {
//                            ProgramCell(program: model)
////                            NavigationLink {
////                                PlayView1(radio: previewRadio())
////                            } label: {
////                                EmptyView()
////                            }
////                            .opacity(0)
//                        }
//                    }
//                    .listStyle(.plain)
                } else {
                    Text("测试2")
                }
                
                Spacer()
            }
            .navigationTitle("节目单")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                // 获取当天的节目排期
                viewModel.getSchedules()
            }
        }
        
    }
}

#Preview {
    ProgramListView(radio_id: 44157)
}
