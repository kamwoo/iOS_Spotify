//
//  AlbumViewController.swift
//  iOS_Spotify
//
//  Created by wooyeong kam on 2021/07/01.
//

import UIKit

class AlbumViewController: UIViewController {
    private var album: Album
    
    init(album: Album) {
        self.album = album
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        APICaller.shared.getAlbumDetails(for: album){ result in
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
