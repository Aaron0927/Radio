//
//  FavoriteListView.swift
//  MyRadio
//
//  Created by Aaron on 2024/5/6.
//

import SwiftUI
import CoreData

struct FavoriteListView: View {
    @Environment(\.managedObjectContext) var moc
    @State private var radios = [RadioDB]()
    
    var body: some View {
        NavigationStack {
            List(radios, id: \.radio_id) { radio in
                NavigationLink {
                    PlayView(radio_id: Int(radio.radio_id))
                        .toolbar(.hidden, for: .tabBar)
                } label: {
                    Text(radio.radio_name)
                }
            }
            .navigationTitle("Favorite")
        }
        .onAppear(perform: {
            getFavorits()
        })
    }
    
    // 获取数据库中收藏列表
    private func getFavorits() {
        let request = NSFetchRequest<RadioDB>(entityName: "RadioDB")
        guard let radios = try? moc.fetch(request) else {
            return
        }
        self.radios = radios
    }
}

#Preview {
    FavoriteListView()
}
