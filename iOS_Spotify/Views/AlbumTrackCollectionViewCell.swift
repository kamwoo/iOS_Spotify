//
//  RecommendedTrackCollectionViewCell.swift
//  iOS_Spotify
//
//  Created by wooyeong kam on 2021/06/28.
//

import UIKit

class AlbumTrackCollectionViewCell: UICollectionViewCell {
    static let identifier = "AlbumTrackCollectionViewCell"
    
    // 재생할 음악 리스트 각 셀에 곡 제목
    private let playlistNameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 18, weight: .regular)
        return label
    }()
    
    // 재생할 음악 리스트 각 셀에 아티스트 이름
    private let artistNameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 15, weight: .thin)
        return label
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .secondarySystemBackground
        contentView.addSubview(playlistNameLabel)
        contentView.addSubview(artistNameLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    
        playlistNameLabel.frame = CGRect(x: 10,
                                         y: 0,
                                         width: contentView.width - 15,
                                         height: contentView.height / 2)
        artistNameLabel.frame = CGRect(x: 10,
                                       y: contentView.height / 2,
                                       width: contentView.width - 15,
                                       height: contentView.height / 2)
        
    }
    
    // 화면에 보여질 셀에 대해서만 설정하고 스크롤 될때 셀을 재사용한다.
    override func prepareForReuse() {
        super.prepareForReuse()
        playlistNameLabel.text = nil
        artistNameLabel.text = nil
    }
    
    
    func configure(with viewModel: AlbumCollectionViewCellViewModel){
        playlistNameLabel.text = viewModel.name
        artistNameLabel.text = viewModel.artistName
    }
}
