//
//  MyRadioApp.swift
//  MyRadio
//
//  Created by xiaoerlong on 2023/8/20.
//

import SwiftUI

@main
struct MyRadioApp: App {
    @StateObject private var dataController = DataController.shared
    
    var body: some Scene {
        WindowGroup {
            RadioCategoryView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
        }
    }
}
