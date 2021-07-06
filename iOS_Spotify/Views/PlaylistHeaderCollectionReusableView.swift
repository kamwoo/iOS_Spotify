//
//  PlaylistHeaderCollectionReusableView.swift
//  iOS_Spotify
//
//  Created by wooyeong kam on 2021/07/01.
//

import UIKit

protocol PlaylistHeaderCollectionReusableViewDelegate: AnyObject {
    func PlaylistHeaderCollectionReusableViewDidTapPlayAll(_ header: PlaylistHeaderCollectionReusableView)
}

final class PlaylistHeaderCollectionReusableView: UICollectionReusableView {
    static let identifier = "PlaylistHeaderCollectionReusableView"
    
    weak var delegate: PlaylistHeaderCollectionReusableViewDelegate?
    
    // 앨범 타이틀 이미지
    private let imageView: UIImageView = {
       let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(systemName: "photo")
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 10
        return imageView
    }()
    
    // 앨범 이름
    private let nameLabel : UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 22, weight: .semibold)
        return label
    }()
    
    // 앨범 설명, 지금은 날짜만
    private let descriptionLabel : UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 18, weight: .regular)
        return label
    }()
    
    // 앨범 주인
    private let ownerLabel : UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 18, weight: .light)
        return label
    }()
    
    // 전체 재생 버튼
    private let playAllButton: UIButton = {
       let button = UIButton()
        button.backgroundColor = .systemGreen
        let image = UIImage(systemName: "play.fill", withConfiguration: UIImage.SymbolConfiguration(
                                pointSize: 30, weight: .regular))
        button.setImage(image, for: .normal)
        button.tintColor = .white
        button.layer.cornerRadius = 30
        button.layer.masksToBounds = true
        return button
    }()
    
    // 초기화 및 각 뷰 세팅
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        addSubview(nameLabel)
        addSubview(descriptionLabel)
        addSubview(ownerLabel)
        addSubview(imageView)
        addSubview(playAllButton)
        playAllButton.addTarget(self, action: #selector(didTapPlayAll), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // 각 뷰 레이아웃 설정
    override func layoutSubviews() {
        super.layoutSubviews()
        let imageSize: CGFloat = height/1.8
        imageView.frame = CGRect(x: (width-imageSize)/2, y: 20, width: imageSize, height: imageSize)
        nameLabel.frame = CGRect(x: 10, y: imageView.bottom, width: width-20, height: 44)
        descriptionLabel.frame = CGRect(x: 10, y: nameLabel.bottom, width: width-20, height: 44)
        ownerLabel.frame = CGRect(x: 10, y: descriptionLabel.bottom, width: width-20, height: 44)
        playAllButton.frame = CGRect(x: width-80, y: height-80, width: 60, height: 60)
        
    }
    
    // 전체 재생 버튼이 클릭 되었을 때,
    // delegate 되있는 AlbumViewController, PlaylistViewController에서 음악 재생 화면 띄움
    @objc private func didTapPlayAll(){
        delegate?.PlaylistHeaderCollectionReusableViewDidTapPlayAll(self)
    }
    
    
    func configure(viewModel: PlaylistHeaderViewModel){
        guard let owner = viewModel.ownerName else {
            return
        }
        nameLabel.text = viewModel.name
        descriptionLabel.text = viewModel.description
        ownerLabel.text = "by \(owner)"
        imageView.sd_setImage(with: viewModel.artworkURL, completed: nil)
    }
}
