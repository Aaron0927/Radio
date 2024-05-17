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
    @State private var isLoading: Bool = false
    @State private var radios = [RadioDB]()
    @State var editMode: EditMode = .inactive
    
    var body: some View {
        NavigationStack {
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
            .loadingState($isLoading)
            .emptyState(radios.isEmpty, emptyContent: {
                Text("暂无收藏")
                    .font(.title3)
                    .foregroundColor(Color.secondary)
            })
            .environment(\.editMode, $editMode)
            .onDisappear(perform: {
                try? moc.save()
            })
            .navigationTitle("Favorite")
            .toolbar(content: {
                Button(action: {
                    editMode = editMode.isEditing ? .inactive : .active
                }, label: {
                    Text(editMode.isEditing ? "编辑" : "完成")
                })
            })
        }
        .onAppear(perform: {
            getFavorits()
        })
    }
    
    // 获取数据库中收藏列表
    private func getFavorits() {
        self.isLoading = true
        let request = NSFetchRequest<RadioDB>(entityName: "RadioDB")
        request.predicate = NSPredicate(format: "favorite == true")
        let sortDescriptor = NSSortDescriptor(key: "sort", ascending: true)
        request.sortDescriptors = [sortDescriptor]
        guard let radios = try? moc.fetch(request) else {
            return
        }
        self.isLoading = false
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
