//
//  String+Extensions.swift
//  MyRadio
//
//  Created by Aaron on 2024/4/8.
//

import Foundation

extension String {
    func convertToCurrentDate() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"

        // 获取当前日期
        let currentDate = Date()

        // 获取当前日历
        let calendar = Calendar.current

        // 将时间字符串转换为日期
        if let timeDate = dateFormatter.date(from: self) {
            // 使用当前日期的年份、月份和日期，以及从时间字符串解析出的小时和分钟，构建新的日期
            let components = calendar.dateComponents([.year, .month, .day], from: currentDate)
            let timeComponents = calendar.dateComponents([.hour, .minute], from: timeDate)
            let mergedComponents = calendar.date(bySettingHour: timeComponents.hour ?? 0, minute: timeComponents.minute ?? 0, second: 0, of: components.date ?? currentDate)

            return mergedComponents
        }

        return nil
    }
}
