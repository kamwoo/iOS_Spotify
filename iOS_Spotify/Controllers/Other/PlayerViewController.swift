//
//  PlayerViewController.swift
//  iOS_Spotify
//
//  Created by wooyeong kam on 2021/06/25.
//

import UIKit

class PlayerViewController: UIViewController {
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .systemBlue
        return imageView
    }()
    
    private let controlsView = PlayerControlsView()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        view.addSubview(imageView)
        view.addSubview(controlsView)
        configureBarButton()
        controlsView.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        imageView.frame = CGRect(x: 0,
                                 y: view.safeAreaInsets.top,
                                 width: view.width,
                                 height: view.width)
        controlsView.frame = CGRect(x: 10,
                                    y: imageView.bottom + 10,
                                    width: view.width - 20,
                                    height: view.height - imageView.height - view.safeAreaInsets.top)
    }
    
    private func configureBarButton(){
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close,
                                                           target: self,
                                                           action: #selector(didTapClose))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action,
                                                            target: self,
                                                            action: #selector(didTapAction))
        
    }
    
    @objc func didTapClose(){
        
    }
    
    @objc func didTapAction(){
        
    }

    

}


extension PlayerViewController : PlayerControlsViewDelegate {
    func PlayerControlsViewDidTapPlayPause(_ playerControlsView: PlayerControlsView) {
        <#code#>
    }
    
    func PlayerControlsViewDidTapPlayForward(_ playerControlsView: PlayerControlsView) {
        <#code#>
    }
    
    func PlayerControlsViewDidTapPlayBack(_ playerControlsView: PlayerControlsView) {
        <#code#>
    }
    
    
}
