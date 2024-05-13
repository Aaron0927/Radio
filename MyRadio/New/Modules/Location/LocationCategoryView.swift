//
//  LocationCategoryView.swift
//  MyRadio
//
//  Created by Aaron on 2024/5/12.
//

import SwiftUI

enum Segment: String, CaseIterable, Identifiable {
    case country = "国家台"
    case city = "省市台"
    case network = "网络台"
    
    var type: Int {
        switch self {
        case .country:
            1
        case .city:
            2
        case .network:
            3
        }
    }
    
    var id: String {
        rawValue
    }
}

struct LocationCategoryView: View {
    @State private var selectedSegment: Segment = .country
    var body: some View {
        NavigationStack {
            List(Segment.allCases, id: \.self) { option in
                NavigationLink {
                    if option == .city {
                        CityListView()
                    } else {
                        CityRadiosView(selectedSegment: option)
                    }
                } label: {
                    Text(option.rawValue)
                }
            }
            .navigationTitle("Location")
        }
    }
}

#Preview {
    LocationCategoryView()
}
