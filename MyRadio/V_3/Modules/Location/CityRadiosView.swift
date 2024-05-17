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
                ForEach(searchResults) { radio in
                    NavigationLink(radio.radio_name) {
                        PlayView(radio_id: radio.id, radio_name: radio.radio_name)
                    }
                }
            }
            .searchable(text: $searchText, placement: .navigationBarDrawer)
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
                requestRadios(radio_type: selectedSegment.type)
            })
        }
    }
    
    // 请求省市下的广播电台列表
    private func requestRadios(radio_type: Int) {
        isLoading = true
        XMNetwork.shared.provider.request(.radios(radio_type: radio_type, province_code: province_code)) { result in
            self.isLoading = false
            switch result {
            case .success(let res):
                print(res)
                do {
                    let model = try JSONDecoder().decode(CityRadioModel.self, from: res.data)
                    self.radios = model.radios
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
