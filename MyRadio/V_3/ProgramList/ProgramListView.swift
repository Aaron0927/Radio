//
//  ProgramListView.swift
//  MyRadio
//
//  Created by Aaron on 2024/4/11.
//

import SwiftUI

struct ProgramListView: View {
    @ObservedObject private var data = ProgramData()
    var radio_id: Int
    
    var body: some View {
        List {
            ForEach(data.schedules) { schedule in
                NavigationLink {
                    PlayView(radio_id: radio_id)
                } label: {
                    VStack(alignment: .leading) {
                        Text(schedule.related_program.program_name)
                        Text("\(schedule.start_time)-\(schedule.end_time)")
                    }
                    
                }

            }
        }
        .navigationTitle("Program List")
        .onAppear(perform: {
            data.getSchedules(radio_id: radio_id)
        })
    }
}

#Preview {
    ProgramListView(radio_id: 967)
}
