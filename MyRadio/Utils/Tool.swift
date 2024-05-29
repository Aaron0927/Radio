//
//  Tool.swift
//  MyRadio
//
//  Created by Aaron on 2024/3/2.
//

import UIKit

public extension UIColor {
    /// 通过16进制的字符串创建UIColor
    ///
    /// - Parameter hex: 16进制字符串，格式为#ececec
    convenience init(hex: String) {
        let hex = (hex as NSString).trimmingCharacters(in: .whitespacesAndNewlines)
        let scanner = Scanner(string: hex)
        
        if hex.hasPrefix("#") {
            scanner.scanLocation = 1
        }
        
        var color: UInt32 = 0
        scanner.scanHexInt32(&color)
        
        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
        
        let red   = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue  = CGFloat(b) / 255.0
        self.init(red: red, green: green, blue: blue, alpha: 1)
    }
    
    convenience init(colorHex hex: UInt) {
        self.init(red: CGFloat((hex & 0xFF0000) >> 16) / 255,
                  green: CGFloat((hex & 0x00FF00) >> 8) / 255,
                  blue: CGFloat(hex & 0x0000FF) / 255, alpha: 1)
    }
}

