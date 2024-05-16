//
//  RadioListView.swift
//  MyRadio
//
//  Created by Aaron on 2024/4/10.
//

import SwiftUI

struct RadioListView: View {
    @State private var radios: [Radio] = []
    @State private var searchText: String = ""
    var category_id: Int
    
    private var searchResults: [Radio] {
        if searchText.isEmpty {
             return radios
        } else {
            return radios.filter({ $0.radio_name.contains(searchText) })
        }
    }
    
    var body: some View {
        List {
            ForEach(searchResults) { radio in
                NavigationLink {
                    // 通过电台id获取电台下面的节目列表
                    PlayView(radio_id: radio.id, radio_name: radio.radio_name)
                } label: {
                    VStack(alignment: .leading) {
                        Text(radio.radio_name)
                        Text(radio.program_name)
                    }
                }
            }
        }
        .searchable(text: $searchText)
        .toolbar(content: {
            NavigationLink {
                if let radio = radios.randomElement() {
                    PlayView(radio_id: radio.id, radio_name: radio.radio_name)
                }
            } label: {
                Image(systemName: "shuffle")
            }
        })
        .onAppear(perform: {
            getRadiosList(in: category_id)
        })
    }
    
    // 请求分类下的广播电台列表
    private func getRadiosList(in category_id: Int) {
        XMNetwork.shared.provider.request(.get_radios_by_category(id: category_id)) { result in
            switch result {
            case let .success(res):
                do {
                    let model = try JSONDecoder().decode(RadioModel.self, from: res.data)
                    self.radios = model.radios
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
    NavigationStack {
        RadioListView(category_id: 1)
            .navigationTitle("List")
    }
}
