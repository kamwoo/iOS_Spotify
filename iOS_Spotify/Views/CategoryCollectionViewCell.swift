//
//  CategoryCollectionViewCell.swift
//  iOS_Spotify
//
//  Created by wooyeong kam on 2021/07/03.
//

import UIKit
import SDWebImage

class CategoryCollectionViewCell: UICollectionViewCell {
    static let identifier  = "CategoryCollectionViewCell"
    
    // 셀에 들어갈 카테고리 아이콘
    private let imageView : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.tintColor = .white
        imageView.image = UIImage(systemName: "music.note.list",
                                  withConfiguration: UIImage.SymbolConfiguration(pointSize: 50, weight: .regular))
        return imageView
    }()
    
    // 카테고리 이름
    private let lable: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 22, weight: .semibold)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.layer.cornerRadius = 8
        contentView.layer.masksToBounds = true
        
        contentView.addSubview(imageView)
        contentView.addSubview(lable)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 재사용할 셀 기본설정
    override func prepareForReuse() {
        super.prepareForReuse()
        lable.text = nil
        imageView.image = UIImage(systemName: "music.note.list",
                                  withConfiguration: UIImage.SymbolConfiguration(pointSize: 50, weight: .regular))
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        lable.frame = CGRect(x: 10,
                             y: contentView.height/2 + 10,
                             width: contentView.width - 20,
                             height: contentView.height/2)
//        imageView.frame = CGRect(x: contentView.width/2,
//                                 y: 0,
//                                 width: contentView.width/2,
//                                 height: contentView.height/2)
        imageView.frame = CGRect(x: 0,
                                 y: 0,
                                 width: contentView.width,
                                 height: contentView.height)
    }
    
    // search ViewContoroller에서 받은 뷰 모델 데이터
    func configure(with viewModel: CategoryCollectionViewCellViewModel ){
        lable.text = viewModel.title
        imageView.sd_setImage(with: viewModel.artWorkURL, completed: nil)
        contentView.backgroundColor = .systemBackground
    }
}
