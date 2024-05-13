//
//  Test.swift
//  MyRadio
//
//  Created by Aaron on 2024/5/13.
//

import SwiftUI

struct Test: View {
    @State private var selected: Int
    
    init(selected: Int) {
        self.selected = selected
    }
    
    var body: some View {
        Picker("Picker测试", selection: $selected) {
            Text("1").tag(0)
            Text("2").tag(1)
            Text("3").tag(2)
        }
        .pickerStyle(.menu)
        .onChange(of: selected) { value in
            print(value)
        }
    }
}

#Preview {
    Test(selected: 0)
}
