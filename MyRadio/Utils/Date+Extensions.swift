//
//  Date+Extensions.swift
//  MyRadio
//
//  Created by Aaron on 2024/5/13.
//

import Foundation

extension Date {
    var weekday: Int {
        let calendar = Calendar.current
        let weekday = calendar.component(.weekday, from: self)
        return weekday - 1
    }
}
