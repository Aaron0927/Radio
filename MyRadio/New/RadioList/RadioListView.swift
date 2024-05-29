//
//  RadioListView.swift
//  MyRadio
//
//  Created by Aaron on 2024/4/10.
//

import SwiftUI

struct RadioListView: View {
    @ObservedObject private var radioListData = RadioListData()
    var category_id: Int
    
    var body: some View {
        List {
            ForEach(radioListData.radios) { radio in
                NavigationLink {
                    // 通过电台id获取电台下面的节目列表
                    PlayView(radio_id: radio.id)
                } label: {
                    VStack(alignment: .leading) {
                        Text(radio.radio_name)
                        Text(radio.program_name)
                    }
                }
            }
        }
        .onAppear(perform: {
            radioListData.getRadiosList(in: category_id)
        })
    }
}

#Preview {
    RadioListView(category_id: 1)
}
