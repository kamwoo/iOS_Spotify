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
    
    private let imageView : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .white
        imageView.image = UIImage(systemName: "music.note.list",
                                  withConfiguration: UIImage.SymbolConfiguration(pointSize: 50, weight: .regular))
        return imageView
    }()
    
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
        contentView.addSubview(lable)
        contentView.addSubview(imageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        lable.text = nil
        imageView.image = UIImage(systemName: "music.note.list",
                                  withConfiguration: UIImage.SymbolConfiguration(pointSize: 50, weight: .regular))
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        lable.frame = CGRect(x: 10,
                             y: contentView.height/2,
                             width: contentView.width - 20,
                             height: contentView.height/2)
        imageView.frame = CGRect(x: contentView.width/2,
                                 y: 0,
                                 width: contentView.width/2,
                                 height: contentView.height/2)
    }
    
    func configure(with viewModel: CategoryCollectionViewCellViewModel ){
        lable.text = viewModel.title
        imageView.sd_setImage(with: viewModel.artWorkURL, completed: nil)
        contentView.backgroundColor = .systemBlue
    }
}
