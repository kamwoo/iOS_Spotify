//
//  PlaybackPresenter.swift
//  iOS_Spotify
//
//  Created by wooyeong kam on 2021/07/04.
//

import Foundation
import UIKit

final class PlaybackPresenter {
    static func startPlayback(from viewController: UIViewController, track: AudioTrack){
        let vc = PlayerViewController()
        vc.title = track.name
        viewController.present(UINavigationController(rootViewController:vc), animated: true, completion: nil)
    }
    
    static func startPlayback(from viewController: UIViewController, track: kamTrack){
        let vc = PlayerViewController()
        vc.title = track.name
        viewController.present(UINavigationController(rootViewController:vc), animated: true, completion: nil)
    }
    
    static func startPlayback(from viewController: UIViewController, tracks: [AudioTrack]){
        let vc = PlayerViewController()
        viewController.present(UINavigationController(rootViewController:vc), animated: true, completion: nil)
    }
    
    static func startPlayback(from viewController: UIViewController, tracks: [kamTrack]){
        let vc = PlayerViewController()
        viewController.present(UINavigationController(rootViewController:vc), animated: true, completion: nil)
    }

}
