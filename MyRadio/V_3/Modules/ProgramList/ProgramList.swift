//
//  ProgramList.swift
//  MyRadio
//
//  Created by Aaron on 2024/5/13.
//

import SwiftUI

enum Weekday: String, CaseIterable, Identifiable {
    case monday = "周一"
    case tuesday = "周二"
    case wednesday = "周三"
    case thursday = "周四"
    case friday = "周五"
    case saturday = "周六"
    case sunday = "周日"
    
    var id: Self { self }
    
    var weekday: Int {
        switch self {
        case .monday:
            1
        case .tuesday:
            2
        case .wednesday:
            3
        case .thursday:
            4
        case .friday:
            5
        case .saturday:
            6
        case .sunday:
            0
        }
    }
    
    init?(weekday: Int) {
        switch weekday {
        case 1: self = .monday
        case 2: self = .tuesday
        case 3: self = .wednesday
        case 4: self = .thursday
        case 5: self = .friday
        case 6: self = .saturday
        case 0: self = .sunday
        default: return nil
        }
    }
}

struct ProgramList: View {
    @State private var schedules = [Schedule]()
    @State private var weekday: Weekday = .sunday
    @Environment(\.dismiss) var dismiss
    @Binding var radio_id: Int
    
    var body: some View {
        VStack {
            Picker("选择星期", selection: $weekday) {
                ForEach(Weekday.allCases) { date in
                    Text(date.rawValue).tag(date)
                }
            }
            .onChange(of: weekday) { value in
                requestSchdule(radio_id: radio_id, weekday: value.weekday)
            }
            .pickerStyle(.menu)
            
            List {
                ForEach(schedules) { schedule in
                    Button(schedule.related_program.program_name) {
                        radio_id = schedule.radio_id
                        dismiss()
                    }
                }
            }
        }
        .onAppear(perform: {
            self.weekday = Weekday(weekday: Date().weekday) ?? .sunday
        })
    }
    
    // 请求排期表
    private func requestSchdule(radio_id: Int, weekday: Int?) {
        XMNetwork.shared.provider.request(.schedules(radio_id: radio_id, weekday: weekday)) { result in
            switch result {
            case .success(let res):
                print(res)
                do {
                    self.schedules = try JSONDecoder().decode([Schedule].self, from: res.data)
                } catch {
                    print(error)
                }
            case .failure(let err):
                print(err)
            }
        }
    }
}

#Preview {
    @State var radio_id = 1066
    return ProgramList(radio_id: $radio_id)
}
