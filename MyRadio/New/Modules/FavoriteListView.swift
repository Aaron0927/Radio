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
    @State private var radios: [RadioDB] = [RadioDB]()
    
    var body: some View {
        List(radios, id: \.radio_id) { radio in
            NavigationLink {
                Text("")
            } label: {
                VStack(alignment: .leading) {
                    Text(radio.radio_name ?? "")
                    Text(radio.program_name)
                }
            }

        }
        .navigationTitle("我的收藏")
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
