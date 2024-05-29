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
    @Published var favorite: Bool = false
    // 封面图
    @Published private(set) var coverURL: URL?
    // 节目名称
    @Published private(set) var programName: String
    // 电台名称
    @Published private(set) var radioName: String?
    // 播放链接
    private(set) var playURLPath: String
    // 当前正在播放的节目
    @Published private(set) var program: Program?
    
    private var player: AVPlayer? { PlayerManager.manager.player }
    let times: [TimeInterval] = [5, 15, 30, 60, 120] // 定时时长
    @Published private(set) var remainingTime: TimeInterval = 0 // 定时器剩余播放 时间
    private var timer: Timer? // 定时器
    private var radioDB: RadioDB? // 数据库对象
    
    // 电台id
    private(set) var radio_id: Int
    
    
    // 初始化
    init(radio_id: Int) {
        self.radio_id = radio_id
        programName = ""
        playURLPath = ""
    }

    
    // 设置播放源
    func setupPlaySource() {
        guard let url = URL(string: playURLPath) else {
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
    
    // 获取数据库中的对象（没有就创建新的）
    private func getRadioDB() {
        let request = NSFetchRequest<RadioDB>(entityName: "RadioDB")
        request.predicate = NSPredicate(format: "radio_id == %ld", radio_id)
        let result = try? moc.fetch(request)
        if result?.count == 0 {
            guard let radio = NSEntityDescription.insertNewObject(forEntityName: "RadioDB", into: moc) as? RadioDB else {
                return
            }
            radio.radio_id = Int16(radio_id)
            radio.radio_cover = coverURL?.absoluteString ?? ""
            radio.program_name = programName
            radio.radio_urlPath = playURLPath
            radio.favorite = favorite
            radio.create_at = Date()
            radio.radio_name = radioName
            self.radioDB = radio
        } else {
            self.radioDB = result?.first
            favorite = result?.first?.favorite ?? false
        }
    }
    
    // 获取数据库对象
    private func getProgramDB() -> ProgramDB? {
        guard let program = program else {
            return nil
        }
        let request = NSFetchRequest<ProgramDB>(entityName: "ProgramDB")
        request.predicate = NSPredicate(format: "radio_id == %ld && program_id == %ld", radio_id, program.id)
        let result = try? moc.fetch(request)
        if result?.count == 0 {
            guard let programDB = NSEntityDescription.insertNewObject(forEntityName: "ProgramDB", into: moc) as? ProgramDB else {
                return nil
            }
            programDB.created_at = Date()
            programDB.radio_id = Int16(radio_id)
            programDB.program_id = Int16(program.id)
            programDB.favorite = false
            return programDB
        } else {
            return result?.first
        }
    }
    
    // 更新数据状态并保持到数据库中
    func updateDBData() {
        guard let program = program,
              let programDB = getProgramDB() else {
            return
        }
        programDB.favorite = favorite
        programDB.program_name = program.program_name
        programDB.back_pic_url = program.back_pic_url
        programDB.rate_url = program.rate24_ts_url
        programDB.updated_at = Int64(program.updated_at)
        
        if !moc.hasChanges {
            return
        }
        do {
            try moc.save()
        } catch {
            moc.rollback()
        }
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
    
    // 随机播放
    func shuffle() {
        guard let program = program else {
            return
        }
        let request = NSFetchRequest<ProgramDB>(entityName: "ProgramDB")
        request.predicate = NSPredicate(format: "program_id != %ld", program.id)
        guard let programs = try? moc.fetch(request),
              let program = programs.randomElement() else {
            return
        }
        replace(program: program)
    }
    
    // 上一曲
    func previous() {
        guard let program = program else {
            return
        }
        let request = NSFetchRequest<ProgramDB>(entityName: "ProgramDB")
        guard let programs = try? moc.fetch(request) else {
            return
        }
        guard let index = programs.firstIndex(where: { $0.program_id == program.id }) else {
            return
        }
        if index <= 0 {
            return
        }
        let prevPro = programs[index - 1]
        replace(program: prevPro)
    }
    
    // 下一曲
    func next() {
        guard let program = program else {
            return
        }
        let request = NSFetchRequest<ProgramDB>(entityName: "ProgramDB")
        guard let programs = try? moc.fetch(request) else {
            return
        }
        guard let index = programs.firstIndex(where: { $0.program_id == program.id }) else {
            return
        }
        if index >= programs.count - 1 {
            return
        }
        let nextPro = programs[index + 1]
        replace(program: nextPro)
    }
    
    // 替换当前正在播放的节目
    private func replace(program: ProgramDB) {
        favorite = program.favorite
        getPlayingProgramFromApi(radio_id: Int(program.radio_id))
    }
    
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
        guard let coverURL = coverURL else {
            return
        }
        let urlRequest = URLRequest(url: coverURL)
        let session = URLSession.shared.dataTask(with: urlRequest) { data, _, _ in
            guard let data = data else {
                return
            }
            let img = UIImage(data: data)
            let nowPlayingInfo = [
                MPMediaItemPropertyTitle: self.radioName ?? "",
                MPMediaItemPropertyArtist: self.programName,
                MPMediaItemPropertyArtwork: MPMediaItemArtwork(boundsSize: img!.size, requestHandler: { _ in
                    return img!
                })
            ] as [String : Any]
            MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
        }
        session.resume()
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
                    self.programName = programe.program_name
                    self.coverURL = URL(string: programe.back_pic_url)
                    self.playURLPath = programe.rate24_ts_url
                    self.setupPlaySource()
                } catch {
                    print(error)
                }
            case .failure(let err):
                print(err)
            }
        }
    }
    
    // 从数据库中获取节目
    private func getProgramFromDB(radio_id: Int) -> ProgramDB? {
        let request = NSFetchRequest<ProgramDB>(entityName: "ProgramDB")
        request.predicate = NSPredicate(format: "radio_id == %ld", radio_id)
        let result = try? moc.fetch(request)
        if result?.count == 0 {
            guard let program = NSEntityDescription.insertNewObject(forEntityName: "ProgramDB", into: moc) as? ProgramDB else {
                return nil
            }
            program.radio_id = Int16(radio_id)
            program.created_at = Date()
            program.favorite = false
            return program
        } else {
            return result?.first
        }
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
