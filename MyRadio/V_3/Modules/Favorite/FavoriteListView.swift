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
                contentView()
                .navigationTitle("Favorite")
        }
        .onAppear(perform: {
            getFavorits()
        })
    }
    
    @ViewBuilder
    private func contentView() -> some View {
        if radios.isEmpty {
            Text("暂无收藏")
        } else {
            List(radios, id: \.radio_id) { radio in
                NavigationLink {
                    PlayView(radio_id: Int(radio.radio_id))
                        .toolbar(.hidden, for: .tabBar)
                } label: {
                    Text(radio.radio_name)
                }
            }
        }
    }
    
    // 获取数据库中收藏列表
    private func getFavorits() {
        let request = NSFetchRequest<RadioDB>(entityName: "RadioDB")
        request.predicate = NSPredicate(format: "favorite == true")
        guard let radios = try? moc.fetch(request) else {
            return
        }
        self.radios = radios
    }
}

#Preview {
    FavoriteListView()
}
