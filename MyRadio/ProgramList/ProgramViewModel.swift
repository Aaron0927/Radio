//
//  ProgramViewModel.swift
//  MyRadio
//
//  Created by xiaoerlong on 2024/3/7.
//

import Foundation

class ProgramViewModel: ObservableObject {
//    @Published var programs: [Program] = []
    private var radio_id: Int
    
    init(radio_id: Int) {
        self.radio_id = radio_id
    }
    
    func getSchedules(weekday: Int = 0) {
        XMNetwork.shared.provider.request(.schedules(radio_id: radio_id, weekday: weekday)) { result in
              switch result {
              case let .success(res):
                  do {
//                      let arr = try JSONDecoder().decode([ProgramModel].self, from: res.data)
//                      self.programs = arr
                  } catch {
                      print(error)
                  }
              case let .failure(err):
                  print(err)
              }
          }
    }
}
