//
//  CategoryViewController.swift
//  iOS_Spotify
//
//  Created by wooyeong kam on 2021/07/03.
//

import UIKit

class CategoryViewController: UIViewController {
    private let category: category
    
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
        collectionView.register(FeaturedPlaylistCollectionViewCell.self,
                                forCellWithReuseIdentifier: FeaturedPlaylistCollectionViewCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        APICaller.shared.getCategoryPlaylists(for: category){ [weak self] result in
            DispatchQueue.main.async {
                switch result{
                case .success(let model):
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
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return playlists.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: FeaturedPlaylistCollectionViewCell.identifier,
                for: indexPath) as? FeaturedPlaylistCollectionViewCell
        else {
            return UICollectionViewCell()
        }
        let playlist = playlists[indexPath.row]
        cell.configure(with: FeaturedPlaylistCellViewModel(name: playlist.name,
                                                           artworkURL: URL(string: playlist.images.first?.url ?? ""),
                                                           creatorName: playlist.owner.display_name))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let vc = PlaylistViewController(playlist: playlists[indexPath.row])
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
