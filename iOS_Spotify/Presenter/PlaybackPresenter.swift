//
//  PlaybackPresenter.shared.swift
//  iOS_Spotify
//
//  Created by wooyeong kam on 2021/07/04.
//

import AVFoundation
import Foundation
import UIKit

// PlaybackPresenter의 startPlayback함수가 호출되면서 받은 track의 정보를 PlayerViewController에 전달
protocol PlayerDataSource: AnyObject {
    var songName: String? {get}
    var subtitle: String? {get}
    var imageURL: URL? {get}
}


// 하나의 곡 재생과 전체 곡 재생을 띄움, PlayerViewController로 연결
final class PlaybackPresenter {
    // 싱글톤
    static let shared = PlaybackPresenter()
    
    // 곡 하나가 재생될 때와 전체 재생 버튼이 클릭 되었을 때를 처리
    private var track: AudioTrack?
    private var tracks = [AudioTrack]()
    
    var index = 0
    
    var player: AVPlayer?
    var playerQueue: AVQueuePlayer?
    
    
    var currentTrack: AudioTrack? {
        // 곡 하나가 들어왔을 때 현재 트랙으로 곡 하나 반환
        if let track = track, tracks.isEmpty{
            return track
        // 곡 트랙이 들어왔을 때 현재 트랙으로 들어온 트랙의 재생곡으로 첫번째 반환
        }else if let player = self.playerQueue, !tracks.isEmpty{
            return tracks[index]
        }
        return nil
    }
    
    var playerVC: PlayerViewController?
    
    func startPlayback(from viewController: UIViewController, track: AudioTrack){
        // 곡 하나가 들어왔을 때
        self.track = track
        self.tracks = []
      
        guard let url = URL(string: track.preview_url ?? "") else {
            print("error")
            return
        }
        // 해당하는 url로 player 선언
        player = AVPlayer(url: url)
        player?.volume = 0.0
        
        let vc = PlayerViewController()
        vc.title = track.name
        vc.dataSource = self
        vc.delegate = self
        // PlayerViewController를 띄우고 해당하는 URL로 재생
        viewController.present(UINavigationController(rootViewController:vc), animated: true) { [weak self]  in
            self?.player?.play()
        }
        self.playerVC = vc
    }

    
    func startPlayback(from viewController: UIViewController, tracks: [AudioTrack]){
        // 재생 목록이 들어왔을 때
        self.tracks = tracks
        self.track = nil
    
        self.playerQueue = AVQueuePlayer(items: tracks.compactMap({
            guard let url = URL(string: $0.preview_url ?? "") else {
                return nil
            }
            return AVPlayerItem(url: url)
        })
        )
        self.playerQueue?.volume = 0.0
        self.playerQueue?.play()
        
        let vc = PlayerViewController()
        vc.dataSource = self
        vc.delegate = self
        viewController.present(UINavigationController(rootViewController:vc), animated: true, completion: nil)
        self.playerVC = vc
    }
    

}

// slider, forward, back, pause 버튼의 액션 처리
extension PlaybackPresenter: PlayerViewControllerDelegate {
    func didSlideSlider(_ value: Float) {
        player?.volume = value
    }
    
    // 멈춤 버튼이 클릭 되었을 때
    func didTapPlayPause() {
        if let player = player{
            if player.timeControlStatus == .playing{
                player.pause()
            }
            else if player.timeControlStatus == .paused{
                player.play()
            }
        }
        else if let player = playerQueue{
            if player.timeControlStatus == .playing{
                player.pause()
            }
            else if player.timeControlStatus == .paused{
                player.play()
            }
        }
    }
    
    // 다음 곡으로 넘김 버튼이 클릭 되었을 때
    func didTapForward() {
        // 곡이 비었으면 중지
        if tracks.isEmpty{
            player?.pause()
        }
        else if let player = playerQueue {
            player.advanceToNextItem()
            index += 1
            print(index)
            playerVC?.refreshUI()
        }
    }
    
     func didTapBackward() {
        if tracks.isEmpty{
            player?.pause()
            player?.play()
        }
        else if let firstItem = playerQueue?.items().first {
            playerQueue?.pause()
            playerQueue?.removeAllItems()
            playerQueue = AVQueuePlayer(items: [firstItem])
            playerQueue?.play()
            playerQueue?.volume = 0
        }
    }
    
    
}

// PlayerViewController에 데이터 전달
extension PlaybackPresenter: PlayerDataSource{
    var songName: String? {
        return currentTrack?.name
    }
    
    var subtitle: String? {
        return currentTrack?.artists.first?.name
    }
    
    var imageURL: URL? {
        return URL(string: currentTrack?.album?.images.first?.url ?? "")
    }
    
    
}
