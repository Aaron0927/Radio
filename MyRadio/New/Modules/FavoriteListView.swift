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
    
    var body: some View {
//        List(radios, id: \.radio_id) { radio in
//            NavigationLink {
//                Text("")
//            } label: {
//                VStack(alignment: .leading) {
//                    Text(radio.radio_name ?? "")
//                    Text(radio.program_name)
//                }
//            }
//
//        }
        Text("11")
        .navigationTitle("我的收藏")
        .onAppear(perform: {
//            getFavorits()
        })
    }
    
    // 获取数据库中收藏列表
//    private func getFavorits() {
//        let request = NSFetchRequest<RadioDB>(entityName: "RadioDB")
//        guard let radios = try? moc.fetch(request) else {
//            return
//        }
//        self.radios = radios
//    }
}

#Preview {
    FavoriteListView()
}
