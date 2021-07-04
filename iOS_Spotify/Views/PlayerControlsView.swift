//
//  PlayerControlsView.swift
//  iOS_Spotify
//
//  Created by wooyeong kam on 2021/07/04.
//

import Foundation
import UIKit

protocol PlayerControlsViewDelegate: AnyObject {
    func PlayerControlsViewDidTapPlayPause(_ playerControlsView: PlayerControlsView)
    func PlayerControlsViewDidTapPlayForward(_ playerControlsView: PlayerControlsView)
    func PlayerControlsViewDidTapPlayBack(_ playerControlsView: PlayerControlsView)
}

final class PlayerControlsView: UIView {
    
    weak var delegate: PlayerControlsViewDelegate?
    
    private let volumeSlider: UISlider = {
       let slider = UISlider()
        slider.value = 0.5
        return slider
    }()
    
    private let nameLabel : UILabel = {
       let label = UILabel()
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 22, weight: .semibold)
        return label
    }()
    
    private let subtitleLabel : UILabel = {
       let label = UILabel()
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 18, weight: .regular)
        return label
    }()
    
    private let backButton: UIButton = {
       let button = UIButton()
        let image = UIImage(systemName: "backward.fill",
                            withConfiguration: UIImage.SymbolConfiguration(pointSize: 34, weight: .regular))
        button.tintColor = .label
        button.setImage(image, for: .normal)
        return button
    }()
    
    private let forwardButton: UIButton = {
       let button = UIButton()
        let image = UIImage(systemName: "forward.fill",
                            withConfiguration: UIImage.SymbolConfiguration(pointSize: 34, weight: .regular))
        button.tintColor = .label
        button.setImage(image, for: .normal)
        return button
    }()
    
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
    
    
    @objc func didTapBack(){
        delegate?.PlayerControlsViewDidTapPlayBack(self)
    }
    
    @objc func didTapForward(){
        delegate?.PlayerControlsViewDidTapPlayForward(self)
    }
   
    @objc func didTapPause(){
        delegate?.PlayerControlsViewDidTapPlayPause(self)
    }
   
}

