//
//  FeaturedPlaylistCollectionViewCell.swift
//  iOS_Spotify
//
//  Created by wooyeong kam on 2021/06/28.
//

import UIKit

// 카테고리 셀 선택후 보여질 플레이리스트 CategoryView에 각 셀
class FeaturedPlaylistCollectionViewCell: UICollectionViewCell {
    static let identifier = "FeaturedPlaylistCollectionViewCell"
    
    // 플레이리스트 타이틀 이미지
    private let playlistCoverImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 8
        imageView.image = UIImage(systemName: "photo")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    // 플레이 리스트 이름
    private let playlistNameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 18, weight: .regular)
        return label
    }()

    // 만든 사람 이름
    private let creatorNameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 15, weight: .thin)
        return label
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .secondarySystemBackground
        contentView.addSubview(playlistCoverImageView)
        contentView.addSubview(playlistNameLabel)
        contentView.addSubview(creatorNameLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let imageSize = contentView.height - 70
        playlistCoverImageView.frame = CGRect(x: (contentView.width - imageSize)/2,
                                              y: 3,
                                              width: imageSize,
                                              height: imageSize)
        
        playlistNameLabel.frame = CGRect(x: 3,
                                         y: contentView.height - 70,
                                         width: contentView.width - 6,
                                         height: 60)
        
        creatorNameLabel.frame = CGRect(x: 3,
                                        y: contentView.height - 30,
                                        width: contentView.width - 6,
                                        height: 30)
        
        
    }
    
    // 재사용될 셀 기본설정
    override func prepareForReuse() {
        super.prepareForReuse()
        playlistNameLabel.text = nil
        creatorNameLabel.text = nil
        playlistCoverImageView.image = nil
    }
    
    // 해당하는 카테고리 플레이리스트를 저장
    func configure(with viewModel: FeaturedPlaylistCellViewModel){
        playlistNameLabel.text = viewModel.name
        creatorNameLabel.text = viewModel.creatorName
        playlistCoverImageView.sd_setImage(with: viewModel.artworkURL, completed: nil)
    }
}
