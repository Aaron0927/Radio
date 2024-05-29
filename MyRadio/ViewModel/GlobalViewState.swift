//
//  GlobalViewState.swift
//  MyRadio
//
//  Created by xiaoerlong on 2024/1/1.
//

import Foundation

class GlobalViewState: ObservableObject {
    @Published var isGlobalViewVisible = false
    @Published var isPlayed = false
}
