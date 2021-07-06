//
//  CategoryViewController.swift
//  iOS_Spotify
//
//  Created by wooyeong kam on 2021/07/03.
//

import UIKit

// 카테고리 셀이 선택되고 보여질 뷰
class CategoryViewController: UIViewController {
    private let category: category
    
    // 한 줄에 2개의 셀 씩 layout 설정
    private let collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewCompositionalLayout(sectionProvider: {_,_ -> NSCollectionLayoutSection? in
            let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(
                                                widthDimension: .fractionalWidth(1),
                                                heightDimension: .fractionalHeight(1)))
            item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
            
            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                   heightDimension: .absolute(250)),
                subitem: item,
                count: 2
            )
            group.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
            
            return NSCollectionLayoutSection(group: group)
        })
    )
    
    private var playlists = [playlist]()
    
    // 선택된 카테고리로 초기화
    init(category: category) {
        self.category = category
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = category.name
        view.backgroundColor = .systemBackground
        view.addSubview(collectionView)
        collectionView.backgroundColor = .systemBackground
        
        // 각 셀 뷰 등록
        collectionView.register(FeaturedPlaylistCollectionViewCell.self,
                                forCellWithReuseIdentifier: FeaturedPlaylistCollectionViewCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        // 해당하는 카테고리의 플레이리스트(소분류)를 request
        APICaller.shared.getCategoryPlaylists(for: category){ [weak self] result in
            DispatchQueue.main.async {
                switch result{
                case .success(let model):
                    // 리턴 받은 플레이리스트 저장
                    self?.playlists = model
                    self?.collectionView.reloadData()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }


}

extension CategoryViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    // 플레이리스트 개수만큼 셀 생성
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return playlists.count
    }
    
    // 각 셀 설정
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: FeaturedPlaylistCollectionViewCell.identifier,
                for: indexPath) as? FeaturedPlaylistCollectionViewCell
        else {
            return UICollectionViewCell()
        }
        // 선택된 인덱스에 맞는 플레이리스트 데이터로
        let playlist = playlists[indexPath.row]
        // 각 셀 뷰에 데이터 모델 넘김
        cell.configure(with: FeaturedPlaylistCellViewModel(name: playlist.name,
                                                           artworkURL: URL(string: playlist.images.first?.url ?? ""),
                                                           creatorName: playlist.owner.display_name))
        return cell
    }
    
    // 각 셀이 선택되었을 때 PlaylistViewController로 전환
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let vc = PlaylistViewController(playlist: playlists[indexPath.row])
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
