//
//  RadioListView.swift
//  MyRadio
//
//  Created by Aaron on 2024/4/10.
//

import SwiftUI

struct RadioListView: View {
    @State private var isLoading = false
    @State private var radios: [Radio] = []
    @State private var searchText: String = ""
    @State private var currentPage: Int = 1
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
            ForEach(0..<searchResults.count, id:\.self) { index in
                let radio = searchResults[index]
                NavigationLink {
                    // 通过电台id获取电台下面的节目列表
                    PlayView(radio_id: radio.id, radio_name: radio.radio_name)
                } label: {
                    VStack(alignment: .leading) {
                        Text(radio.radio_name)
                        Text(radio.program_name.isEmpty ? "--" : radio.program_name)
                    }
                    .frame(minHeight: 50)
                    .onAppear(perform: {
                        if shouldLoadData(id: index) {
                            currentPage += 1
                            getRadiosList()
                        }
                    })
                }
            }
        }
        .searchable(text: $searchText, placement: .navigationBarDrawer)
        .refreshable {
            currentPage = 1
            getRadiosList()
        }
        .loadingState($isLoading)
        .emptyState(searchResults.isEmpty && !isLoading, emptyContent: {
            Text("No Radios")
                .font(.title3)
                .foregroundColor(Color.secondary)
        })
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
            if radios.isEmpty {
                isLoading = true
                getRadiosList()
            }
        })
    }
    
    private func shouldLoadData(id: Int) -> Bool {
        return radios.count >= 20 && id == radios.count - 2
    }
    
    // 请求分类下的广播电台列表
    private func getRadiosList() {
        XMNetwork.shared.provider.request(.get_radios_by_category(id: category_id, page: currentPage)) { result in
            isLoading = false
            switch result {
            case let .success(res):
                do {
                    let model = try JSONDecoder().decode(RadioModel.self, from: res.data)
                    if currentPage == 1 {
                        self.radios = model.radios
                    } else {
                        self.radios.append(contentsOf: model.radios)
                    }
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
