//
//  ViewController.swift
//  iOS_Spotify
//
//  Created by wooyeong kam on 2021/06/25.
//

import UIKit

enum BrowseSectionType {
    case newReleases(viewModels: [NewReleasesCellViewModel])
    case featuredPlaylists(viewModels: [FeaturedPlaylistCellViewModel])
    case recommendedTracks(viewModels: [RecommendedTrackCellViewModel])
    
    var title: String{
        switch self {
        case .newReleases:
            return "최신 앨범"
        case .featuredPlaylists:
            return "추천 플레이리스트"
        case .recommendedTracks:
            return "추천 트랙"
        }
    }
}

class HomeViewController: UIViewController {
    
    private var newAlbums: [Album] = []
    private var playlists: [playlist] = []
    private var tracks: [AudioTrack] = []
    
    private var collectionView : UICollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewCompositionalLayout{ sectionIndex, _ -> NSCollectionLayoutSection? in
            return HomeViewController.createSectionLayout(section: sectionIndex)
        }
    )
    
    private let spinner: UIActivityIndicatorView = {
       let spinner = UIActivityIndicatorView()
        spinner.tintColor = .label
        spinner.hidesWhenStopped = true
        return spinner
    }()
    
    private var sections = [BrowseSectionType]()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "gearshape"),
            style: .done,
            target: self,
            action: #selector(didTapSettings))
        view.addSubview(spinner)
        configureCollectionView()
        fetchData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
        collectionView.backgroundColor = .systemBackground
    }
    
    // 콜렉션 뷰 설정
    private func configureCollectionView(){
        view.addSubview(collectionView)
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.register(NewReleaseCollectionViewCell.self,
                                forCellWithReuseIdentifier: NewReleaseCollectionViewCell.identifier)
        collectionView.register(FeaturedPlaylistCollectionViewCell.self,
                                forCellWithReuseIdentifier: FeaturedPlaylistCollectionViewCell.identifier)
        collectionView.register(RecommendedTrackCollectionViewCell.self,
                                forCellWithReuseIdentifier: RecommendedTrackCollectionViewCell.identifier)
        collectionView.register(TitleHeaderCollectionReusableView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: TitleHeaderCollectionReusableView.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    private static func createSectionLayout(section: Int) -> NSCollectionLayoutSection{
        let supplementaryViews = [
            NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                   heightDimension: .absolute(50)
                ),
                                                        
                elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .top)
        ]
        
        switch section {
        case 0:
            // item
            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0)
                )
            )
            item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
            // vertical group in horizontal
            let verticalGroup = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(390)
                ),
                subitem: item,
                count: 3
            )
            
            let horizontalGroup = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(390)
                ),
                subitem: verticalGroup,
                count: 1
            )
            // section
            let section = NSCollectionLayoutSection(group: horizontalGroup)
            section.orthogonalScrollingBehavior = .groupPaging
            section.boundarySupplementaryItems = supplementaryViews
            return section
        
        case 1:
            // item
            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0)
                )
            )
            item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
            // vertical group in horizontal
            let verticalGroup = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(widthDimension: .absolute(200), heightDimension: .absolute(400)
                ),
                subitem: item,
                count: 2
            )
            
            let horizontalGroup = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(widthDimension: .absolute(200), heightDimension: .absolute(400)
                ),
                subitem: verticalGroup,
                count: 1
            )
            // section
            let section = NSCollectionLayoutSection(group: horizontalGroup)
            section.orthogonalScrollingBehavior = .groupPaging
            section.boundarySupplementaryItems = supplementaryViews
            return section
            
        case 2:
            // item
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
            section.boundarySupplementaryItems = supplementaryViews
            return section
            
        default:
            // item
            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0)
                )
            )
            item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
    
            let Group = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(390)
                ),
                subitem: item,
                count: 1
            )
            
            // section
            let section = NSCollectionLayoutSection(group: Group)
            section.boundarySupplementaryItems = supplementaryViews
            return section
        }
    }
    
    // api호출
    private func fetchData(){
        let group = DispatchGroup()
        group.enter()
        group.enter()
        group.enter()
        
        var newReleases: NewReleasesResponse?
        var featurePlaylists: FeaturedPlaylistsResponse?
        var recommendations: RecommendationsResponse?
        
        APICaller.shared.getNewRelease{ result in
            defer {
                group.leave()
            }
            switch result{
            case .success(let model):
                newReleases = model
            case .failure(let error):
                print(error.localizedDescription)
            }
        }

        APICaller.shared.getFeaturePlaylist{ result in
            defer {
                group.leave()
            }
            switch result{
            case .success(let model):
                featurePlaylists = model
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
        APICaller.shared.getRecommendedGenres{ result in
            switch result{
            case .success(let model):
                let genrs = model.genres
                var seeds = Set<String>()
                while seeds.count < 5 {
                    if let random = genrs.randomElement(){
                        seeds.insert(random)
                    }
                }
                APICaller.shared.getRecommendations(genres: seeds){ recommendedResult in
                    defer {
                        group.leave()
                    }
                    switch recommendedResult {
                    case .success(let model):
                        recommendations = model
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }

            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
        group.notify(queue: .main){
            guard let newAlbums = newReleases?.albums.items,
                  let playlist = featurePlaylists?.playlists.items,
                  let tracks = recommendations?.tracks else {
                return
            }
            self.configureModels(newAlbums: newAlbums, playlists: playlist, tracks: tracks)
        }
        
    }
    
    
    private func configureModels(newAlbums: [Album], playlists: [playlist], tracks: [AudioTrack]){
        self.newAlbums = newAlbums
        self.playlists = playlists
        self.tracks = tracks
        
        // configure Model
        sections.append(.newReleases(viewModels: newAlbums.compactMap({
                return NewReleasesCellViewModel(
                    name: $0.name,
                    artworkURL: URL(string: $0.images.first?.url ?? ""),
                    numberOfTracks: $0.total_tracks,
                    artistName: $0.artists.first?.name ?? "")
            })
        ))
        sections.append(.featuredPlaylists(viewModels: playlists.compactMap({
            return FeaturedPlaylistCellViewModel(
                name: $0.name,
                artworkURL: URL(string: $0.images.first?.url ?? ""),
                creatorName: $0.owner.display_name)
            })
        ))
        sections.append(.recommendedTracks(viewModels: tracks.compactMap({
            return RecommendedTrackCellViewModel(
                name: $0.name,
                artistName: $0.artists.first?.name ?? "",
                artworkURL: URL(string: $0.album.images.first?.url ?? ""))
            })
        ))
        collectionView.reloadData()
    }
    
    // 세팅 뷰로 전환
    @objc func didTapSettings(){
        let vc = SettingViewController()
        vc.title = "Setting"
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    

}

// 홈 뷰 테이블
extension HomeViewController : UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let type = sections[section]
        switch type{
        case .newReleases(let viewModels):
            return viewModels.count
        case .featuredPlaylists(let viewModels):
            return viewModels.count
        case .recommendedTracks(let viewModels):
            return viewModels.count
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let type = sections[indexPath.section]
        
        switch type{
        case .newReleases(let viewModels):
            guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: NewReleaseCollectionViewCell.identifier,
                    for: indexPath) as? NewReleaseCollectionViewCell else {
                return UICollectionViewCell()
            }
            let viewModel = viewModels[indexPath.row]
            cell.configure(with: viewModel)
            return cell
            
        case .featuredPlaylists(let viewModels):
            guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: FeaturedPlaylistCollectionViewCell.identifier,
                    for: indexPath) as? FeaturedPlaylistCollectionViewCell else {
                return UICollectionViewCell()
            }
            
            cell.configure(with: viewModels[indexPath.row])
            return cell
            
        case .recommendedTracks(let viewModels):
            guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: RecommendedTrackCollectionViewCell.identifier,
                    for: indexPath) as? RecommendedTrackCollectionViewCell else {
                return UICollectionViewCell()
            }
            cell.configure(with: viewModels[indexPath.row])
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let section = sections[indexPath.section]
        switch section {
        case .featuredPlaylists:
            let playlist = playlists[indexPath.row]
            let vc = PlaylistViewController(playlist: playlist)
            vc.title = playlist.name
            vc.navigationItem.largeTitleDisplayMode = .never
            navigationController?.pushViewController(vc, animated: true)
        case .newReleases:
            let album = newAlbums[indexPath.row]
            let vc = AlbumViewController(album: album)
            vc.title = album.name
            vc.navigationItem.largeTitleDisplayMode = .never
            navigationController?.pushViewController(vc, animated: true)
        case .recommendedTracks:
            let track = tracks[indexPath.row]
            PlaybackPresenter.startPlayback(from: self, track: track)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: TitleHeaderCollectionReusableView.identifier,
                for: indexPath) as? TitleHeaderCollectionReusableView,
              kind == UICollectionView.elementKindSectionHeader
        else {
            return UICollectionReusableView()
        }
        let section = indexPath.section
        let title = sections[section].title
        header.cofigure(with: title)
        return header
    }
    
}
