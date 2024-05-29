//
//  MyRadioApp.swift
//  MyRadio
//
//  Created by Aaron on 2023/8/20.
//

import SwiftUI

@main
struct MyRadioApp: App {
    @StateObject private var dataController = DataController.shared
    
    var body: some Scene {
        WindowGroup {
            TabView {
                RadioCategoryView()
                    .tabItem {
                        Label("分类", systemImage: "square.grid.2x2.fill")
                    }
                LocationCategoryView()
                    .tabItem {
                        Label("地区", systemImage: "location.fill")
                    }
                FavoriteListView()
                    .tabItem {
                        Label("收藏", systemImage: "heart.fill")
                    }
            }
            .environment(\.managedObjectContext, dataController.container.viewContext)
        }
    }
}
