//
//  PlayView.swift
//  MyRadio
//
//  Created by Aaron on 2024/4/11.
//

import SwiftUI

struct PlayView: View {
    @ObservedObject private(set) var playViewModel: PlayerViewModel
    @ObservedObject var player: PlayerManager = PlayerManager.manager
    private var program: Program? {
        playViewModel.program
    }
    var radio_id: Int
    
    init(radio_id: Int) {
        self.radio_id = radio_id
        playViewModel = PlayerViewModel(radio_id: radio_id)
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer(minLength: 24)
                
                AsyncImage(url: URL(string: program?.back_pic_url ?? "")) { image in
                    image
                        .resizable()
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 286, height: 286)
                        .clipShape(RoundedRectangle(cornerRadius: 24))
                } placeholder: {
                    ProgressView()
                }
                
                Spacer(minLength: 24)
                VStack(spacing: 8) {
                    Text(playViewModel.radioName)
                        .font(.system(size: 24))
                    Text(program?.program_name ?? "--")
                        .font(.system(size: 16, weight: .semibold))
                }
                .foregroundStyle(Color.d_black)
                .frame(height: 102)
                
                Spacer()
                
                HStack(spacing: 32) {
                    Button(action: {
                        playViewModel.previous()
                    }, label: {
                        Image(systemName: "backward.end.fill")
                    })
                    Button {
                        if playViewModel.isPlaying {
                            playViewModel.pause()
                        } else {
                            playViewModel.play()
                        }
                    } label: {
                        Image(systemName: playViewModel.isPlaying ? "pause.fill" : "play.fill")
                            .frame(width: 70, height: 70)
                            .aspectRatio(contentMode: .fill)
                    }
                    Button {
                        playViewModel.next()
                    } label: {
                        Image(systemName: "forward.end.fill")
                    }
                }
                .frame(height: 70)
                .foregroundStyle(Color.d_black)
                
                Spacer(minLength: 32)
                HStack(spacing: 48) {
                    // 随机播放
                    Button(action: {
                        playViewModel.shuffle()
                    }, label: {
                        Image(systemName: "shuffle")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 32, height: 32)
                    })
                    
                    // 收藏
                    Button {
                        playViewModel.favorite.toggle()
                    } label: {
                        Image(systemName: playViewModel.favorite ? "heart.fill" : "heart")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 32, height: 32)
                    }

                    NavigationLink {
//                        ProgramListView(radio_id: playViewModel.radio_id)
                    } label: {
                        Image(systemName: "list.bullet")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 32, height: 32)
                    }
                    // 定时关闭
                    Menu {
                        ForEach(playViewModel.times, id: \.self) { time in
                            Button("\(time.formatted())min") {
                                playViewModel.setupTimer(duration: time * 60)
                            }
                        }
                    } label: {
                        timerView()
                    }
                }
                .frame(height: 32)
                .foregroundStyle(Color.d_black)
                
                
                
                Spacer(minLength: 44)
                
            }
            .onAppear(perform: {
                playViewModel.getPlayingProgramFromApi(radio_id: radio_id)
            })
            .onDisappear(perform: {
                playViewModel.updateDBData()
            })
            .navigationTitle("Now Playing")
        }
    }
    
    // 定时器样式
    @ViewBuilder
    private func timerView() -> some View {
        if playViewModel.remainingTime > 0 {
            TimeFormatter(playViewModel.remainingTime)
                .padding(5)
                .background(Color(hex: "#22D453"))
                .clipShape(RoundedRectangle(cornerRadius: 5))
                .foregroundStyle(Color.white)
        } else {
            Image(systemName: "moon.zzz.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 32, height: 32)
        }
    }
}

#Preview {
    PlayView(radio_id: 1065)
}
