//
//  CityListView.swift
//  MyRadio
//
//  Created by Aaron on 2024/5/12.
//

import SwiftUI

struct CityListView: View {
    @State private var isLoading: Bool = false
    @State private var cities = [Province]()
    @State private var searchText: String = ""
    
    private var searchResults: [Province] {
        if searchText.isEmpty {
            return cities
        } else {
            return cities.filter({ $0.province_name.contains(searchText) })
        }
    }
    
    var body: some View {
        List {
            ForEach(searchResults) { city in
                NavigationLink(city.province_name) {
                    CityRadiosView(selectedSegment: Segment.city, province_code: city.province_code)
                }
            }
        }
        .searchable(text: $searchText, placement: .navigationBarDrawer)
        .loadingState($isLoading)
        .emptyState(searchResults.isEmpty && !isLoading, emptyContent: {
            Text("No Cities")
                .font(.title3)
                .foregroundColor(Color.secondary)
        })
        .onAppear(perform: {
            requestCities()
        })
    }
    
    // 请求省市列表
    private func requestCities() {
        isLoading = true
        XMNetwork.shared.provider.request(.provinces) { result in
            self.isLoading = false
            switch result {
            case .success(let res):
                do {
                    self.cities = try JSONDecoder().decode([Province].self, from: res.data)
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
        CityListView()
    }
}
