//
//  ViewController.swift
//  iOS_Spotify
//
//  Created by wooyeong kam on 2021/06/25.
//

import UIKit

// 메인 layout에 설정할 section별 데이터 구분
enum BrowseSectionType {
    case newReleases(viewModels: [NewReleasesCellViewModel])
    case featuredPlaylists(viewModels: [FeaturedPlaylistCellViewModel])
    case recommendedTracks(viewModels: [RecommendedTrackCellViewModel])
    // 각 섹션에 헤더로 보여질 제목
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
    
    // 메인 뷰에서 new album, playlist, track  layout
    private var collectionView : UICollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewCompositionalLayout{ sectionIndex, _ -> NSCollectionLayoutSection? in
            return HomeViewController.createSectionLayout(section: sectionIndex)
        }
    )
    
    // 로딩
    private let spinner: UIActivityIndicatorView = {
       let spinner = UIActivityIndicatorView()
        spinner.tintColor = .label
        spinner.hidesWhenStopped = true
        return spinner
    }()
    
    // newalbum, playlist, track 뷰 모델 리스트의 리스트
    private var sections = [BrowseSectionType]()

    // 설정 버튼, 레이아웃, 데이터 쿼리
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
        addLongTapGesture()
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
    
    private func addLongTapGesture() {
        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(didLongPress(_:)))
        collectionView.isUserInteractionEnabled = true
        collectionView.addGestureRecognizer(gesture)
    }
    
    @objc func didLongPress(_ gesture: UILongPressGestureRecognizer) {
        guard gesture.state == .began else {
            return
        }
        let touchPoint = gesture.location(in: collectionView)
        guard let indexPath = collectionView.indexPathForItem(at: touchPoint),
              indexPath.section == 2
        else {
            return
        }
        
        let model = tracks[indexPath.row]
        let actionSheet = UIAlertController(title: model.name,
                                            message: "플레이리스트에 추가하시겠습니까?",
                                            preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        actionSheet.addAction(UIAlertAction(title: "추가하기", style: .default, handler: {[weak self] _ in
            DispatchQueue.main.async {
                let vc = LibraryPlaylistsViewController()
                vc.selectionHandler = {playlist in
                    APICaller.shared.addTrackToPlaylist(track: model, playlist: playlist){ success in
                        print("success")
                    }
                }
                vc.title = "플레이 리스트 선택"
                self?.present(UINavigationController(rootViewController: vc), animated: true, completion: nil)
            }
        }))
        present(actionSheet, animated: true, completion: nil)
    }
    
    // new album, playlist, track 레이아웃 설정
    private static func createSectionLayout(section: Int) -> NSCollectionLayoutSection{
        // 각 섹션의 헤더
        let supplementaryViews = [
            NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                   heightDimension: .absolute(50)
                ),
                                                        
                elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .top)
        ]
        
        switch section {
        // 첫 번째 섹션
        case 0:
            // item
            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0)
                )
            )
            item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
            // vertical group in horizontal, 세로로 3줄
            let verticalGroup = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(390)
                ),
                subitem: item,
                count: 3
            )
            // 가로로 1줄
            let horizontalGroup = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(390)
                ),
                subitem: verticalGroup,
                count: 1
            )
            // section
            let section = NSCollectionLayoutSection(group: horizontalGroup)
            // 섹션에서 페이지 넘기는 방식
            section.orthogonalScrollingBehavior = .groupPaging
            // 섹션의 헤더 설정
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
        // api호출 그룹
        let group = DispatchGroup()
        group.enter()
        group.enter()
        group.enter()
        
        // 최신앨범 리턴해서 받은 데이터
        var newReleases: NewReleasesResponse?
        // 추천 플레이리스트
        var featurePlaylists: FeaturedPlaylistsResponse?
        // 추천 트랙
        var recommendations: RecommendationsResponse?
        
        // 최신앨범 request
        APICaller.shared.getNewRelease{ result in
            defer {
                // 리턴 받은 다음 그룹에서 탈퇴
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
        
        // 추천 받을 수 있는 장르들을 리턴 받은 뒤
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
                // 장르들로 추천 트랙 request
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
    
    
    // 리턴 받은 데이터들로 설정시작
    private func configureModels(newAlbums: [Album], playlists: [playlist], tracks: [AudioTrack]){
        self.newAlbums = newAlbums
        self.playlists = playlists
        self.tracks = tracks
        
        // 최신 앨범 데이터 뷰 모델 리스트로 sections에 추가
        sections.append(.newReleases(viewModels: newAlbums.compactMap({
                return NewReleasesCellViewModel(
                    name: $0.name,
                    artworkURL: URL(string: $0.images.first?.url ?? ""),
                    numberOfTracks: $0.total_tracks,
                    artistName: $0.artists.first?.name ?? "")
            })
        ))
        
        // 추천 플레이리스트 데이터 뷰 모델 리스트로 sections에 추가
        sections.append(.featuredPlaylists(viewModels: playlists.compactMap({
            return FeaturedPlaylistCellViewModel(
                name: $0.name,
                artworkURL: URL(string: $0.images.first?.url ?? ""),
                creatorName: $0.owner.display_name)
            })
        ))
        
        // // 최신 트랙 데이터 뷰 모델 리스트로 sections에 추가
        sections.append(.recommendedTracks(viewModels: tracks.compactMap({
            return RecommendedTrackCellViewModel(
                name: $0.name,
                artistName: $0.artists.first?.name ?? "",
                artworkURL: URL(string: $0.album?.images.first?.url ?? ""))
            })
        ))
        
        // 메인화면 업데이트
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
        // 각 섹션에 들어간 newAlbum, playlist, track 수에 맞게 섹션 별 셀 개수 설정
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
        // new album, playlist, track 섹션
        return sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // 각 섹션 당
        let type = sections[indexPath.section]
        
        switch type{
        // newalbum일 경우
        case .newReleases(let viewModels):
            guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: NewReleaseCollectionViewCell.identifier,
                    for: indexPath) as? NewReleaseCollectionViewCell else {
                return UICollectionViewCell()
            }
            // 각 셀을 newalbum 리스트에 순서대로 설정
            let viewModel = viewModels[indexPath.row]
            cell.configure(with: viewModel)
            return cell
            
        case .featuredPlaylists(let viewModels):
            // 추천 플레이리스트일 경우, 리스트에 있는 것들을 순서대로 셀로 설정
            guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: FeaturedPlaylistCollectionViewCell.identifier,
                    for: indexPath) as? FeaturedPlaylistCollectionViewCell else {
                return UICollectionViewCell()
            }
            
            cell.configure(with: viewModels[indexPath.row])
            return cell
            
        case .recommendedTracks(let viewModels):
            // 추천 트랙일 경우,  리스트에 있는 것들을 순서대로 셀로 설정
            guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: RecommendedTrackCollectionViewCell.identifier,
                    for: indexPath) as? RecommendedTrackCollectionViewCell else {
                return UICollectionViewCell()
            }
            cell.configure(with: viewModels[indexPath.row])
            return cell
        }
    }
    
    // 셀이 클릭 되었을 때
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        // 클릭된 섹션에서
        let section = sections[indexPath.section]
        switch section {
            // 플레이 리스트 섹션에서
        case .featuredPlaylists:
            // 해당하는 순서의 셀
            let playlist = playlists[indexPath.row]
            // PlaylistViewController로 전환
            let vc = PlaylistViewController(playlist: playlist)
            vc.title = playlist.name
            vc.navigationItem.largeTitleDisplayMode = .never
            navigationController?.pushViewController(vc, animated: true)
            
            // 최신 앨범 섹션에서
        case .newReleases:
            // 최신 앨범 리스트에 해당하는 순서의 셀
            let album = newAlbums[indexPath.row]
            // 앨범 뷰로 전환
            let vc = AlbumViewController(album: album)
            vc.title = album.name
            vc.navigationItem.largeTitleDisplayMode = .never
            navigationController?.pushViewController(vc, animated: true)
            
            // 추천 트랙에서
        case .recommendedTracks:
            // 추천 트랙 리스트에 해당하는 순서의 셀
            let track = tracks[indexPath.row]
            // 음악 재생 뷰로 전환
            PlaybackPresenter.shared.startPlayback(from: self, track: track)
        }
    }
    
    // 각 섹션의 헤더
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: TitleHeaderCollectionReusableView.identifier,
                for: indexPath) as? TitleHeaderCollectionReusableView,
              kind == UICollectionView.elementKindSectionHeader
        else {
            return UICollectionReusableView()
        }
        // 해당하는 섹션에서
        let section = indexPath.section
        let title = sections[section].title
        header.cofigure(with: title)
        return header
    }
    
}
