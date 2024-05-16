//
//  PlayView.swift
//  MyRadio
//
//  Created by Aaron on 2024/4/11.
//

import SwiftUI

struct PlayView: View {
    @ObservedObject private(set) var playViewModel: PlayerViewModel
    @State private var showingSheet = false
    @State var radio_id: Int
    
    init(radio_id: Int, radio_name: String) {
        self.radio_id = radio_id
        playViewModel = PlayerViewModel(radio_id: radio_id, radio_name: radio_name)
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer(minLength: 24)
                
                AsyncImage(url: URL(string: playViewModel.program?.back_pic_url ?? "")) { image in
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
                    Text(playViewModel.radio_name)
                        .font(.system(size: 24))
                    Text(playViewModel.program?.program_name ?? "--")
                        .font(.system(size: 16, weight: .semibold))
                }
                .foregroundStyle(Color.d_black)
                .frame(height: 102)
                
                Spacer()
                
                HStack {
                    // 节目单
                    Button(action: {
                        showingSheet.toggle()
                    }, label: {
                        Image(systemName: "list.bullet")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 32, height: 32)
                    })
                    .frame(maxWidth: .infinity)
                    .sheet(isPresented: $showingSheet) {
                        ProgramList(program: $playViewModel.program, radio_id: radio_id)
                    }
                    
                    // 播放控制
                    Button {
                        if playViewModel.isPlaying {
                            playViewModel.pause()
                        } else {
                            playViewModel.play()
                        }
                    } label: {
                        Image(systemName: playViewModel.isPlaying ? "pause.fill" : "play.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 32, height: 32)
                    }
                    .frame(maxWidth: .infinity)
                    
                    // 定时关闭
                    Menu {
                        ForEach(playViewModel.times, id: \.self) { time in
                            Button("\(time.formatted())min") {
                                playViewModel.setupTimer(duration: time * 60)
                            }
                        }
                    } label: {
                        timerView()
                            .frame(width: 32, height: 32)
                    }
                    .frame(maxWidth: .infinity)
                }
                .padding(.horizontal, 20)
                .foregroundStyle(Color.d_black)
                
                Spacer()
            }
            .onAppear(perform: {
                playViewModel.getPlayingProgramFromApi(radio_id: radio_id)
            })
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Now Playing")
            .toolbar(content: {
                Button(action: {
                    playViewModel.favoriteRadio()
                }, label: {
                    Image(systemName: playViewModel.favorite ? "heart.fill" : "heart")
                })
            })
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
    NavigationStack {
        PlayView(radio_id: 1065, radio_name: "中国之声")
    }
}
