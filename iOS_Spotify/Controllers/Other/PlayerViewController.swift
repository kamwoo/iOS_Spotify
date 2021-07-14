//
//  PlayerViewController.swift
//  iOS_Spotify
//
//  Created by wooyeong kam on 2021/06/25.
//

import UIKit
import SDWebImage

// 버튼 클릭 액션처리를 PlaybackPresenter로 delegate
protocol PlayerViewControllerDelegate: AnyObject{
    func didTapPlayPause()
    func didTapForward()
    func didTapBackward()
    func didSlideSlider(_ value: Float)
}

// 재생화면 뷰 컨트롤러
class PlayerViewController: UIViewController {
    
    weak var dataSource: PlayerDataSource?
    weak var delegate: PlayerViewControllerDelegate?
    
    // 재생할려는 곡 타이틀 이미지
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    // 하단 곡 이름, 버튼, 슬리이드 들어가는 뷰
    private let controlsView = iOS_Spotify.PlayerControlsView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(imageView)
        view.addSubview(controlsView)
        configureBarButton()
        controlsView.delegate = self
        configure()
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
    
    private func configure(){
        // 상단 타이틀 이미지
        imageView.sd_setImage(with: dataSource?.imageURL, completed: nil)
        // 하단 컨트롤 뷰에 곡 이름과, 곡 설명 뷰 모델로 전달
        controlsView.configure(with: PlayerControlsViewViewModel(title: dataSource?.songName, subtitle: dataSource?.subtitle))
    }
    
    // 상단 닫힘 버튼과 공유 버튼
    private func configureBarButton(){
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close,
                                                           target: self,
                                                           action: #selector(didTapClose))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action,
                                                            target: self,
                                                            action: #selector(didTapAction))
        
    }
    
    @objc func didTapClose(){
        dismiss(animated: true, completion: nil)
    }
    
    @objc func didTapAction(){

    }
    
    func refreshUI(){
        configure()
    }


}

// PlayerControlsView으로부터 액션 처리를 PlaybackPresenter로 delegate, 노래 재생을 컨트롤 하는 것은 PlaybackPresenter
extension PlayerViewController : PlayerControlsViewDelegate {
    func PlayerControlsView(_ playerControlsView: PlayerControlsView, didSlideSlider value: Float) {
        delegate?.didSlideSlider(value)
    }
    
    func PlayerControlsViewDidTapPlayPause(_ playerControlsView: PlayerControlsView) {
        delegate?.didTapPlayPause()
    }
    
    func PlayerControlsViewDidTapPlayForward(_ playerControlsView: PlayerControlsView) {
        delegate?.didTapForward()
    }
    
    func PlayerControlsViewDidTapPlayBack(_ playerControlsView: PlayerControlsView) {
        delegate?.didTapBackward()
    }
    
    
}
