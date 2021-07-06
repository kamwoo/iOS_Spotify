//
//  TitleHeaderCollectionReusableView.swift
//  iOS_Spotify
//
//  Created by wooyeong kam on 2021/07/03.
//

import UIKit

class TitleHeaderCollectionReusableView: UICollectionReusableView {
    static let identifier = "TitleHeaderCollectionReusableView"
    
    // 최신 음악, 추천 플레이리스트, 추천 트랙이 적힐 섹션해더의 라벨 설정
    private let label: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 18, weight: .regular)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        addSubview(label)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        label.frame = CGRect(x: 15, y: 0, width: width-30, height: height)
    }
    
    func cofigure(with title: String){
        label.text = title
    }
}
