//
//  LocationView.swift
//  MyRadio
//
//  Created by Aaron on 2024/5/9.
//

import SwiftUI

struct CityRadiosView: View {
    @State private var isLoading: Bool = false
    @State private var radios = [Radio]()
    @State private var searchText: String = ""
    @State private var currentPage: Int = 1
    var selectedSegment: Segment
    var province_code: Int?
    
    private var searchResults: [Radio] {
        if searchText.isEmpty {
            return radios
        } else {
            return radios.filter({ $0.radio_name.contains(searchText) })
        }
    }
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(0..<searchResults.count, id: \.self) { index in
                    let radio = searchResults[index]
                    NavigationLink {
                        PlayView(radio_id: radio.id, radio_name: radio.radio_name)
                    } label: {
                        Text(radio.radio_name)
                            .onAppear(perform: {
                                if shouldLoadData(id: index) {
                                    currentPage += 1
                                    requestRadios()
                                }
                            })
                    }
                }
            }
            .searchable(text: $searchText, placement: .navigationBarDrawer)
            .refreshable {
                currentPage = 1
                requestRadios()
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
            .toolbar(.hidden, for: .tabBar)
            .onAppear(perform: {
                isLoading = true
                requestRadios()
            })
        }
    }
    
    private func shouldLoadData(id: Int) -> Bool {
        return radios.count >= 20 && id == radios.count - 2
    }
    
    // 请求省市下的广播电台列表
    private func requestRadios() {
        XMNetwork.shared.provider.request(.radios(radio_type: selectedSegment.type, province_code: province_code, page: currentPage)) { result in
            self.isLoading = false
            switch result {
            case .success(let res):
                print(res)
                do {
                    let model = try JSONDecoder().decode(CityRadioModel.self, from: res.data)
                    if currentPage == 1 {
                        self.radios = model.radios
                    } else {
                        self.radios.append(contentsOf: model.radios)
                    }
                    self.currentPage += 1
                } catch {
                    print(error)
                }
            case .failure(let err):
                print(err)
            }
        }
    }
}

#Preview {
    NavigationStack {
        CityRadiosView(selectedSegment: Segment.country)
    }
}
