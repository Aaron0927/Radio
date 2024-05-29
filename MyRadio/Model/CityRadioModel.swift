//
//  CityRadioModel.swift
//  MyRadio
//
//  Created by Aaron on 2024/5/9.
//

import Foundation

struct CityRadioModel: Codable {
    var total_page: Int
    var total_count: Int
    var current_page: Int
    var radios: [Radio]
}
