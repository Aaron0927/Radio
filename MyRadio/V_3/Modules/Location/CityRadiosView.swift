//
//  LocationView.swift
//  MyRadio
//
//  Created by Aaron on 2024/5/9.
//

import SwiftUI

struct CityRadiosView: View {
    @State private var radios = [Radio]()
    var selectedSegment: Segment
    var province_code: Int?
    
    var body: some View {
        NavigationStack {
            List(radios) { radio in
                NavigationLink(radio.radio_name) {
                    PlayView(radio_id: radio.id)
                }
            }
            .listStyle(.insetGrouped)
            .toolbar(.hidden, for: .tabBar)
            .onAppear(perform: {
                requestRadios(radio_type: selectedSegment.type)
            })
        }
    }
    
    // 请求省市下的广播电台列表
    private func requestRadios(radio_type: Int) {
        XMNetwork.shared.provider.request(.radios(radio_type: radio_type, province_code: province_code)) { result in
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
    CityRadiosView(selectedSegment: Segment.city)
}
