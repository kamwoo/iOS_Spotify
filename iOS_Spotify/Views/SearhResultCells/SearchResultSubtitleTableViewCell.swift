//
//  SearchResultDefaultTableViewCell.swift
//  iOS_Spotify
//
//  Created by wooyeong kam on 2021/07/04.
//

import UIKit
import SDWebImage


class SearchResultSubtitleTableViewCell: UITableViewCell {
    static let identifier = "SearchResultSubtitleTableViewCell"
    
    private let label : UILabel = {
       let label = UILabel()
        label.numberOfLines = 1
        return label
    }()
    
    private let sublabel : UILabel = {
       let label = UILabel()
        label.numberOfLines = 1
        label.textColor = .secondaryLabel
        return label
    }()
    
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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        iconImageView.image = nil
        label.text = nil
        sublabel.text = nil
    }
    
    func configure(with viewModel: SearchResultSubtitleTableViewCellViewModel){
        label.text = viewModel.title
        sublabel.text = viewModel.subtitle
        iconImageView.sd_setImage(with: viewModel.imageURL, completed: nil)
    }
}
