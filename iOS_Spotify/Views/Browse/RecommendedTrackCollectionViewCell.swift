//
//  RecommendedTrackCollectionViewCell.swift
//  iOS_Spotify
//
//  Created by wooyeong kam on 2021/06/28.
//

import UIKit

class RecommendedTrackCollectionViewCell: UICollectionViewCell {
    static let identifier = "RecommendedTrackCollectionViewCell"
    
    // 플레이 리스트 셀에 곡 타이틀 이미지
    private let playlistCoverImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 4
        imageView.image = UIImage(systemName: "photo")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    // 곡 이름
    private let playlistNameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 18, weight: .regular)
        return label
    }()

    // 아티스트 이름
    private let artistNameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 15, weight: .thin)
        return label
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .secondarySystemBackground
        contentView.addSubview(playlistCoverImageView)
        contentView.addSubview(playlistNameLabel)
        contentView.addSubview(artistNameLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 셀 layout 설정
    override func layoutSubviews() {
        super.layoutSubviews()
        let imageSize = contentView.height - 4
        playlistCoverImageView.frame = CGRect(x: 5, y: 2, width: imageSize, height: imageSize)
        playlistNameLabel.frame = CGRect(x: playlistCoverImageView.right + 10,
                                         y: 0, width: contentView.width - playlistCoverImageView.right - 15,
                                         height: contentView.height / 2)
        artistNameLabel.frame = CGRect(x: playlistCoverImageView.right + 10,
                                       y: contentView.height / 2,
                                       width: contentView.width - playlistCoverImageView.right - 15,
                                       height: contentView.height / 2)
        
    }
    
    // 재사용될 셀 설정
    override func prepareForReuse() {
        super.prepareForReuse()
        playlistNameLabel.text = nil
        artistNameLabel.text = nil
        playlistCoverImageView.image = nil
    }
    
    // 해당하는 각 곡들의 데이터 모델
    func configure(with viewModel: RecommendedTrackCellViewModel){
        playlistNameLabel.text = viewModel.name
        artistNameLabel.text = viewModel.artistName
        playlistCoverImageView.sd_setImage(with: viewModel.artworkURL, completed: nil)
    }
}
