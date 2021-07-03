//
//  PlaylistViewController.swift
//  iOS_Spotify
//
//  Created by wooyeong kam on 2021/07/01.
//

import UIKit

class PlaylistViewController: UIViewController {

    private var playlist: playlist
    
    private let collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewCompositionalLayout(sectionProvider: {_, _ -> NSCollectionLayoutSection? in
            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0)
                )
            )
            item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
            // vertical group in horizontal
            
            let group = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(80)
                ),
                subitem: item,
                count: 1
            )
            // section
            let section = NSCollectionLayoutSection(group: group)
            section.boundarySupplementaryItems = [
                NSCollectionLayoutBoundarySupplementaryItem(
                    layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                       heightDimension: .fractionalWidth(1)),
                                                            
                    elementKind: UICollectionView.elementKindSectionHeader,
                                                            
                    alignment: .top)
            ]
            return section
        })
    )
    
    private var viewModels = [RecommendedTrackCellViewModel]()
    
    init(playlist: playlist) {
        self.playlist = playlist
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        view.addSubview(collectionView)
        collectionView.register(RecommendedTrackCollectionViewCell.self,
                                forCellWithReuseIdentifier: RecommendedTrackCollectionViewCell.identifier)
        collectionView.register(PlaylistHeaderCollectionReusableView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: PlaylistHeaderCollectionReusableView.identifier)
        collectionView.backgroundColor = .systemBackground
        collectionView.delegate = self
        collectionView.dataSource = self
        
        APICaller.shared.getPlaylistDetails(for: playlist){[weak self] result in
            DispatchQueue.main.async {
                switch result{
                case .success(let model):
                    self?.viewModels = model.tracks.items.compactMap({
                        RecommendedTrackCellViewModel(name: $0.track.name,
                                                      artistName: $0.track.artists.first?.name ?? "-",
                                                      artworkURL: URL(string: $0.track.album.images.first?.url ?? ""))
                    })
                    self?.collectionView.reloadData()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(didTapShare))
    }
    
    @objc func didTapShare(){
        guard let url = URL(string: playlist.external_urls["spotify"] ?? "") else {
            return
        }
        
        let vc = UIActivityViewController(activityItems: [url], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true, completion: nil)
    }


}

extension PlaylistViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: RecommendedTrackCollectionViewCell.identifier,
            for: indexPath) as? RecommendedTrackCollectionViewCell else { return UICollectionViewCell()}
        cell.configure(with: viewModels[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader,
              let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: PlaylistHeaderCollectionReusableView.identifier,
                for: indexPath) as? PlaylistHeaderCollectionReusableView
        else {
            return UICollectionReusableView()
        }
        let headerViewModel = PlaylistHeaderViewModel(name: playlist.name,
                                                      ownerName: playlist.owner.display_name,
                                                      description: playlist.description,
                                                      artworkURL: URL(string: playlist.images.first?.url ?? ""))
        
        header.configure(viewModel: headerViewModel)
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        // playsong
    }
    
}

extension PlayerViewController: PlaylistHeaderCollectionReusableViewDelegate{
    func PlaylistHeaderCollectionReusableViewDidTapPlayAll(_ header: PlaylistHeaderCollectionReusableView) {
        // 플레이리스트 재생
    }

}
