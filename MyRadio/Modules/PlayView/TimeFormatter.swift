//
//  TimeFormatter.swift
//  MyRadio
//
//  Created by Aaron on 2024/3/2.
//

import SwiftUI

struct TimeFormatter: View {
    private var timeInterval: TimeInterval
    
    init(_ timeInterval: TimeInterval) {
        self.timeInterval = timeInterval
    }
    
    private var hours: Int {
        return Int(timeInterval) / 3600
    }
    
    private var minutes: Int {
        return (Int(timeInterval) % 3600) / 60
    }
    
    private var seconds: Int {
        return Int(timeInterval) % 60
    }
    
    var body: some View {
        if hours == 0 {
            Text(String(format: "%02d:%02d", minutes, seconds))
        } else {
            Text(String(format: "%02d:%02d:%02d", hours, minutes, seconds))
        }
    }
}
