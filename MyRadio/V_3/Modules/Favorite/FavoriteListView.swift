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
    @State var editMode: EditMode = .inactive
    
    var body: some View {
        NavigationStack {
            contentView()
            .navigationTitle("Favorite")
            .toolbar(content: {
                Button(action: {
                    editMode = editMode.isEditing ? .inactive : .active
                }, label: {
                    Text("编辑")
                })
            })
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
            List {
                ForEach(radios, id: \.radio_id) { radio in
                    NavigationLink {
                        PlayView(radio_id: Int(radio.radio_id), radio_name: radio.radio_name)
                            .toolbar(.hidden, for: .tabBar)
                    } label: {
                        Text(radio.radio_name)
                    }
                }
                .onMove { fromSet, to in
                    radios.move(fromOffsets: fromSet, toOffset: to)
                    if let fromIndex = fromSet.first {
                        updateDataIndex(fromRadio: radios[fromIndex], toRadio: radios[to])
                    }
                }
                .onDelete { indexSet in
                    radios.remove(atOffsets: indexSet)
                    if let index = indexSet.first {
                        removeData(radios[index])
                    }
                }
            }
            .environment(\.editMode, $editMode)
            .onDisappear(perform: {
                try? moc.save()
            })
        }
    }
    
    // 获取数据库中收藏列表
    private func getFavorits() {
        let request = NSFetchRequest<RadioDB>(entityName: "RadioDB")
        request.predicate = NSPredicate(format: "favorite == true")
        let sortDescriptor = NSSortDescriptor(key: "sort", ascending: true)
        request.sortDescriptors = [sortDescriptor]
        guard let radios = try? moc.fetch(request) else {
            return
        }
        self.radios = radios
    }
    
    // 删除数据库中数据
    private func removeData(_ radio: RadioDB) {
        moc.delete(radio)
    }
    
    // 数据排序
    private func updateDataIndex(fromRadio: RadioDB, toRadio: RadioDB) {
        let tempSortValue = fromRadio.sort
        fromRadio.sort = toRadio.sort
        toRadio.sort = tempSortValue
    }
}

#Preview {
    NavigationStack {
        FavoriteListView()
    }
}
