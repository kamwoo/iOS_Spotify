//
//  SearchResultDefaultTableViewCell.swift
//  iOS_Spotify
//
//  Created by wooyeong kam on 2021/07/04.
//

import UIKit
import SDWebImage


// album, playlist, track 섹션에서 보여질 셀 뷰
class SearchResultSubtitleTableViewCell: UITableViewCell {
    static let identifier = "SearchResultSubtitleTableViewCell"
    
    // 앨범, 노래 이름
    private let label : UILabel = {
       let label = UILabel()
        label.numberOfLines = 1
        return label
    }()
    
    // 아티스트 이름, 제작자 등 설명
    private let sublabel : UILabel = {
       let label = UILabel()
        label.numberOfLines = 1
        label.textColor = .secondaryLabel
        return label
    }()
    
    // 타이틀 이미지
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 3
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(label)
        contentView.addSubview(sublabel)
        contentView.addSubview(iconImageView)
        contentView.clipsToBounds = true
        accessoryType = .disclosureIndicator
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let imageSize: CGFloat = contentView.height - 10
        iconImageView.frame = CGRect(x: 10, y: 5, width: imageSize, height: imageSize)
        let labelHeight = contentView.height / 2
        label.frame = CGRect(x: iconImageView.right + 10,
                             y: 0,
                             width: contentView.width-iconImageView.width - 15,
                             height: labelHeight)
        sublabel.frame = CGRect(x: iconImageView.right + 10,
                                y: label.bottom,
                             width: contentView.width-iconImageView.width - 15,
                             height: labelHeight)
    }
    
    // 재사용할 셀 기본 설정
    override func prepareForReuse() {
        super.prepareForReuse()
        iconImageView.image = nil
        label.text = nil
        sublabel.text = nil
    }
    
    // 검색결과 뷰에서 해당하는 데이터 모델 받음
    func configure(with viewModel: SearchResultSubtitleTableViewCellViewModel){
        label.text = viewModel.title
        sublabel.text = viewModel.subtitle
        iconImageView.sd_setImage(with: viewModel.imageURL, completed: nil)
    }
}
