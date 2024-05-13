//
//  CityListView.swift
//  MyRadio
//
//  Created by Aaron on 2024/5/12.
//

import SwiftUI

struct CityListView: View {
    @State private var cities = [Province]()
    
    var body: some View {
        List(cities) { city in
            NavigationLink(city.province_name) {
                CityRadiosView(selectedSegment: Segment.city, province_code: city.province_code)
            }
        }
        .onAppear(perform: {
            requestCities()
        })
    }
    
    // 请求省市列表
    private func requestCities() {
        XMNetwork.shared.provider.request(.provinces) { result in
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
    CityListView()
}
