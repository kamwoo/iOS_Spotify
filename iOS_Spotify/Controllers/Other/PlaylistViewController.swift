//
//  PlaylistViewController.swift
//  iOS_Spotify
//
//  Created by wooyeong kam on 2021/07/01.
//

import UIKit

class PlaylistViewController: UIViewController {

    private var playlist: playlist
    
    init(playlist: playlist) {
        self.playlist = playlist
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blue
        APICaller.shared.getPlaylistDetails(for: playlist){ result in
            DispatchQueue.main.async {
                switch result{
                case .success(let data):
                    break
                case .failure(let error):
                    break
                }
            }
            
        }
    }


}
