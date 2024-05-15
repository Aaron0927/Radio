//
//  PlayerViewModel.swift
//  MyRadio
//
//  Created by Aaron on 2024/5/2.
//

import Foundation
import AVFoundation
import MediaPlayer
import CoreData

// 播放器页面处理类
class PlayerViewModel: ObservableObject {
    let moc = DataController.shared.container.viewContext
    
    // 播放状态
    @Published var isPlaying = false
    // 收藏状态
    @Published private(set) var favorite: Bool = false
    // 当前正在播放的节目
    @Published var program: Program? {
        didSet {
            self.setupPlaySource()
        }
    }
    // 电台名称
    @Published private(set) var radioName: String = ""
    
    private var player: AVPlayer? { PlayerManager.manager.player }
    let times: [TimeInterval] = [5, 15, 30, 60, 120] // 定时时长
    @Published private(set) var remainingTime: TimeInterval = 0 // 定时器剩余播放 时间
    private var timer: Timer? // 定时器
    
    // 电台id
    private(set) var radio_id: Int
    
    
    // 初始化
    init(radio_id: Int) {
        self.radio_id = radio_id
    }

    
    // 设置播放源
    func setupPlaySource() {
        guard let url = URL(string: program?.rate24_ts_url ?? "") else {
            print("url invalid")
            return
        }
        if player == nil {
            PlayerManager.manager.player = AVPlayer()
        }
        
        let item = AVPlayerItem(url: url)
        player?.replaceCurrentItem(with: item)
        if player?.timeControlStatus == .playing {
            isPlaying = true
        } else {
            isPlaying = false
        }
        setupAudioSession()
        setupRemoteTransportControls()
        updateNowPlayingInfo()
    }
    
    
    // 播放
    func play() {
        isPlaying.toggle()
        player?.play()
    }
    
    // 暂停
    func pause() {
        isPlaying.toggle()
        player?.pause()
    }
    
    // 销毁
    func stop() {
        player?.pause()
        PlayerManager.manager.player = nil
    }
    
    // 收藏当前电台
    func favoriteRadio() {
        favorite.toggle()
        
        // 更新数据
        let request = NSFetchRequest<RadioDB>(entityName: "RadioDB")
        request.predicate = NSPredicate(format: " radio_id == %ld", radio_id)
        guard let radio = try? moc.fetch(request).first else {
            return
        }
        
        radio.favorite = favorite
        try? moc.save()
    }
    
    // 随机播放
    func shuffle() {
        // 从 RadioDB表中随机数据
        let request = NSFetchRequest<RadioDB>(entityName: "RadioDB")
        request.predicate = NSPredicate(format: " radio_id != %ld", radio_id)
        guard let radios = try? moc.fetch(request),
              let radio = radios.randomElement() else {
            return
        }
        getPlayingProgramFromApi(radio_id: Int(radio.radio_id))
    }
    
    // 上一曲
    func previous() {
        let request = NSFetchRequest<RadioDB>(entityName: "RadioDB")
        guard let radios = try? moc.fetch(request) else {
            return
        }
        guard let index = radios.firstIndex(where: { $0.radio_id == radio_id }) else {
            return
        }
        if index <= 0 {
            return
        }
        let prevRadio = radios[index - 1]
        getPlayingProgramFromApi(radio_id: Int(prevRadio.radio_id))
    }
    
    // 下一曲
    func next() {
        let request = NSFetchRequest<RadioDB>(entityName: "RadioDB")
        guard let radios = try? moc.fetch(request) else {
            return
        }
        guard let index = radios.firstIndex(where: { $0.radio_id == radio_id }) else {
            return
        }
        if index >= radios.count - 1 {
            return
        }
        let prevRadio = radios[index + 1]
        getPlayingProgramFromApi(radio_id: Int(prevRadio.radio_id))
    }
    
    // 替换当前正在播放的节目
    private func replace(program: ProgramDB) {
        favorite = program.favorite
        getPlayingProgramFromApi(radio_id: Int(program.radio_id))
    }
    
    // 从接口中请求整在播放的节目
    func getPlayingProgramFromApi(radio_id: Int) {
        self.radio_id = radio_id
        XMNetwork.shared.provider.request(.get_playing_program(radio_id: radio_id)) { result in
            switch result {
            case .success(let res):
                do {
                    let programe = try JSONDecoder().decode(Program.self, from: res.data)
                    self.program = programe
                    if let radio = self.fetchRadioInfoFromDB(radio_id: radio_id) {
                        self.radioName = radio.radio_name
                        self.favorite = radio.favorite
                    }
                } catch {
                    print(error)
                }
            case .failure(let err):
                print(err)
            }
        }
    }
    
    // 从数据库中查询电台信息
    private func fetchRadioInfoFromDB(radio_id: Int) -> RadioDB? {
        let request = NSFetchRequest<RadioDB>(entityName: "RadioDB")
        request.predicate = NSPredicate(format: "radio_id == %ld", radio_id)
        let radios = try? self.moc.fetch(request)
        return radios?.first
    }

}

// MARK: 锁屏播放信息
extension PlayerViewModel {
    // 设置后台播放
    private func setupAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setActive(true)
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback, options: [])
        } catch {
            print("set AudioSession error: %@", error)
        }
    }
    
    // 设置锁屏播放
    private func setupRemoteTransportControls() {
        let commandCenter = MPRemoteCommandCenter.shared()

        commandCenter.playCommand.addTarget { _ in
            self.play()
            return .success
        }

        commandCenter.pauseCommand.addTarget { _ in
            self.pause()
            return .success
        }
    }
    
    // 更新通知栏显示
    private func updateNowPlayingInfo() {
        // download image
        guard let coverURL = URL(string: program?.back_pic_url ?? "") else {
            return
        }
        let urlRequest = URLRequest(url: coverURL)
        let session = URLSession.shared.dataTask(with: urlRequest) { data, _, _ in
            guard let data = data else {
                return
            }
            let img = UIImage(data: data)
            let nowPlayingInfo = [
                MPMediaItemPropertyTitle: self.radioName,
                MPMediaItemPropertyArtist: self.program?.program_name ?? "",
                MPMediaItemPropertyArtwork: MPMediaItemArtwork(boundsSize: img!.size, requestHandler: { _ in
                    return img!
                })
            ] as [String : Any]
            MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
        }
        session.resume()
    }
}

// MARK: Timer
extension PlayerViewModel {
    // 设置定时器(播放状态下定时器才开始)
    func setupTimer(duration: TimeInterval) {
        if isPlaying == false {
            return
        }
        self.remainingTime = duration
        DispatchQueue.global().async {
            self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: self.stopAudio(timer:))
            RunLoop.current.add(self.timer!, forMode: .default)
            RunLoop.current.run()
        }
    }
    
    private func stopAudio(timer: Timer) {
        DispatchQueue.main.async {
            if self.remainingTime > 0 {
                self.remainingTime -= 1
            } else {
                self.stop()
                timer.invalidate()
            }
        }
    }
}