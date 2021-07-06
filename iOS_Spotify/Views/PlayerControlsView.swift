//
//  PlayerControlsView.swift
//  iOS_Spotify
//
//  Created by wooyeong kam on 2021/07/04.
//

import Foundation
import UIKit

// 하단 PlayerControl의 버튼 등 액션이 발생했을 때 playerViewController로 delegate
protocol PlayerControlsViewDelegate: AnyObject {
    func PlayerControlsViewDidTapPlayPause(_ playerControlsView: PlayerControlsView)
    func PlayerControlsViewDidTapPlayForward(_ playerControlsView: PlayerControlsView)
    func PlayerControlsViewDidTapPlayBack(_ playerControlsView: PlayerControlsView)
    func PlayerControlsView(_ playerControlsView: PlayerControlsView, didSlideSlider value: Float)
}

struct PlayerControlsViewViewModel {
    let title: String?
    let subtitle: String?
}

// 재생화면 하단 컨트롤 뷰
final class PlayerControlsView: UIView {
    
    // 현재 재생되고 있는 지
    private var isPlaying = true
    
    weak var delegate: PlayerControlsViewDelegate?
    
    // 곡 재생 슬라이드 바
    private let volumeSlider: UISlider = {
       let slider = UISlider()
        slider.value = 0.5
        return slider
    }()
    
    // 곡 이름
    private let nameLabel : UILabel = {
       let label = UILabel()
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 22, weight: .semibold)
        return label
    }()
    
    // 곡 부가 설명
    private let subtitleLabel : UILabel = {
       let label = UILabel()
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 18, weight: .regular)
        return label
    }()
    
    // 이전 곡 버튼
    private let backButton: UIButton = {
       let button = UIButton()
        let image = UIImage(systemName: "backward.fill",
                            withConfiguration: UIImage.SymbolConfiguration(pointSize: 34, weight: .regular))
        button.tintColor = .label
        button.setImage(image, for: .normal)
        return button
    }()
    
    // 다음 곡 버튼
    private let forwardButton: UIButton = {
       let button = UIButton()
        let image = UIImage(systemName: "forward.fill",
                            withConfiguration: UIImage.SymbolConfiguration(pointSize: 34, weight: .regular))
        button.tintColor = .label
        button.setImage(image, for: .normal)
        return button
    }()
    
    // 곡 중지 버튼
    private let pauseButton: UIButton = {
       let button = UIButton()
        let image = UIImage(systemName: "pause.fill",
                            withConfiguration: UIImage.SymbolConfiguration(pointSize: 34, weight: .regular))
        button.tintColor = .label
        button.setImage(image, for: .normal)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        addSubview(nameLabel)
        addSubview(subtitleLabel)
        addSubview(volumeSlider)
        volumeSlider.addTarget(self, action: #selector(didSlideSlider(_:)), for: .valueChanged)
        addSubview(backButton)
        addSubview(forwardButton)
        addSubview(pauseButton)
        
        backButton.addTarget(self, action: #selector(didTapBack), for: .touchUpInside)
        forwardButton.addTarget(self, action: #selector(didTapForward), for: .touchUpInside)
        pauseButton.addTarget(self, action: #selector(didTapPause), for: .touchUpInside)
        
        clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 레이아웃 설정
    override func layoutSubviews() {
        super.layoutSubviews()
        nameLabel.frame = CGRect(x: 0, y: 0, width: width, height: 50)
        subtitleLabel.frame = CGRect(x: 0, y: nameLabel.bottom+10, width: width, height: 50)
        volumeSlider.frame = CGRect(x: 10, y: subtitleLabel.bottom + 20, width: width-20, height: 44)
        
        let buttonSize: CGFloat = 60
        pauseButton.frame = CGRect(x: (width - buttonSize)/2,
                                   y: volumeSlider.bottom + 20,
                                   width: buttonSize,
                                   height: buttonSize)
        
        backButton.frame = CGRect(x: pauseButton.left - 80 - buttonSize,
                                   y: volumeSlider.bottom + 20,
                                   width: buttonSize,
                                   height: buttonSize)
        
        forwardButton.frame = CGRect(x: pauseButton.right + 80,
                                   y: volumeSlider.bottom + 20,
                                   width: buttonSize,
                                   height: buttonSize)
    }
    
    // 뷰에서 액션을 컨트롤러에서 처리하기 위해
    // 슬라이드 바의 액션처리를 PlayerViewControlle로 delegate
    @objc func didSlideSlider(_ slider: UISlider){
        let value = slider.value
        delegate?.PlayerControlsView(self, didSlideSlider: value)
    }
    
    // 뒤로가기 버튼의 액션처리를 PlayerViewControlle로 delegate
    @objc func didTapBack(){
        delegate?.PlayerControlsViewDidTapPlayBack(self)
    }
    
    // 앞으로가기 버튼의 액션처리를 PlayerViewControlle로 delegate
    @objc func didTapForward(){
        delegate?.PlayerControlsViewDidTapPlayForward(self)
    }
   
    // 중지 버튼의 액션처리를 PlayerViewControlle로 delegate
    @objc func didTapPause(){
        self.isPlaying = !isPlaying
        delegate?.PlayerControlsViewDidTapPlayPause(self)
        let pause = UIImage(systemName: "pause.fill",
                            withConfiguration: UIImage.SymbolConfiguration(pointSize: 34, weight: .regular))
        let play = UIImage(systemName: "play.fill",
                            withConfiguration: UIImage.SymbolConfiguration(pointSize: 34, weight: .regular))
        
        pauseButton.setImage(isPlaying ? pause : play, for: .normal)
    }
    
    // PlayerViewController에서 재생될 곡의 데이터 모델 받아서 설정
    func configure(with viewModel: PlayerControlsViewViewModel){
        nameLabel.text = viewModel.title
        subtitleLabel.text = viewModel.subtitle
    }
   
}

