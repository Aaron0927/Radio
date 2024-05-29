//
//  ProgramCell.swift
//  MyRadio
//
//  Created by xiaoerlong on 2024/3/3.
//

import SwiftUI

struct ProgramCell: View {
    var program: Program
    
    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading, spacing: 10) {
                    Text(program.program_name)
                        .font(.system(size: 18).weight(.medium))
                        .foregroundStyle(Color.init(hex: "#171C26"))
//                    Text("\(program.start_time)-\(program.end_time)")
//                        .font(.system(size: 14).weight(.medium))
//                        .foregroundStyle(Color.init(hex: "#171C26"))
//                        .opacity(0.7)
                }
                .padding(.vertical, 5)

                Spacer()

                Button {
                    // 需要通过radio_id 获取
//                    PlayView1(radio: previewRadio())
//                    player.get_playing_program(radio_id: program.radio_id)
//                    if program.can_listen_back {
//                        player.play(with: program.listen_back_url)
//                    } else {
//                        player.get_playing_program(radio_id: program.radio_id)
//                    }
                } label: {
//                    switch program.status {
//                    case .played:
//                        HStack {
//                            Image(systemName: "headphones")
//                                .frame(width: 20, height: 20)
//                            Text("回听")
//                        }
//                        .frame(width: 80)
//                        .padding(5)
//                        .foregroundStyle(Color.white)
//                        .background(Color.init(hex: "#EDD36F"))
//                        .clipShape(RoundedRectangle(cornerRadius: 5))
//                    case .playing:
//                        HStack {
//                            Image(systemName: "waveform")
//                            Text("直播")
//                        }
//                        .frame(width: 80)
//                        .padding(5)
//                        .foregroundStyle(Color.white)
//                        .background(Color.init(hex: "#FF4500"))
//                        .clipShape(RoundedRectangle(cornerRadius: 5))
//                    case .unplay:
//                        HStack {
//                            Text("预约")
//                        }
//                        .frame(width: 80)
//                        .padding(5)
//                        .foregroundStyle(Color.white)
//                        .background(Color.init(hex: "#22D453"))
//                        .clipShape(RoundedRectangle(cornerRadius: 5))
//                    }
                }
            }
            .padding(.horizontal, 15)
        }
    }
}

#Preview {
    ProgramCell(program: Program(id: 1, program_name: "", back_pic_url: "", support_bitrates: [], rate24_aac_url: "", rate64_aac_url: "", rate24_ts_url: "", rate64_ts_url: "", updated_at: 0))
}
