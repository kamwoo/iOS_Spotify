//
//  NewReleaseCollectionViewCell.swift
//  iOS_Spotify
//
//  Created by wooyeong kam on 2021/06/28.
//

import UIKit
import SDWebImage

// 홈 뷰에 최신 앨범 셀 뷰
class NewReleaseCollectionViewCell: UICollectionViewCell {
    static let identifier = "NewReleaseCollectionViewCell"
    
    // 앨범 타이틀 이미지
    private let albumCoverImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "photo")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    // 앨범 이미지
    private let albumNameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 22, weight: .semibold)
        return label
    }()
    
    // 앨범 곡수
    private let numberOfTracksLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 12, weight: .light)
        return label
    }()
    
    // 아티스트 이름
    private let artistNameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 18, weight: .regular)
        return label
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .secondarySystemBackground
        contentView.addSubview(albumCoverImageView)
        contentView.addSubview(albumNameLabel)
        contentView.addSubview(numberOfTracksLabel)
        contentView.addSubview(artistNameLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        albumNameLabel.sizeToFit()
        numberOfTracksLabel.sizeToFit()
        artistNameLabel.sizeToFit()
        let imageSize: CGFloat = contentView.height - 10
        albumCoverImageView.frame = CGRect(x: 5, y: 5, width: imageSize, height: imageSize)
        albumNameLabel.frame = CGRect(x: albumCoverImageView.right + 10,
                                           y: 5,
                                           width: contentView.width - albumCoverImageView.width - 20,
                                           height: 40)
        artistNameLabel.frame = CGRect(x: albumCoverImageView.right + 10,
                                       y: albumNameLabel.bottom + 10,
                                       width: albumNameLabel.width,
                                       height: artistNameLabel.height)
        numberOfTracksLabel.frame = CGRect(x: albumCoverImageView.right + 10,
                                           y: contentView.bottom - 40,
                                           width: contentView.width - albumCoverImageView.width - 20,
                                           height: 44)
        
        
    }
    
    // 재사용할 셀 기본 설정
    override func prepareForReuse() {
        super.prepareForReuse()
        albumNameLabel.text = nil
        artistNameLabel.text = nil
        numberOfTracksLabel.text = nil
        albumCoverImageView.image = nil
    }
    
    // 해당하는 앨범의 데이터 받음
    func configure(with viewModel: NewReleasesCellViewModel){
        albumNameLabel.text = viewModel.name
        artistNameLabel.text = viewModel.artistName
        numberOfTracksLabel.text = "Tracks: \(viewModel.numberOfTracks)"
        albumCoverImageView.sd_setImage(with: viewModel.artworkURL, completed: nil)
    }
}
