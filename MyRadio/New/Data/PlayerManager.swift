//
//  PlayerManager.swift
//  MyRadio
//
//  Created by Aaron on 2024/5/6.
//

import Foundation
import AVFoundation

class PlayerManager: ObservableObject {
    static let manager = PlayerManager()
    
    var player: AVPlayer?
    
    
    private init() {
        player = AVPlayer()
    }
}
